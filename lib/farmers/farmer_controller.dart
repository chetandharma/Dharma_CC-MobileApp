import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'farmer_model.dart';

class FarmerController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var farmers = <FarmerModel>[].obs;
  var isLoading = false.obs;
  final searchQuery = ''.obs;
  RxString statusFilter = 'all'.obs;



  @override
  void onInit() {
    fetchFarmers();
    super.onInit();
  }
  // List<FarmerModel> get filteredFarmers {
  //   if (searchQuery.value.isEmpty) return farmers;
  //
  //   return farmers.where((f) =>
  //   f.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
  //       f.farmerCode.toLowerCase().contains(searchQuery.value.toLowerCase())
  //   ).toList();
  // }
  List<FarmerModel> get filteredFarmers {
    return farmers.where((farmer) {
      final matchesSearch = farmer.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()) ||
          farmer.farmerCode
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      final matchesStatus = statusFilter.value == 'all'
          ? true
          : statusFilter.value == 'active'
          ? farmer.isActive
          : !farmer.isActive;

      return matchesSearch && matchesStatus;
    }).toList();
  }


  Future<void> fetchFarmers() async {
    try {
      isLoading(true);

      final data = await supabase
          .from('farmers')
          .select(
        'id, name, phone, rating, bank_account, ifsc, is_active, farmer_code, created_at',
      )
          .order('name');

      farmers.assignAll(
        (data as List).map(
              (e) => FarmerModel.fromMap(e),
        ),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}