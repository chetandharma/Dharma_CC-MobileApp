import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentController extends GetxController {
  final supabase = Supabase.instance.client;

  final String grnId;
  final String grnNo;

  AssignmentController({
    required this.grnId,
    required this.grnNo,
  });

  // DATA
  final crates = <Map<String, dynamic>>[].obs;
  final packers = <String>[].obs;

  // SELECTIONS
  final selectedCrates = <Map<String, dynamic>>[].obs;
  final selectedPackers = <String>[].obs;

  final bagSize = RxnInt();
  final bagCount = 0.obs;

  final isSaving = false.obs;

  static const double crateCapacity = 50;

  @override
  void onInit() {
    fetchCrates();
    fetchPackers();
    super.onInit();
  }

  // 🔹 Fetch GRN crates
  Future<void> fetchCrates() async {
    final res = await supabase
        .from('grn_crates')
        .select('id, crate_code')
        .eq('grn_id', grnId)
        .order('crate_code');

    crates.assignAll(res);
  }

  // 🔹 Fetch packers
  Future<void> fetchPackers() async {
    final res = await supabase
        .from('employees')
        .select('emp_code')
        .eq('role', 'PACKER');

    packers.assignAll(
      (res as List).map((e) => e['emp_code'] as String).toList(),
    );
  }

  // 🔹 Auto calculate bags
  void calculateBags() {
    if (bagSize.value == null || selectedCrates.isEmpty) {
      bagCount.value = 0;
      return;
    }

    final totalQty = selectedCrates.length * crateCapacity;
    bagCount.value = (totalQty / bagSize.value!).round();
  }

  bool get canSave =>
      selectedCrates.isNotEmpty &&
          selectedPackers.isNotEmpty &&
          bagSize.value != null;

  // 🔥 SAVE ASSIGNMENT
  Future<void> saveAssignment() async {
    if (!canSave) {
      Get.snackbar('Validation', 'Select crates, packers & bag size');
      return;
    }

    try {
      isSaving.value = true;

      final rows = <Map<String, dynamic>>[];

      for (final crate in selectedCrates) {
        for (final packer in selectedPackers) {
          rows.add({
            'grn_id': grnId,
            'crate_id': crate['id'],
            'crate_code': crate['crate_code'],
            'packer_code': packer,
            'bag_size_kg': bagSize.value,
            'bag_count': bagCount.value,
          });
        }
      }

      await supabase.from('crate_assignments').insert(rows);

      Get.back();
      Get.snackbar('Success', 'Crates assigned successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
