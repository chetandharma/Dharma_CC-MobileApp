// import 'package:flutter/material.dart';
// import '../models/farmer_model.dart';
// import 'create_grn.dart';
//
// class FarmerListScreen extends StatelessWidget {
//   const FarmerListScreen({super.key});
//
//   static final farmers = [
//     Farmer("1", "Ramesh", "9876543210", 4.5),
//     Farmer("2", "Suresh", "9876543222", 4.2),
//     Farmer("3", "Mahesh", "9876543333", 4.8),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Select Farmer")),
//       body: ListView.builder(
//         itemCount: farmers.length,
//         itemBuilder: (_, i) {
//           final f = farmers[i];
//           return ListTile(
//             title: Text(f.name),
//             subtitle: Text("${f.phone} • ⭐ ${f.rating}"),
//             trailing: const Icon(Icons.arrow_forward),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CreateGRNScreen(farmer: f),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
