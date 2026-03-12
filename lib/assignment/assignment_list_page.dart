import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'assignment_detail_page.dart';
import 'assignment_list_controller.dart';


class AssignmentListPage extends StatelessWidget {
  final String grnId;
  const AssignmentListPage({super.key, required this.grnId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AssignmentListController(grnId));

    return Scaffold(
      appBar: AppBar(title: const Text('Crate Assignments')),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.assignments.isEmpty) {
          return const Center(child: Text('No assignments found'));
        }

        return ListView.builder(
          itemCount: c.assignments.length,
          itemBuilder: (_, i) {
            final a = c.assignments[i];

            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text('Crate: ${a.crateCode}'),
                subtitle: Text(
                  'Packer: ${a.packerCode}\n'
                      'Bags: ${a.bagCount} × ${a.bagSizeKg} kg',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Get.to(
                        () => AssignmentDetailPage(assignment: a),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
