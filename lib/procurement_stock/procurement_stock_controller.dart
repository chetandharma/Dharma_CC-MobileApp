import 'package:dharma_cc_app/procurement_stock/procurement_stock_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProcurementStockController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var stocks = <ProcurementStock>[].obs;
  var isLoading = false.obs;

  // filters
  var selectedGrade = ''.obs;
  var productCode = ''.obs;

  double get totalQuantityKg =>
      stocks.fold(0, (sum, e) => sum + e.totalQuantityKg);

  @override
  void onInit() {
    fetchStock();
    super.onInit();
  }

  Future<void> fetchStock({
    String? grade,
    String? code,
  }) async {
    try {
      isLoading(true);

      var query = supabase
          .from('procurement_stock_summary')
          .select(
        'product_code, quality_grade, total_quantity_kg, avg_price_per_kg',
      );

      if (grade != null && grade.isNotEmpty) {
        query = query.eq('quality_grade', grade);
      }

      if (code != null && code.isNotEmpty) {
        query = query.ilike('product_code', '%$code%');
      }

      final data = await query
          .order('product_code')
          .order('quality_grade');

      stocks.assignAll(
        (data as List).map((e) => ProcurementStock.fromMap(e)),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void onGradeChanged(String value) {
    selectedGrade.value = value;
    fetchStock(
      grade: value,
      code: productCode.value,
    );
  }

  void onProductCodeChanged(String value) {
    productCode.value = value;
    fetchStock(
      grade: selectedGrade.value,
      code: value,
    );
  }
}