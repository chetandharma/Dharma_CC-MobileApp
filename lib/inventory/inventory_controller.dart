import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'inventory_list_model.dart';

class InventoryController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var procurements = <InventoryListModel>[].obs;
  var isLoading = false.obs;

  // filters
  var selectedGrade = ''.obs; // A / B / C
  var productCode = ''.obs;

  // total quantity
  double get totalQuantityKg {
    return procurements.fold(
      0.0,
          (sum, item) => sum + item.quantityKg,
    );
  }

  @override
  void onInit() {
    fetchProcurements();
    super.onInit();
  }

  Future<void> fetchProcurements({
    String? grade,
    String? code,
  }) async {
    try {
      isLoading(true);

      var query = supabase
          .from('procurement_entries')
          .select(
        'id, quantity_kg, price_per_kg, grn_no, product_code, quality_grade, created_at',
      );

      // 🎯 filter by grade
      if (grade != null && grade.isNotEmpty) {
        query = query.eq('quality_grade', grade);
      }

      // 🎯 filter by product code
      if (code != null && code.isNotEmpty) {
        query = query.ilike('product_code', '%$code%');
      }

      final data = await query.order('created_at', ascending: false);

      procurements.assignAll(
        (data as List).map((e) => InventoryListModel.fromMap(e)),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void onGradeChanged(String value) {
    selectedGrade.value = value;
    fetchProcurements(
      grade: value,
      code: productCode.value,
    );
  }

  void onProductCodeChanged(String value) {
    productCode.value = value;
    fetchProcurements(
      grade: selectedGrade.value,
      code: value,
    );
  }
}