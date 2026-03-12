import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dispatch_model.dart';

class DispatchController extends GetxController {
  final supabase = Supabase.instance.client;

  final String grnNo;
  final List<DispatchCrateListModel> initialCrates;

  DispatchController({
    required this.grnNo,
    required this.initialCrates,
  });

  final selectedClientId = ''.obs;
  final selectedBranchId = ''.obs;
  final vehicleNo = ''.obs;

  final isSaving = false.obs;

  final vehicles = [
    'PB10AB1234',
    'PB08CD5678',
    'HR26EF9090',
  ];

  final crates = <DispatchCrateListModel>[].obs;
  var destination = ''.obs;

  @override
  void onInit() {
    /// Instead of fetching again,
    /// use selected crates from previous page
    crates.assignAll(initialCrates);
    selectedBranchId.value = '';
    super.onInit();
  }
  /// 🔹 Total Quantity
  double get totalDispatchQty =>
      crates.fold(0.0, (sum, c) => sum + c.dispatchQty);

  /// 🔹 Validation
  bool get canSubmit {
    if (selectedClientId.value.isEmpty ||
        selectedBranchId.value.isEmpty ||
        vehicleNo.value.isEmpty) {
      return false;
    }

    return crates.isNotEmpty;
  }
  // bool get canSubmit {
  //   if (destination.value.isEmpty ||
  //       vehicleNo.value.isEmpty ||
  //       selectedClientId.value.isEmpty ||
  //       selectedBranchId.value.isEmpty) {
  //     return false;
  //   }
  //
  //   return crates.any(
  //     (c) => c.dispatchQty > 0 && c.dispatchQty <= c.remainingQty,
  //   );
  // }

