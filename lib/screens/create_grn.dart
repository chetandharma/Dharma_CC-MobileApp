// import 'package:flutter/material.dart';
// import '../models/farmer_model.dart';
// import '../models/grn_model.dart';
// import 'add_crates.dart';
//
// class CreateGRNScreen extends StatefulWidget {
//   final Farmer farmer;
//   const CreateGRNScreen({super.key, required this.farmer});
//
//   @override
//   State<CreateGRNScreen> createState() => _CreateGRNScreenState();
// }
//
// class _CreateGRNScreenState extends State<CreateGRNScreen> {
//   final qtyCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create GRN")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text("Farmer: ${widget.farmer.name}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 12),
//             TextField(
//               controller: qtyCtrl,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Total Quantity (KG)",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text("Next: Add Crates"),
//               onPressed: () {
//                 final grn = GRN(
//                   id: DateTime.now().millisecondsSinceEpoch.toString(),
//                   farmerName: widget.farmer.name,
//                   quantity: double.parse(qtyCtrl.text),
//                   date: DateTime.now(),
//                 );
//
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AddCratesScreen(grn: grn),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
