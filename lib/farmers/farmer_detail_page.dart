import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_farmer_page.dart';
import 'farmer_model.dart';


class FarmerDetailPage extends StatelessWidget {
  FarmerDetailPage({super.key});

  final FarmerModel farmer = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Get.to(
                    () => EditFarmerPage(farmer: farmer),
              );

              if (result == true) {
                Get.back(result: true); // refresh list
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Name', farmer.name),
            _row('Phone', farmer.phone ?? '-'),
            _row('Rating', farmer.rating.toString()),
            _row('Farmer Code', farmer.farmerCode),
            _row('Bank Account', farmer.bankAccount ?? '-'),
            _row('IFSC', farmer.ifsc ?? '-'),
            _row('Active', farmer.isActive ? 'Yes' : 'No'),
            _row(
              'Created At',
              farmer.createdAt.toLocal().toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}