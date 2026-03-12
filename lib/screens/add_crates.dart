// import 'package:flutter/material.dart';
// import '../models/crate_model.dart';
// import '../models/grn_model.dart';
// import 'grn_crates.dart';
//
// class AddCratesScreen extends StatefulWidget {
//   final GRN grn;
//   const AddCratesScreen({super.key, required this.grn});
//
//   @override
//   State<AddCratesScreen> createState() => _AddCratesScreenState();
// }
//
// class _AddCratesScreenState extends State<AddCratesScreen> {
//   final crateCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Crates")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: crateCtrl,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Number of Crates",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text("Generate QR"),
//               onPressed: () {
//                 int count = int.parse(crateCtrl.text);
//                 widget.grn.crates = List.generate(
//                   count,
//                       (i) => Crate(
//                     i + 1,
//                     "GRN-${widget.grn.id}-${i + 1}",
//                   ),
//                 );
//
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (_) => GRNCratesScreen(grn: widget.grn),
//                 //   ),
//                 // );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
