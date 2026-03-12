import 'package:dharma_cc_app/procurement_stock/procurement_stock_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProcurementStockPage extends StatelessWidget {
  ProcurementStockPage({super.key});

  final ProcurementStockController controller =
  Get.put(ProcurementStockController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grouped Stock')),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Product code',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.onProductCodeChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Obx(() {
                  return DropdownButton<String>(
                    value: controller.selectedGrade.value.isEmpty
                        ? null
                        : controller.selectedGrade.value,
                    hint: const Text('Grade'),
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('A')),
                      DropdownMenuItem(value: 'B', child: Text('B')),
                      DropdownMenuItem(value: 'C', child: Text('C')),
                    ],
                    onChanged: (v) => controller.onGradeChanged(v ?? ''),
                  );
                }),
              ],
            ),
          ),

          // Total qty
          Obx(() => Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Total Stock: ${controller.totalQuantityKg.toStringAsFixed(2)} kg',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.green),
            ),
          )),

          const Divider(),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.stocks.isEmpty) {
                return const Center(child: Text('No stock found'));
              }

              return ListView.builder(
                itemCount: controller.stocks.length,
                itemBuilder: (context, index) {
                  final s = controller.stocks[index];

                  return ListTile(
                    title: Text(
                      s.productCode ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    Text('Grade ${s.qualityGrade} • ₹${s.avgPricePerKg.toStringAsFixed(2)}/kg'),
                    trailing: Text(
                      '${s.totalQuantityKg.toStringAsFixed(2)} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}