import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'assignment_api.dart' as api;
import 'assignment_model.dart';

class AssignmentListController extends GetxController {
  final supabase = Supabase.instance.client;
  final String grnId;

  AssignmentListController(this.grnId);

  final assignments = <CrateAssignmentModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchAssignments();
    super.onInit();
  }

  //   Future<void> fetchAssignments() async {
  //     try {
  //       isLoading.value = true;
  //
  //       final res = await supabase
  //           .from('crate_assignments')
  //           .select()
  //           .order('created_at', ascending: false);
  //
  //       assignments.value = res as List;
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  // }

  Future<void> startAssignment(int id) async {
    await api.startAssignment(id); // sets started_at = now()
  }

  Future<void> finishAssignment(int id) async {
    await finishAssignment(id); // sets finished_at = now()
  }

  Future<void> fetchAssignments() async {
    try {
      isLoading.value = true;

      final res = await supabase
          .from('crate_assignments')
          .select('''
      id,
      grn_id,
      crate_id,
      crate_code,
      packer_code,
      bag_size_kg,
      bag_count,
      status,
      started_at,
      finished_at,
      created_at,
      note
    ''')
          .eq('grn_id', grnId)
          .order('created_at', ascending: false);

      assignments.assignAll(
        (res as List).map((e) => CrateAssignmentModel.fromJson(e)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
