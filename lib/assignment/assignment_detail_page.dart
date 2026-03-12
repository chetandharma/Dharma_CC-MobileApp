import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'assignment_model.dart';


class AssignmentDetailPage extends StatelessWidget {
  final CrateAssignmentModel assignment;
  const AssignmentDetailPage({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
   // final totalKg = assignment.bagSize * assignment.bagCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Assignment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _row('Crate Code', assignment.crateCode!),
                _row('Packer', assignment.packerCode!),
              //  _row('Bag Size', '${assignment.bagSize} kg'),
                _row('Bag Count', assignment.bagCount.toString()),
              //  _row('Total Packed', '$totalKg kg'),


                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.assignment_ind_outlined),
                  label: const Text('Packing'),
                  onPressed: () {
                    Get.toNamed(
                      Routes.grnPacking,
                      arguments: {
                        'grnId': assignment.grnId,
                        'grnNo': assignment.grnId,
                        'crateNo': assignment.crateCode, // or crate_number
                        'crateId': assignment.crateCode,
                        'assignmentId': assignment.id,
                      },
                    );
                  },

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
