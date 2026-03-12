// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class GRNPreviewPage extends StatelessWidget {
//   const GRNPreviewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final c = Get.find<GRNController>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("GRN Preview")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             previewCard("GRN Info", [
//               row("GRN No", c.grnNo),
//               row("Center", c.selectedCenter!.name),
//               row("Farmer", c.selectedFarmer!.name),
//               row("Phone", c.selectedFarmer!.phone),
//             ]),
//
//             previewCard(
//               "Items",
//               c.items.map((i) {
//                 return row(
//                   "${i.product!.name} (${i.quality})",
//                   "${i.qty} KG × ₹${i.price} = ₹${i.total}",
//                 );
//               }).toList(),
//             ),
//
//             previewCard(
//               "Crates",
//               c.crateNumbers.map((e) => Text(e)).toList(),
//             ),
//
//             previewCard("Summary", [
//               row("Total Qty", c.totalQty.toStringAsFixed(2)),
//               row("Total Amount", "₹ ${c.totalAmt.toStringAsFixed(2)}"),
//             ]),
//
//             const SizedBox(height: 20),
//
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Get.back(),
//                     child: const Text("Edit"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       c.submitGRN();
//                       Get.offAllNamed('/grn-list');
//                     },
//                     child: const Text("Confirm & Submit"),
//                   ),
//
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget previewCard(String title, List<Widget> children) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             const Divider(),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget row(String l, String r) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(l), Text(r)],
//       ),
//     );
//   }
// }
