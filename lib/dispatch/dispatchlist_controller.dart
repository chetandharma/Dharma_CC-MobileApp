import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dispatch_model.dart';
import 'dispatchlist_model.dart';

class DispatchListController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var crates = <DispatchCrateListModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPackedCrates();
    super.onInit();
  }

  /// 🔹 Fetch packed crates with available stock
  Future<void> fetchPackedCrates() async {
    try {
      isLoading(true);

      final data = await supabase
          .from('grn_crates')
          .select(
        'id, grn_id, qr_code, crate_code, total_quantity_kg, remaining_quantity_kg, status, created_at',
      )
          .eq('status', 'PACKED')
          .gt('remaining_quantity_kg', 0)
          .order('created_at', ascending: false);

      crates.assignAll(
        (data as List)
            .map((e) => DispatchCrateListModel.fromMap(e))
            .toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Toggle crate selection
  void toggleSelection(DispatchCrateListModel crate) {
    crate.isSelected = !crate.isSelected;

    if (crate.isSelected) {
      crate.dispatchQty = crate.remainingQty;
    } else {
      crate.dispatchQty = 0;
    }

    crates.refresh();
  }

  /// 🔹 Select All
  void selectAll() {
    for (var crate in crates) {
      crate.isSelected = true;
      crate.dispatchQty = crate.remainingQty;
    }
    crates.refresh();
  }

  /// 🔹 Unselect All
  void clearSelection() {
    for (var crate in crates) {
      crate.isSelected = false;
      crate.dispatchQty = 0;
    }
    crates.refresh();
  }

  /// 🔹 Selected crates list
  List<DispatchCrateListModel> get selectedCrates =>
      crates.where((c) => c.isSelected).toList();

  /// 🔹 Total selected quantity
  double get totalSelectedQty =>
      selectedCrates.fold(
        0,
            (sum, item) => sum + item.dispatchQty,
      );

  /// 🔹 Total selected count
  int get totalSelectedCount => selectedCrates.length;

  /// 🔹 Check if dispatch button should enable
  bool get canProceed => selectedCrates.isNotEmpty;
}