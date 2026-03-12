import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dispatchlist_model.dart';




class DispatchFlowPage extends StatelessWidget {

  DispatchFlowPage({super.key});

  final DispatchCrateList crate = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispatch Crate')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crate: ${crate.crateCode ?? crate.qrCode}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Available Quantity: ${crate.remainingQty} kg'),
            const SizedBox(height: 20),

            // 👉 Here you can add:
            // - Quantity input field
            // - Farmer selection
            // - Confirm dispatch button
          ],
        ),
      ),
    );
  }
}