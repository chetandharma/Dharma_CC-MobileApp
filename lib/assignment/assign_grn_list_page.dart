import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../grn/grn_controller.dart';
import '../grn/grn_detail_page.dart';
import '../routes/app_routes.dart';
import 'assignment_list_page.dart';



class GrnAssignListPage extends StatelessWidget {
  final controller = Get.put(GrnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned GRN\'s'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchGrns,
          )  ,
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => Get.toNamed('/grn-create'),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.grnList.isEmpty) {
          return const Center(child: Text('No GRNs found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.grnList.length,
          itemBuilder: (context, index) {
            final grn = controller.grnList[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () {
                  try {
                    debugPrint('➡️ Assignment clicked');
                    debugPrint('grnId: ${grn.grnId}');
                    debugPrint('grnNo: ${grn.grnNo}');

                    if (grn.grnId.isEmpty || grn.grnNo.isEmpty) {
                      throw Exception('GRN ID or GRN NO is empty');
                    }

                    Get.toNamed(
                      Routes.allAssignmentList,
                      arguments: {
                        'grnId': grn.grnId,
                      },
                    );
                  } catch (e) {
                    debugPrint('❌ Assignment navigation error: $e');
                    Get.snackbar('Error', e.toString());
                  }
                },

                // onTap: () {
                //   Get.to(
                //           () => AssignmentListPage(grnId: grn.grnId));
                //  // Get.to(() => GrnDetailPage(grnNo: grn.grnNo, grnId: grn.grnId));
                // },
                title: Text(
                  grn.grnNo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Farmer: ${grn.farmerCode}'),
                    Text('Center: ${grn.centerCode}'),
                    Text('Date: ${grn.grnDate}'),
                    Text('Qty: ${grn.totalQuantity} kg'),
                  ],
                ),
                trailing: Chip(
                  label: Text(grn.paymentStatus),
                  backgroundColor: grn.paymentStatus == 'PAID'
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
