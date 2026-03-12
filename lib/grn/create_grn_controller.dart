import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../farmers/farmer_model.dart';
import '../models/collection_center_model.dart';
import '../models/crate_model.dart';
import '../models/procurement_item_model.dart';
import '../models/product_model.dart';

class CreateGrnController extends GetxController {
  final supabase = Supabase.instance.client;

  final farmers = <FarmerModel>[].obs;
  final centers = <CollectionCenterModel>[].obs;
  final products = <ProductModel>[].obs;

  final selectedFarmer = Rxn<FarmerModel>();
  final selectedCenter = Rxn<CollectionCenterModel>();
  final selectedProduct = Rxn<ProductModel>();

  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  /// GRN fields
  final farmerCode = ''.obs;
  final centerCode = ''.obs;

  /// Procurement form fields
  final productCode = ''.obs;
  final qualityGrade = ''.obs;
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  /// Items list
  final items = <ProcurementItem>[].obs;

  final isSubmitting = false.obs;
  final availableCrates = <CrateMaster>[].obs;
  final assignedCrates = <CrateMaster>[].obs;

  final selectedCrate = Rxn<CrateMaster>();

  static const double crateCapacity = 50;

  // ---------- HELPERS ----------
  bool get canAddItem =>
      productCode.value.isNotEmpty &&
          qualityGrade.value.isNotEmpty &&
          qtyController.text.isNotEmpty &&
          priceController.text.isNotEmpty;

  // bool get canSubmit =>
  //     farmerCode.value.isNotEmpty &&
  //         centerCode.value.isNotEmpty &&
  //         items.isNotEmpty;
  bool get canSubmit =>
      selectedFarmer.value != null &&
          selectedCenter.value != null &&
          items.isNotEmpty &&
          isCrateAssignmentComplete;


  double get totalQuantity =>
      items.fold(0, (sum, e) => sum + e.quantity);

