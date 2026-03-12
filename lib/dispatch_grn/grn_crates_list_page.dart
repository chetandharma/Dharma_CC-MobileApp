import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'grn_crates_controller.dart';


class GrnDispatchCratesListPage extends StatelessWidget {
  final String grnId;
  const GrnDispatchCratesListPage({super.key, required this.grnId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GrnDispatchCratesController(grnId));

    return Scaffold(
      appBar: AppBar(title: const Text("GRN Crates")),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.crates.length,
          itemBuilder: (_, index) {
            final crate = controller.crates[index];

            final isPacked = crate.status == 'packed';

            return Card(
              child: ListTile(
                title: Text("Crate ${crate.crateCode}"),
                subtitle: Text("Qty: ${crate.totalQty}"),

                trailing: ChoiceChip(
                  label: Text(isPacked ? "Packed" : "Pending"),
                  selected: controller.selectedCrates.contains(crate.id),
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: isPacked ? Colors.white : Colors.black,
                  ),
                  onSelected: isPacked
                      ? (_) => controller.toggleSelection(crate)
                      : null,
                ),
              ),
            );
          },
        );
      }),

      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Total Selected Qty: ${controller.totalSelectedQty}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: controller.selectedCrates.isEmpty
                    ? null
                    : () {
                  // Call dispatch logic
                },
                child: const Text("Dispatch"),
              ),
            ],
          ),
        );
      }),
    );
  }
}