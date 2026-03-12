import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dispatch_binding.dart';
import 'dispatch_page.dart';
import 'dispatchlist_controller.dart';

class DispatchCrateListPage extends StatelessWidget {
  DispatchCrateListPage({super.key});

  final DispatchListController controller =
  Get.put(DispatchListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Crates for Dispatch')),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.crates.isEmpty) {
          return const Center(
              child: Text('No packed crates available'));
        }

        return Column(
          children: [

            /// Crate List
            Expanded(
              child: ListView.builder(
                itemCount: controller.crates.length,
                itemBuilder: (context, index) {
                  final crate = controller.crates[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: crate.isSelected,
                        onChanged: (_) =>
                            controller.toggleSelection(crate),
                      ),
                      title: Text(
                        crate.crateCode ?? crate.qrCode ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Remaining: ${crate.remainingQty.toStringAsFixed(2)} kg',
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Bottom Summary Section
            if (controller.selectedCrates.isNotEmpty)
              SafeArea(
                top: false,
                child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Selected Crates: ${controller.totalSelectedCount}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Total Quantity: ${controller.totalSelectedQty.toStringAsFixed(2)} kg',
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selected =
                              controller.selectedCrates;

                          Get.to(
                                () => DispatchPage(
                              grnNo: selected.first.grnId!,
                              selectedCrates: selected,
                            ),
                            binding: DispatchBinding(),
                          );
                        },
                        child:
                        const Text('Proceed to Dispatch'),
                      ),
                    )
                  ],
                ),
              ),
              ),
          ],
        );
      }),
    );
  }
}