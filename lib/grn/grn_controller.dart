import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/grn_model.dart';

class GrnController extends GetxController {
  final _supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var grnList = <GrnModel>[].obs;

  @override
  void onInit() {
    fetchGrns();
    super.onInit();
  }

  Future<void> fetchGrns() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('grns')
          .select('id, grn_no, farmer_code, center_code, grn_date, total_quantity, payment_status')

              .order('created_at', ascending: false);

      grnList.value =
          (response as List).map((e) => GrnModel.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