  @override
  void onInit() {
    fetchFarmers();
    fetchCenters();
    fetchProducts();
    super.onInit();
  }
  // ---------- ACTIONS ----------
  Future<void> addItem() async {
    if (!canAddItem) {
      Get.snackbar('Validation', 'Fill all procurement fields');
      return;
    }

    items.add(
      ProcurementItem(
        productCode: productCode.value,
        quantity: double.parse(qtyController.text),
        qualityGrade: qualityGrade.value,
        price: double.parse(priceController.text),
      ),
    );

    // reset
    productCode.value = '';
    qualityGrade.value = '';
    qtyController.clear();
    priceController.clear();
    await fetchAvailableCrates();
    autoAssignCratesFIFO();

  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  // Future<void> submitGRN() async {
  //   if (!canSubmit) {
  //     Get.snackbar('Validation', 'GRN details or items missing');
  //     return;
  //   }
  //
  //   try {
  //     isSubmitting.value = true;
  //
  //     // 1️⃣ Insert GRN
  //     final grnRes = await supabase
  //         .from('grns')
  //         .insert({
  //       'farmer_code': farmerCode.value,
  //       'center_code': centerCode.value,
  //       'total_quantity': totalQuantity,
  //       'payment_status': 'PENDING',
  //     })
  //         .select('grn_no')
  //         .single();
  //
  //     final String grnNo = grnRes['grn_no'];
  //
  //     // 2️⃣ Insert ALL procurement items
  //     await supabase.from('procurement_entries').insert(
  //       items.map((item) {
  //         return {
  //           'grn_no': grnNo,
  //           'product_code': item.productCode,
  //           'quantity_kg': item.quantity,
  //           'quality_grade': item.qualityGrade,
  //           'price_per_kg': item.price,
  //         };
  //       }).toList(),
  //     );
  //
  //     // 3️⃣ AUTO CREATE CRATES
  //     final int totalCrates =
  //     (totalQuantity / crateCapacity).ceil();
  //
  //     double remainingQty = totalQuantity;
  //
  //     final List<Map<String, dynamic>> crates = [];
  //
  //     for (int i = 1; i <= totalCrates; i++) {
  //       final double crateQty =
  //       remainingQty >= crateCapacity ? crateCapacity : remainingQty;
  //
  //       crates.add({
  //         'grn_no': grnNo,
  //         'crate_no': i,
  //         'capacity_kg': crateCapacity,
  //         'current_quantity_kg': crateQty,
  //         'status': 'UNPACKED',
  //       });
  //
  //       remainingQty -= crateQty;
  //     }
  //
  //     await supabase.from('grn_crates').insert(crates);
  //
  //     Get.back();
  //     Get.snackbar(
  //       'Success',
  //       'GRN created with $totalCrates crates',
  //     );
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

  Future<void> submitGRN() async {
    if (!canSubmit || !isCrateAssignmentComplete) {
      Get.snackbar('Validation', 'Complete all steps');
      return;
    }

    try {
      isSubmitting.value = true;

      // 1️⃣ Insert GRN
      final grnRes = await supabase
          .from('grns')
          .insert({
        'farmer_code': selectedFarmer.value!.farmerCode,
        'center_code': selectedCenter.value!.code,
        'total_quantity': totalQuantity,

      })
          .select('id, grn_no')
          .single();

      final String grnId = grnRes['id'];
      final String grnNo = grnRes['grn_no'];

      // 2️⃣ Insert procurement items
      await supabase.from('procurement_entries').insert(
        items.map((e) => {
          'grn_no': grnNo,
          'product_code': e.productCode,
          'quantity_kg': e.quantity,
          'quality_grade': e.qualityGrade,
          'price_per_kg': e.price,
        }).toList(),
      );

      // 🔥 3️⃣ Create + assign crates (FIFO + partial)
      await _createAndAssignCrates(grnId, grnNo);

      Get.back();
      Get.snackbar('Success', 'GRN created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }



  int get requiredCrates =>
      (totalQuantity / crateCapacity).ceil();

  int get availableCrateCount => availableCrates.length;
  int get assignedCrateCount => assignedCrates.length;

  bool get isCrateAssignmentComplete =>
      assignedCrateCount >= requiredCrates;

  Future<void> fetchAvailableCrates() async {
    final res = await supabase
        .from('crate_master')
        .select()
        .eq('status', 'AVAILABLE')
        .eq('capacity_kg', crateCapacity);

    availableCrates.value =
        (res as List).map((e) => CrateMaster.fromJson(e)).toList();
  }


  void assignCrate() {
    if (selectedCrate.value == null) return;

    if (assignedCrates.length >= requiredCrates) {
      Get.snackbar('Info', 'Required crates already assigned');
      return;
    }

    assignedCrates.add(selectedCrate.value!);
    availableCrates.remove(selectedCrate.value);
    selectedCrate.value = null;
  }

  Future<void> _createAndAssignCrates(
      String grnId,
      String grnNo,
      ) async {
    double remainingQty = totalQuantity;

    List<Map<String, dynamic>> grnCrates = [];

    for (int i = 0; i < assignedCrates.length; i++) {
      final crate = assignedCrates[i];

      final loadQty =
      remainingQty >= crateCapacity
          ? crateCapacity
          : remainingQty;

      grnCrates.add({
        'grn_id': grnId,
        'crate_code': crate.crateCode,
        'total_quantity_kg': crateCapacity,
        'remaining_quantity_kg': loadQty,
        'status': 'UNPACKED',
        'qr_code': '$grnNo-${crate.crateCode}',
      });

      remainingQty -= loadQty;
    }

    // 1️⃣ insert GRN crates
    await supabase.from('grn_crates').insert(grnCrates);

    // 2️⃣ mark crate_master as IN_USE
    await supabase
        .from('crate_master')
        .update({'status': 'IN_USE'})
        .inFilter(
      'id',
      assignedCrates.map((e) => e.id).toList(),
    );

  }

  Future<void> deleteGrn(String grnId) async {
    await supabase
        .from('grns')
        .delete()
        .eq('id', grnId);

    Get.back(); // go back to list
    Get.snackbar('Deleted', 'GRN deleted successfully');
  }


  Future<List<CrateMaster>> fetchFifoCrates(int limit) async {
    final res = await supabase
        .from('crate_master')
        .select()
        .eq('status', 'AVAILABLE')
        .eq('capacity_kg', crateCapacity)
        .order('created_at') // FIFO 🔥
        .limit(limit);

    return (res as List)
        .map((e) => CrateMaster.fromJson(e))
        .toList();
  }

  Future<void> autoAssignCratesFIFO() async {
    final crates = await fetchFifoCrates(requiredCrates);
    assignedCrates.assignAll(crates);
  }




  Future<void> fetchFarmers() async {
    final data = await supabase
        .from('farmers')
        .select()
        .eq('is_active', true);

    farmers.assignAll(
      (data as List)
          .map((e) => FarmerModel.fromMap(e))
          .toList(),
    );
  }

  Future<void> fetchCenters() async {
    final data = await supabase
        .from('collection_centers')
        .select('center_code, name');

    centers.assignAll(
      (data as List).map((e) => CollectionCenterModel.fromMap(e)).toList(),
    );
  }

  Future<void> fetchProducts() async {
    final data = await supabase
        .from('products')
        .select('product_code, name');

    products.assignAll(
      (data as List).map((e) => ProductModel.fromMap(e)).toList(),
    );
  }
// Future<void> submitGrn() async {
  //   if (!canSubmit) {
  //     Get.snackbar('Validation', 'GRN details or items missing');
  //     return;
  //   }
  //
  //   try {
  //     isSubmitting.value = true;
  //
  //     // 1️⃣ Insert GRN
  //     final grn = await supabase
  //         .from('grns')
  //         .insert({
  //       'farmer_code': farmerCode.value,
  //       'center_code': centerCode.value,
  //       'total_quantity': totalQuantity,
  //       'payment_status': 'PENDING',
  //     })
  //         .select('grn_no')
  //         .single();
  //
  //     final String grnNo = grn['grn_no'];
  //
  //     // 2️⃣ Insert procurement items
  //     await supabase.from('procurement_entries').insert(
  //       items
  //           .map((e) => {
  //         'grn_no': grnNo,
  //         'product_code': e.productCode,
  //         'quantity_kg': e.quantity,
  //         'quality_grade': e.qualityGrade,
  //         'price_per_kg': e.price,
  //       })
  //           .toList(),
  //     );
  //
  //     Get.back();
  //     Get.snackbar('Success', 'GRN created successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
}
