// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'grn_controller.dart';
// import 'models.dart';
//
// class GRNViewPage extends StatelessWidget {
//   const GRNViewPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final GRN grn = Get.arguments;
//
//     return Scaffold(
//       appBar: AppBar(title: Text(grn.grnNo)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             section("GRN Info", [
//               row("Center", grn.center.name),
//               row("Farmer", grn.farmer.name),
//               row("Phone", grn.farmer.phone),
//               row("Date",
//                   "${grn.date.day}-${grn.date.month}-${grn.date.year}"),
//             ]),
//
//             section(
//               "Items",
//               grn.items.map((i) {
//                 return row(
//                   "${i.product!.name} (${i.quality})",
//                   "${i.qty} KG × ₹${i.price} = ₹${i.total}",
//                 );
//               }).toList(),
//             ),
//
//             section(
//               "Crates",
//               grn.crates.map((e) => Text(e)).toList(),
//             ),
//
//             section("Summary", [
//               row("Total Qty", grn.totalQty.toStringAsFixed(2)),
//               row("Total Amount", "₹ ${grn.totalAmount.toStringAsFixed(2)}"),
//             ]),
//
//             ElevatedButton(
//               onPressed: () {
//                 final c = Get.find<GRNController>();
//                 // c.grnList
//                 //     .firstWhere((e) => e.grnNo == grn.grnNo)
//                 //     .status = GRNStatus.packingStarted;
//
//                 Get.toNamed('/packing', arguments: grn.crates);
//               },
//               child: const Text("Start Packing"),
//             ),
//             const SizedBox(height: 20),
//             if (grn.status == GRNStatus.packed)
//               ElevatedButton(
//                 onPressed: () {
//                   grn.status = GRNStatus.dispatched;
//                   Get.toNamed('/dispatch', arguments: grn.crates);
//                 },
//                 child: const Text("Start Dispatch"),
//               ),
//
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget section(String title, List<Widget> children) {
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
