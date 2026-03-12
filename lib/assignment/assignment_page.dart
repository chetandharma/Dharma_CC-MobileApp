import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'assignment_controller.dart';

class AssignmentPage extends StatelessWidget {
  final String grnId;
  final String grnNo;

  const AssignmentPage({
    required this.grnId,
    required this.grnNo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    debugPrint('📦 AssignmentPage args: $args');
    final c = Get.put(
      AssignmentController(grnId: grnId, grnNo: grnNo),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Crates')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => ListView(
          children: [
            Text(
              'GRN: $grnNo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// 🔹 CRATE CHIPS
            const Text('Select Crates'),
            Wrap(
              spacing: 8,
              children: c.crates.map((crate) {
                final selected =
                c.selectedCrates.contains(crate);

                return FilterChip(
                  label: Text(crate['crate_code']),
                  selected: selected,
                  onSelected: (v) {
                    if (v) {
                      c.selectedCrates.add(crate);
                    } else {
                      c.selectedCrates.remove(crate);
                    }
                    c.calculateBags();
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// 🔹 PACKERS
            const Text('Select Packers'),
            Wrap(
              spacing: 8,
              children: c.packers.map((p) {
                final selected = c.selectedPackers.contains(p);
                return FilterChip(
                  label: Text(p),
                  selected: selected,
                  onSelected: (v) {
                    if (v) {
                      c.selectedPackers.add(p);
                    } else {
                      c.selectedPackers.remove(p);
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// 🔹 BAG SIZE
            DropdownButtonFormField<int>(
              decoration:
              const InputDecoration(labelText: 'Bag Size (kg)'),
              items: [1, 5, 10, 20]
                  .map((s) => DropdownMenuItem(
                value: s,
                child: Text('$s kg'),
              ))
                  .toList(),
              onChanged: (v) {
                c.bagSize.value = v;
                c.calculateBags();
              },
            ),

            const SizedBox(height: 12),

            /// 🔹 AUTO BAG COUNT
            Text(
              'Auto Bags: ${c.bagCount.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            /// 🔹 SAVE
            ElevatedButton(
              onPressed:
              c.canSave && !c.isSaving.value
                  ? c.saveAssignment
                  : null,
              child: c.isSaving.value
                  ? const CircularProgressIndicator()
                  : const Text('Save Assignment'),
            ),
          ],
        )),
      ),
    );
  }
}
