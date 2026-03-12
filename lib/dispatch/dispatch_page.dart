import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../clients/client_controller.dart';
import 'dispatch_controller.dart';
import 'dispatch_model.dart';

class DispatchPage extends StatelessWidget {
  final String grnNo;
  final List<DispatchCrateListModel> selectedCrates;

  const DispatchPage({
    required this.grnNo,
    required this.selectedCrates,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final c = Get.put(
    //   DispatchController(grnNo: grnNo, initialCrates: selectedCrates),
    // );
    // final controller = Get.put(ClientController());
    final DispatchController c = Get.put(
      DispatchController(grnNo: grnNo, initialCrates: selectedCrates),
      tag: grnNo,
    );

    final ClientController clientController = Get.find<ClientController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Dispatch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => ListView(
            children: [
              /// GRN Info
              Text(
                'GRN: $grnNo',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Total Crates: ${c.crates.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              Text(
                'Total Quantity: ${c.totalDispatchQty.toStringAsFixed(2)} kg',
              ),

              const SizedBox(height: 16),

              /// Destination Dropdown
              Column(
                children: [
                  /// CLIENT DROPDOWN
                  Obx(() {
                    final ids = clientController.clients
                        .map((e) => e.id)
                        .toList();
                    final value = ids.contains(c.selectedClientId.value)
                        ? c.selectedClientId.value
                        : null;

                    return DropdownButtonFormField<String>(
                      value: value,
                      decoration: const InputDecoration(
                        labelText: "Select Client",
                        border: OutlineInputBorder(),
                      ),
                      items: clientController.clients.map((client) {
                        return DropdownMenuItem<String>(
                          value: client.id,
                          child: Text(client.clientName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          c.selectedClientId.value = val;
                          c.selectedBranchId.value = '';
                          clientController.fetchBranches(val);
                        }
                      },
                    );
                  }),

                  SizedBox(height: 20),

                  /// BRANCH DROPDOWN
                  Obx(() {
                    final ids = clientController.branches
                        .map((e) => e.id)
                        .toList();
                    final value = ids.contains(c.selectedBranchId.value)
                        ? c.selectedBranchId.value
                        : null;

                    return DropdownButtonFormField<String>(
                      value: value,
                      decoration: const InputDecoration(
                        labelText: "Select Branch",
                        border: OutlineInputBorder(),
                      ),
                      items: clientController.branches.map((branch) {
                        return DropdownMenuItem<String>(
                          value: branch.id,
                          child: Text(
                            "${branch.branchName} (${branch.branchCode})",
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          c.selectedBranchId.value = val;
                        }
                      },
                    );
                  }),
                ],
              ),

              const SizedBox(height: 12),

              /// Vehicle Dropdown
              Obx(() => DropdownButtonFormField<String>(
                value: c.vehicleNo.value.isEmpty ? null : c.vehicleNo.value,
                decoration: const InputDecoration(
                  labelText: 'Vehicle No',
                  border: OutlineInputBorder(),
                ),
                items: c.vehicles
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    c.vehicleNo.value = value;
                  }
                },
              )),

              const SizedBox(height: 20),

              const Text(
                'Selected Crates',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              /// Selected Crate List
              ...c.crates.map(
                (crate) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crate.crateCode ?? crate.qrCode ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Remaining: ${crate.remainingQty} kg'),
                              Text('Selected: ${crate.dispatchQty} kg'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Dispatch Done Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: c.canSubmit && !c.isSaving.value
                      ? c.submitDispatch
                      : null,
                  child: c.isSaving.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Dispatch Done'),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
