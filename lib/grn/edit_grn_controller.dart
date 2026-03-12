import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditGrnController extends GetxController {
  final supabase = Supabase.instance.client;
  final String grnNo;

  EditGrnController(this.grnNo);

  final isLoading = false.obs;

  // Header
  final farmerCode = ''.obs;
  final centerCode = ''.obs;

  // Procurement item (single entry)
  final productCode = ''.obs;
  final quantityKg = 0.0.obs;
  final qualityGrade = 'A'.obs;
  final pricePerKg = 0.0.obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final grn = await supabase
          .from('grns')
          .select('farmer_code, center_code')
          .eq('grn_no', grnNo)
          .single();

      farmerCode.value = grn['farmer_code'];
      centerCode.value = grn['center_code'];

      final item = await supabase
          .from('procurement_entries')
          .select(
          'product_code, quantity_kg, quality_grade, price_per_kg')
          .eq('grn_no', grnNo)
          .limit(1)
          .single();

      productCode.value = item['product_code'];
      quantityKg.value = (item['quantity_kg']).toDouble();
      qualityGrade.value = item['quality_grade'];
      pricePerKg.value = (item['price_per_kg']).toDouble();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGRN() async {
    try {
      isLoading.value = true;

      await supabase.from('grns').update({
        'farmer_code': farmerCode.value,
        'center_code': centerCode.value,
        'total_quantity': quantityKg.value,
      }).eq('grn_no', grnNo);

      await supabase.from('procurement_entries').update({
        'product_code': productCode.value,
        'quantity_kg': quantityKg.value,
        'quality_grade': qualityGrade.value,
        'price_per_kg': pricePerKg.value,
      }).eq('grn_no', grnNo);

      Get.back();
      Get.snackbar('Success', 'GRN updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
