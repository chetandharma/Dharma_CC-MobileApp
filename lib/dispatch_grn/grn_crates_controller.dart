import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../assignment/assignment_api.dart';
import 'grn_dispatch_crate_model.dart';




class GrnDispatchCratesController extends GetxController {
  final String grnId;
  GrnDispatchCratesController(this.grnId);

  var isLoading = true.obs;
  var crates = <GrnDispatchCrateModel>[].obs;
  var selectedCrates = <String>{}.obs;

  @override
  void onInit() {
    fetchCrates();
    super.onInit();
  }

  Future<void> fetchCrates() async {
    isLoading.value = true;

    final response = await supabase
        .from('grn_crates')
        .select()
        .eq('grn_id', grnId);

    crates.value = response
        .map<GrnDispatchCrateModel>((e) => GrnDispatchCrateModel.fromJson(e))
        .toList();

    isLoading.value = false;
  }

  void toggleSelection(GrnDispatchCrateModel crate) {
    if (selectedCrates.contains(crate.id)) {
      selectedCrates.remove(crate.id);
    } else {
      selectedCrates.add(crate.id);
    }
  }

  int get totalSelectedQty {
    return crates
        .where((c) => selectedCrates.contains(c.id))
        .fold(0, (sum, item) => sum + item.totalQty);
  }
}