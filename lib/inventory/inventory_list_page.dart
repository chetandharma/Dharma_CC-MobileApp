import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inventory_controller.dart';

class InventoryListPage extends StatelessWidget {
  InventoryListPage({super.key});

  final InventoryController controller =
  Get.put(InventoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Procurement Stock')),
      body: Column(
        children: [
          // 🔍 Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product code search
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Product code',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: controller.onProductCodeChanged,
                  ),
                ),
                const SizedBox(width: 10),

                // Grade filter
                Obx(() {
                  return DropdownButton<String>(
                    value: controller.selectedGrade.value.isEmpty
                        ? null
                        : controller.selectedGrade.value,
                    hint: const Text('Grade'),
                    items: const [
                      DropdownMenuItem(value: 'A', child: Text('Grade A')),
                      DropdownMenuItem(value: 'B', child: Text('Grade B')),
                      DropdownMenuItem(value: 'C', child: Text('Grade C')),
                    ],
                    onChanged: (value) {
                      controller.onGradeChanged(value ?? '');
                    },
                  );
                }),
              ],
            ),
          ),

          // 📊 Total Quantity
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${controller.totalQuantityKg.toStringAsFixed(2)} kg',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(),

          // 📋 List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.procurements.isEmpty) {
                return const Center(child: Text('No stock found'));
              }

              return ListView.builder(
                itemCount: controller.procurements.length,
                itemBuilder: (context, index) {
                  final item = controller.procurements[index];

                  return ListTile(
                    title: Text(
                      item.productCode ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Grade ${item.qualityGrade} • ₹${item.pricePerKg}/kg',
                    ),
                    trailing: Text(
                      '${item.quantityKg} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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