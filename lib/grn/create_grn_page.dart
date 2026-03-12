import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../farmers/farmer_model.dart';
import '../models/collection_center_model.dart';
import '../models/product_model.dart';
import 'create_grn_controller.dart';

class CreateGrnPage extends StatelessWidget {
  // final controller = Get.put(CreateGrnController());
  final c = Get.put(CreateGrnController());
  // demo data (replace with DB later)
  // final farmers = ['FAR-0001', 'FAR-0002'];
  // final centers = ['CEN-001', 'CEN-002'];
  // final products = ['TOM-001', 'POT-001', 'ONI-001'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Create GRN')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              children: [
                // -------- GRN DETAILS --------
                /// FARMER
                Obx(
                  () => DropdownButtonFormField<FarmerModel>(
                    value: c.selectedFarmer.value,
                    decoration: const InputDecoration(labelText: 'Farmer'),
                    items: c.farmers.map((f) {
                      return DropdownMenuItem(
                        value: f,
                        child: Text(
                          '${f.name} (${f.farmerCode}) ⭐ ${f.rating}',
                        ),
                      );
                    }).toList(),
                    onChanged: (v) => c.selectedFarmer.value = v,
                  ),
                ),

                const SizedBox(height: 12),

                /// CENTER
                DropdownButtonFormField<CollectionCenterModel>(
                  value: c.selectedCenter.value,
                  decoration: const InputDecoration(
                    labelText: 'Collection Center',
                  ),
                  items: c.centers.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text('${c.name} (${c.code})'),
                    );
                  }).toList(),
                  onChanged: (v) => c.selectedCenter.value = v,
                ),

                const Divider(height: 32),

                // -------- PROCUREMENT FORM --------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Procurement Item',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<ProductModel>(
                  value: c.selectedProduct.value,
                  decoration: const InputDecoration(labelText: 'Product'),
                  items: c.products.map((p) {
                    return DropdownMenuItem<ProductModel>(
                      value: p,
                      child: Text('${p.name} (${p.code})'),
                    );
                  }).toList(),
                  onChanged: (p) {
                    c.selectedProduct.value = p;
                    c.productCode.value = p?.code ?? ''; // 🔥 THIS IS REQUIRED
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: c.qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (kg) *',
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Quality Grade'),
                  items: ['A', 'B', 'C']
                      .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                      .toList(),
                  onChanged: (v) {
                    c.qualityGrade.value = v ?? '';
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: c.priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price per kg'),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: c.addItem,
                    child: const Text('Add Item'),
                  ),
                ),

                const Divider(height: 32),

                // -------- ITEMS PREVIEW --------
                Obx(
                  () => Column(
                    children: [
                      ...c.items.asMap().entries.map((entry) {
                        final i = entry.key;
                        final item = entry.value;

                        return Card(
                          child: ListTile(
                            title: Text(item.productCode),
                            subtitle: Text(
                              '${item.quantity} kg | ${item.qualityGrade} | ₹${item.price}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => c.removeItem(i),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                      if (c.items.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Total Quantity: ${c.totalQuantity} kg',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                      //     const SizedBox(height: 5),
                      const Divider(height: 32),
                      Obx(
                        () => Text(
                          'Required: ${c.requiredCrates} | '
                          'Available: ${c.availableCrateCount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: c.assignedCrates
                        .map(
                          (crate) => Chip(
                            label: Text(crate.crateCode),
                            onDeleted: () {
                              if (c.assignedCrates.length <= c.requiredCrates)
                                return;
                              c.assignedCrates.remove(crate);
                              c.availableCrates.add(crate);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 25),
                // Obx(
                //   () => DropdownButtonFormField<CrateMaster>(
                //     value: controller.selectedCrate.value,
                //     decoration: const InputDecoration(
                //       labelText: 'Select Crate (50 kg)',
                //       border: OutlineInputBorder(),
                //     ),
                //     items:
                //         controller.availableCrates
                //             .map(
                //               (c) => DropdownMenuItem(
                //                 value: c,
                //                 child: Text(c.crateCode),
                //               ),
                //             )
                //             .toList(),
                //     onChanged: (v) => controller.selectedCrate.value = v,
                //   ),
                // ),
                // ElevatedButton.icon(
                //   icon: const Icon(Icons.add_box),
                //   label: const Text('Assign Crate'),
                //   onPressed: controller.assignCrate,
                // ),
                //
                // const SizedBox(height: 25),

                // -------- SUBMIT --------
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: c.canSubmit && !c.isSubmitting.value
                          ? c.submitGRN
                          : null,
                      child: c.isSubmitting.value
                          ? const CircularProgressIndicator()
                          : const Text('Submit GRN'),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
