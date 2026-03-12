import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_grn_controller.dart';

class EditGrnPage extends StatelessWidget {
  final String grnNo;
  const EditGrnPage({required this.grnNo});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditGrnController(grnNo));

    return Scaffold(
      appBar: AppBar(title: Text('Edit GRN')),
      body: Obx(() {
        if (c.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('GRN No: $grnNo',
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: c.farmerCode.value,
                decoration: InputDecoration(labelText: 'Farmer Code'),
                onChanged: (v) => c.farmerCode.value = v,
              ),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: c.centerCode.value,
                decoration: InputDecoration(labelText: 'Center Code'),
                onChanged: (v) => c.centerCode.value = v,
              ),

              const Divider(height: 32),

              Text('Procurement Item',
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: c.productCode.value,
                decoration: InputDecoration(labelText: 'Product Code'),
                onChanged: (v) => c.productCode.value = v,
              ),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: c.quantityKg.value.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity (kg)'),
                onChanged: (v) =>
                c.quantityKg.value = double.tryParse(v) ?? 0,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: c.qualityGrade.value,
                items: ['A', 'B', 'C']
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => c.qualityGrade.value = v!,
                decoration:
                InputDecoration(labelText: 'Quality Grade'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                initialValue: c.pricePerKg.value.toString(),
                keyboardType: TextInputType.number,
                decoration:
                InputDecoration(labelText: 'Price / Kg'),
                onChanged: (v) =>
                c.pricePerKg.value = double.tryParse(v) ?? 0,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: c.updateGRN,
                child: Text('Update GRN'),
              )
            ],
          ),
        );
      }),
    );
  }
}
