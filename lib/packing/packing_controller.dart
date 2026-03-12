import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../assignment/assignment_list_controller.dart';

class PackingController extends GetxController {
  final supabase = Supabase.instance.client;

  final String assignmentId;
  final String crateId;

  PackingController({
    required this.assignmentId,
    required this.crateId,
  });

  final isLoading = false.obs;
  final assignmentStatus = 'PENDING'.obs;

  final noteController = TextEditingController();

  @override
  void onInit() {
    fetchAssignmentStatus();
    super.onInit();
  }

  Future<void> fetchAssignmentStatus() async {
    isLoading.value = true;

    final res = await supabase
        .from('crate_assignments')
        .select('status')
        .eq('id', assignmentId)
        .single();

    assignmentStatus.value = res['status'];
    isLoading.value = false;
  }

  Future<void> startPacking() async {
    await supabase.from('crate_assignments').update({
      'started_at': DateTime.now().toIso8601String(),
      'status': 'IN_PROGRESS',
    }).eq('id', assignmentId);

    await supabase.from('grn_crates').update({
      'status': 'PACKING',
    }).eq('crate_code', crateId);
    assignmentStatus.value = 'IN_PROGRESS';
  }

  Future<void> startAssignment(int id) async {
    await supabase
        .from('grn_crates')
        .update({'started_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  Future<void> finishAssignment(int id) async {
    await supabase
        .from('grn_crates')
        .update({'finished_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  Future<void> finishPacking() async {
    await supabase.from('crate_assignments').update({
      'finished_at': DateTime.now().toIso8601String(),
      'status': 'PACKED',
      'note': noteController.text,
    }).eq('id', assignmentId);

    await supabase.from('grn_crates').update({
      'status': 'PACKED',
    }).eq('crate_code', crateId);

    assignmentStatus.value = 'DONE';

    Get.back(result: true); // 🔄 trigger refresh
  }
}


// 🔥 START PACKING
  // Future<void> startPacking() async {
  //   try {
  //     isLoading.value = true;
  //
  //     await supabase
  //         .from('crate_assignments')
  //         .update({
  //       'status': 'IN_PROGRESS',
  //       'started_at': DateTime.now().toIso8601String(),
  //     })
  //         .eq('id', assignmentId);
  //
  //     await supabase
  //         .from('grn_crates')
  //         .update({'status': 'PACKING'})
  //         .eq('id', crateId);
  //
  //     assignmentStatus.value = 'IN_PROGRESS'; // 🔥 local update
  //
  //     Get.snackbar('Started', 'Packing started');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  // ✅ FINISH PACKING
  // Future<void> finishPacking() async {
  //   try {
  //     isSaving.value = true;
  //
  //     await supabase
  //         .from('crate_assignments')
  //         .update({
  //       'status': 'PACKED',
  //       'finished_at': DateTime.now().toIso8601String(),
  //       'note': noteController.value.isEmpty
  //           ? null
  //           : noteController.value,
  //     })
  //         .eq('id', assignmentId);
  //
  //     await supabase
  //         .from('grn_crates')
  //         .update({'status': 'PACKED'})
  //         .eq('id', crateId);
  //
  //     /// 🔄 REFRESH LIST
  //     Get.find<AssignmentListController>().fetchAssignments();
  //
  //     Get.back(); // go back to list
  //
  //     Get.snackbar('Success', 'Packing completed');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isSaving.value = false;
  //   }
  // }