  /// 🔹 Submit Dispatch
  Future<void> submitDispatch() async {
    if (!canSubmit) {
      Get.snackbar(
        'Validation',
        'Please select destination, vehicle and valid quantities',
      );
      return;
    }

    try {
      isSaving.value = true;

      final userId = supabase.auth.currentUser?.id;

      final validCrates = crates.where(
            (e) => e.dispatchQty > 0 && e.dispatchQty <= e.remainingQty,
      ).toList();

      final totalCrates = validCrates.length;
      final totalQty = validCrates.fold<double>(
        0,
            (sum, c) => sum + c.dispatchQty,
      );

      /// 1️⃣ Insert dispatch header
      final dispatchResponse = await supabase
          .from('dispatches')
          .insert({
        'grn_id': grnNo,
        'destination': destination.value,
        'vehicle_no': vehicleNo.value,
        'dispatched_by': userId,
        'status': 'COMPLETED',
        'total_crates': totalCrates,
        'total_quantity_kg': totalQty,
      })
          .select('id')
          .single();

      final dispatchId = dispatchResponse['id'];

      /// 2️⃣ Insert dispatch crates (batch)
      final crateInsertList = validCrates.map((c) {
        return {
          'dispatch_id': dispatchId,
          'crate_code': c.crateCode,
          'quantity_kg': c.dispatchQty,
        };
      }).toList();

      await supabase.from('dispatch_crates').insert(crateInsertList);

      /// 3️⃣ Update GRN crates
      for (final c in validCrates) {
        final remaining = c.remainingQty - c.dispatchQty;

        await supabase
            .from('grn_crates')
            .update({
          'remaining_quantity_kg': remaining,
          'status': remaining == 0
              ? 'DISPATCHED'
              : 'PARTIAL_DISPATCH',
        })
            .eq('id', c.id);
      }

      Get.back();
      Get.snackbar('Success', 'Dispatch completed successfully');

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}

// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dispatch_model.dart';
// import 'dispatchlist_model.dart';
//
// class DispatchController extends GetxController {
//   final supabase = Supabase.instance.client;
//   final String grnNo;
//
//   DispatchController(this.grnNo);
//
//   var destination = ''.obs;
//   var vehicleNo = ''.obs;
//   var isSaving = false.obs;
//
//   /// Static dropdowns (can move to DB later)
//   final destinations = [
//     'Blinkit',
//     'Zomato',
//     'Swiggy',
//     'Amazon',
//   ];
//
//   final vehicles = [
//     'PB10AB1234',
//     'PB08CD5678',
//     'HR26EF9090',
//   ];
//
//   final crates = <DispatchCrateList>[].obs;
//
//   @override
//   void onInit() {
//     fetchCrates();
//     super.onInit();
//   }
//
//   /// 🔹 Fetch crates ready for dispatch
//   Future<void> fetchCrates() async {
//     try {
//       final data = await supabase
//           .from('grn_crates')
//           .select('crate_code, remaining_quantity_kg')
//           .eq('grn_id', grnNo)
//           .eq('status', 'PACKED')
//           .order('crate_code');
//       crates.assignAll((data as List).map((e) => DispatchCrateList.fromMap(e)));
//       // crates.assignAll(
//       //   (data as List).map((e) => DispatchCrateList(
//       //     crateCode: e['crate_code'],
//       //     totalQty: e['totalQty'],
//       //     remainingQty:
//       //     (e['remaining_quantity_kg'] as num).toDouble(),
//       //   )),
//       // );
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load crates');
//     }
//   }
//
//   /// 🔹 Validation
//   // bool get canSubmit {
//   //   if (destination.value.isEmpty ||
//   //       vehicleNo.value.isEmpty) {
//   //     return false;
//   //   }
//   //
//   //   /// At least one valid dispatch qty
//   //   return crates.any((c) =>
//   //   c.dispatchQty > 0 &&
//   //       c.dispatchQty <= c.remainingQty);
//   // }
//   //
//   // /// 🔹 Submit Dispatch
//   // Future<void> submitDispatch() async {
//   //   if (!canSubmit) {
//   //     Get.snackbar('Validation', 'Please enter valid quantities');
//   //     return;
//   //   }
//   //
//   //   try {
//   //     isSaving.value = true;
//   //
//   //     /// 1️⃣ Create Dispatch Header
//   //     final dispatch = await supabase
//   //         .from('dispatches')
//   //         .insert({
//   //       'grn_no': grnNo,
//   //       'destination': destination.value,
//   //       'vehicle_no': vehicleNo.value,
//   //     })
//   //         .select('id')
//   //         .single();
//   //
//   //     final dispatchId = dispatch['id'];
//   //
//   //     /// 2️⃣ Insert crate-wise dispatch
//   //     for (final c in crates.where((e) =>
//   //     e.dispatchQty > 0 &&
//   //         e.dispatchQty <= e.remainingQty)) {
//   //
//   //       final remaining =
//   //           c.remainingQty - c.dispatchQty;
//   //
//   //       /// Insert into dispatch_crates
//   //       await supabase.from('dispatch_crates').insert({
//   //         'dispatch_id': dispatchId,
//   //         'grn_no': grnNo,
//   //         'crate_no': c.crateNo,
//   //         'quantity_kg': c.dispatchQty,
//   //       });
//   //
//   //       /// Update grn_crates
//   //       await supabase
//   //           .from('grn_crates')
//   //           .update({
//   //         'remaining_quantity_kg': remaining,
//   //         'status': remaining == 0
//   //             ? 'DISPATCHED'
//   //             : 'PARTIAL_DISPATCH',
//   //       })
//   //           .eq('grn_no', grnNo)
//   //           .eq('crate_no', c.crateNo);
//   //     }
//   //
//   //     Get.back();
//   //     Get.snackbar(
//   //       'Success',
//   //       'Dispatch completed successfully',
//   //     );
//   //   } catch (e) {
//   //     Get.snackbar('Error', e.toString());
//   //   } finally {
//   //     isSaving.value = false;
//   //   }
//   // }
// }
