import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'branch_model.dart';
import 'clients_model.dart';



class ClientController extends GetxController {
  final supabase = Supabase.instance.client;

  var clients = <ClientModel>[].obs;
  var branches = <BranchModel>[].obs;


  var isLoading = false.obs;

  @override
  void onInit() {
    fetchClients();
    super.onInit();

  }

  Future<void> fetchClients() async {
    try {
      isLoading(true);

      final response = await supabase
          .from('clients')
          .select()
          .eq('is_active', true)
          .order('client_name');

      clients.assignAll(
        (response as List)
            .map((e) => ClientModel.fromMap(e))
            .toList(),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBranches(String clientId) async {
    try {
      branches.clear();


      final response = await supabase
          .from('client_branches')
          .select()
          .eq('client_id', clientId)
          .eq('is_active', true)
          .order('branch_name');

      branches.assignAll(
        (response as List)
            .map((e) => BranchModel.fromMap(e))
            .toList(),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}