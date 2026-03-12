import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assignment/assignment_list_page.dart';
import '../routes/app_routes.dart';
import 'edit_grn_page.dart';
import 'grn_detail_controller.dart';

class GrnDetailPage extends StatelessWidget {
  final String grnNo;
  final String grnId;
  const GrnDetailPage({required this.grnNo, required this.grnId});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(GrnDetailController(grnNo));

    return Scaffold(
      appBar: AppBar(
        title: Text('GRN Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditGrnPage(grnNo: grnNo));
            },
          )   ,
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Delete GRN'),
                  content: const Text(
                    'This will delete GRN and all related crates. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Get.back();
                        controller.deleteGrn(grnId);

                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

            },
          )
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// GRN HEADER
              Row(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            grnNo,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Farmer: ${controller.farmerCode.value}'),
                          Text('Center: ${controller.centerCode.value}'),
                          Text('Date: ${controller.grnDate.value}'),
                          Text(
                              'Payment: ${controller.paymentStatus.value}'),
                          const SizedBox(height: 8),
                          Text(
                            'Total Quantity: ${controller.totalQuantity.value} kg',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      controller.paymentStatus.value != "PAID"?ElevatedButton.icon(
                        icon: const Icon(Icons.currency_rupee),
                        label: const Text('Paid'),
                        onPressed: () {
                          controller.updatePaymentStatus(
                            grnId: grnId,
                          );


                        },
                      ):SizedBox(),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.assignment_ind_outlined),
                        label: const Text('Assign'),
                        onPressed: () {
                          Get.toNamed(
                            Routes.assignmentDetail,
                            arguments: {
                              'grnId': grnId,
                              'grnNo': grnNo,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// PROCUREMENT ITEMS
              const Text(
                'Procurement Items',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ...controller.items.map((item) {
                return Card(
                  child: ListTile(
                    title: Text(item['product_code']),
                    subtitle: Text(
                        '${item['quantity_kg']} kg | Grade ${item['quality_grade']}'),
                    trailing: Text(
                      '₹${item['price_per_kg']}',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),

              if (controller.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(child: Text('No procurement items')),
                ),

              // ElevatedButton.icon(
              //   icon: const Icon(Icons.inventory),
              //   label: const Text('Packing'),
              //   onPressed: () {
              //     Get.to(
              //           () => AssignmentListPage(grnId: grnId),
              //     );
              //   },
              // ),

              const SizedBox(height: 50),



            ],
          ),
        );
      }),
    );
  }
}
