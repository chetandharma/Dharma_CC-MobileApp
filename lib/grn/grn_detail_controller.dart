import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'grn_controller.dart';

class GrnDetailController extends GetxController {
  final supabase = Supabase.instance.client;

  final String grnNo;
  GrnDetailController(this.grnNo);

  final isLoading = true.obs;

  // GRN info
  final farmerCode = ''.obs;
  final centerCode = ''.obs;
  final totalQuantity = 0.0.obs;
  final paymentStatus = ''.obs;
  final grnDate = ''.obs;

  // Procurement items
  final items = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchDetails();
    super.onInit();
  }

  Future<void> fetchDetails() async {
    try {
      isLoading.value = true;

      // 1️⃣ Fetch GRN
      final grn = await supabase
          .from('grns')
          .select(
          'farmer_code, center_code, total_quantity, payment_status, grn_date')
          .eq('grn_no', grnNo)
          .single();

      farmerCode.value = grn['farmer_code'];
      centerCode.value = grn['center_code'];
      totalQuantity.value =
          (grn['total_quantity'] ?? 0).toDouble();
      paymentStatus.value = grn['payment_status'];
      grnDate.value = grn['grn_date'];

      // 2️⃣ Fetch procurement items
      final data = await supabase
          .from('procurement_entries')
          .select(
          'product_code, quantity_kg, quality_grade, price_per_kg')
          .eq('grn_no', grnNo)
          .order('created_at');

      items.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePaymentStatus({
    required String grnId,
  })  async {
    try {
      await supabase
          .from('grns')
          .update({
        'payment_status': 'PAID',
      })
          .eq('id', grnId);

      // refresh list + navigate
      Get.find<GrnController>().fetchGrns();
      Get.offAllNamed('/grn-list');

      Get.snackbar('Success', 'GRN marked as PAID');
    } on PostgrestException catch (e) {
      print('❌ Payment update error: ${e.message}');
      print('Details: ${e.details}');
      print('Hint: ${e.hint}');
      Get.snackbar('Error', e.message);
    }
  }

  Future<void> deleteGrn(String grnId) async {
    if (grnId.trim().isEmpty) {
      print('❌ Delete aborted: grnId is empty');
      Get.snackbar('Error', 'Invalid GRN ID');
      return;
    }

    try {
      await supabase
          .from('grns')
          .delete()
          .eq('id', grnId);

      print('✅ GRN deleted: $grnId');

      Get.find<GrnController>().fetchGrns();
      Get.offAllNamed('/grn-list');

      Get.snackbar('Success', 'GRN deleted successfully');
    } on PostgrestException catch (e) {
      print('❌ Supabase delete error: ${e.message}');
      print('Details: ${e.details}');
      print('Hint: ${e.hint}');
      Get.snackbar('Delete Failed', e.message);
    }
  }
}
