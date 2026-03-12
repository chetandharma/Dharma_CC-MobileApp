import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dispatch/dispatch_page.dart';
import '../dispatch_grn/grn_crates_list_page.dart';
import 'packing_controller.dart';

class PackingPage extends StatelessWidget {
  final String grnId;
  final String grnNo;
  final String crateNo;
  final String crateId;
  final String assignmentId;

  const PackingPage({
    super.key,
    required this.grnId,
    required this.grnNo,
    required this.crateNo,
    required this.crateId,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      PackingController(
        assignmentId: assignmentId,
        crateId: crateId,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Packing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crate: $crateNo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// ▶️ START
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Packing'),
                onPressed: c.assignmentStatus.value == 'PENDING'
                    ? c.startPacking
                    : null,
              ),

              const SizedBox(height: 24),

              /// 📝 NOTE
              TextField(
                controller: c.noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// ✅ FINISH
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Finish Packing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: c.assignmentStatus.value == 'IN_PROGRESS'
                    ? c.finishPacking
                    : null,
              ),

              // ElevatedButton.icon(
              //   icon: const Icon(Icons.check_circle),
              //   label: const Text('Dispatch'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.lightBlue,
              //   ),
              //   onPressed: () {
              //     Get.to(
              //           () => GrnDispatchCratesListPage(grnId: grnNo),
              //       arguments: grnNo,
              //     );
              //   }
              // ),
            ],
          );
        }),
      ),
    );
  }
}
