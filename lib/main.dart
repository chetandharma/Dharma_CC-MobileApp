// import 'package:flutter/material.dart';
//
// import 'models/farmer_model.dart';
// import 'models/product_model.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'GRN Form',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: const GRNFormPage(),
//     );
//   }
// }
//
// class GRNFormPage extends StatefulWidget {
//   const GRNFormPage({super.key});
//
//   @override
//   State<GRNFormPage> createState() => _GRNFormPageState();
// }
//
// class _GRNFormPageState extends State<GRNFormPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final grnNo = "GRN-${DateTime.now().millisecondsSinceEpoch}";
//   final date = DateTime.now();
//   Product? selectedProduct;
//   String? selectedQuality;
//
//
//   final ccCtrl = TextEditingController();
//   final farmerNameCtrl = TextEditingController();
//   final farmerPhoneCtrl = TextEditingController();
//
//   List<GRNItem> items = [];
//
//   int crateCount = 0;
//   final List<Farmer> farmers = [
//     Farmer(id: 'F1', name: 'Ramesh Kumar', phone: '9876543210'),
//     Farmer(id: 'F2', name: 'Suresh Patel', phone: '9876501234'),
//     Farmer(id: 'F3', name: 'Mahesh Yadav', phone: '9876512345'),
//   ];
//
//   final List<CollectionCenter> centers = [
//     CollectionCenter(id: 'CC1', name: 'Mohali CC'),
//     CollectionCenter(id: 'CC2', name: 'Ludhiana CC'),
//     CollectionCenter(id: 'CC3', name: 'Patiala CC'),
//   ];
//   final List<Product> products = [
//     Product(id: 'P1', name: 'Tomato'),
//     Product(id: 'P2', name: 'Potato'),
//     Product(id: 'P3', name: 'Onion'),
//   ];
//
//   Farmer? selectedFarmer;
//   CollectionCenter? selectedCenter;
//
//   void addItem() {
//     setState(() {
//       items.add(GRNItem());
//     });
//   }
//
//   double get totalQty =>
//       items.fold(0, (sum, e) => sum + (e.qty ?? 0));
//
//   double get totalAmt =>
//       items.fold(0, (sum, e) => sum + e.total);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Goods Receipt Note (GRN)")),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               /// HEADER
//               sectionTitle("GRN Details"),
//               readOnlyField("GRN Number", grnNo),
//               readOnlyField("Date", "${date.day}-${date.month}-${date.year}"),
//
//               // inputField("Collection Center", ccCtrl),
//               // inputField("Farmer Name", farmerNameCtrl),
//               // inputField("Farmer Phone", farmerPhoneCtrl,
//               //     keyboard: TextInputType.phone),
//               DropdownButtonFormField<CollectionCenter>(
//                 decoration: const InputDecoration(
//                   labelText: "Collection Center",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: centers.map((c) {
//                   return DropdownMenuItem(
//                     value: c,
//                     child: Text(c.name),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() => selectedCenter = value);
//                 },
//                 validator: (v) => v == null ? "Select Collection Center" : null,
//               ),
//
//               const SizedBox(height: 20),
//               DropdownButtonFormField<Farmer>(
//                 decoration: const InputDecoration(
//                   labelText: "Farmer",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: farmers.map((f) {
//                   return DropdownMenuItem(
//                     value: f,
//                     child: Text(f.name),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() => selectedFarmer = value);
//                 },
//                 validator: (v) => v == null ? "Select Farmer" : null,
//               ),
//
//               /// ITEMS
//               sectionTitle("Procurement Items"),
//               ...items.asMap().entries.map((e) {
//                 return GRNItemWidget(
//                   index: e.key + 1,
//                   item: e.value,
//                   onRemove: () {
//                     setState(() => items.remove(e.value));
//                   },
//                 );
//               }),
//
//               TextButton.icon(
//                 onPressed: addItem,
//                 icon: const Icon(Icons.add),
//                 label: const Text("Add Item"),
//               ),
//
//               const SizedBox(height: 20),
//
//               /// CRATES
//               sectionTitle("Crate Details"),
//               inputField(
//                 "Number of Crates",
//                 TextEditingController(text: crateCount == 0 ? "" : "$crateCount"),
//                 keyboard: TextInputType.number,
//                 onChanged: (v) {
//                   crateCount = int.tryParse(v) ?? 0;
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               /// SUMMARY
//               sectionTitle("Summary"),
//               summaryRow("Total Quantity (KG)", totalQty.toStringAsFixed(2)),
//               summaryRow("Total Amount (₹)", totalAmt.toStringAsFixed(2)),
//
//               const SizedBox(height: 30),
//
//               /// SUBMIT
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate() &&
//                         selectedFarmer != null &&
//                         selectedCenter != null &&
//                         items.isNotEmpty) {
//
//                       debugPrint("GRN SUBMITTED");
//                       debugPrint("Farmer: ${farmerNameCtrl.text}");
//                       debugPrint("Items: ${items.length}");
//                       debugPrint("Total Amount: $totalAmt");
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("GRN Submitted (Demo)")),
//                       );
//                     }
//                   },
//                   child: const Text("Submit GRN"),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 16),
//       child: Text(title,
//           style: const TextStyle(
//               fontSize: 16, fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Widget readOnlyField(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         initialValue: value,
//         readOnly: true,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget inputField(String label, TextEditingController ctrl,
//       {TextInputType keyboard = TextInputType.text,
//         Function(String)? onChanged}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: ctrl,
//         keyboardType: keyboard,
//         onChanged: onChanged,
//         validator: (v) => v == null || v.isEmpty ? "Required" : null,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget summaryRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(label), Text(value)],
//       ),
//     );
//   }
// }
//
// /// ITEM MODEL
// class GRNItem {
//   String? product;
//   double? qty;
//   double? price;
//   String? quality;
//
//   double get total => (qty ?? 0) * (price ?? 0);
// }
//
// /// ITEM UI
// class GRNItemWidget extends StatefulWidget {
//   final int index;
//   final GRNItem item;
//   final VoidCallback onRemove;
//
//   const GRNItemWidget(
//       {super.key,
//         required this.index,
//         required this.item,
//         required this.onRemove});
//
//   @override
//   State<GRNItemWidget> createState() => _GRNItemWidgetState();
// }
//
// class _GRNItemWidgetState extends State<GRNItemWidget> {
//   final productCtrl = TextEditingController();
//   final qtyCtrl = TextEditingController();
//   final priceCtrl = TextEditingController();
//   final qualityCtrl = TextEditingController();
//   Product? selectedProduct;
//   String? selectedQuality;
//
//   @override
//   Widget build(BuildContext context) {
//     widget.item.product = productCtrl.text;
//     widget.item.qty = double.tryParse(qtyCtrl.text);
//     widget.item.price = double.tryParse(priceCtrl.text);
//     widget.item.quality = qualityCtrl.text;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Item ${widget.index}",
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 IconButton(
//                   onPressed: widget.onRemove,
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                 )
//               ],
//             ),
//             DropdownButtonFormField<Product>(
//               decoration: const InputDecoration(
//                 labelText: "Product",
//                 border: OutlineInputBorder(),
//               ),
//               items: (context.findAncestorStateOfType<_GRNFormPageState>()!.products)
//                   .map((p) {
//                 return DropdownMenuItem(
//                   value: p,
//                   child: Text(p.name),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedProduct = value;
//                   widget.item.product = value;
//                 });
//               },
//               validator: (v) => v == null ? "Select product" : null,
//             ),
//
//             rowFields(
//               textField("Qty (KG)", qtyCtrl,
//                   keyboard: TextInputType.number),
//               textField("Price/KG", priceCtrl,
//                   keyboard: TextInputType.number),
//             ),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: "Quality Grade",
//                 border: OutlineInputBorder(),
//               ),
//               items: ['A', 'B', 'C'].map((q) {
//                 return DropdownMenuItem(
//                   value: q,
//                   child: Text(q),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedQuality = value;
//                   widget.item.quality = value;
//                 });
//               },
//               validator: (v) => v == null ? "Select quality" : null,
//             ),
//
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Line Total: ₹${widget.item.total.toStringAsFixed(2)}",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget textField(String label, TextEditingController ctrl,
//       {TextInputType keyboard = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: TextField(
//         controller: ctrl,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   Widget rowFields(Widget a, Widget b) {
//     return Row(
//       children: [
//         Expanded(child: a),
//         const SizedBox(width: 8),
//         Expanded(child: b),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_controller.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lzgonuebewcakzsluwfe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx6Z29udWViZXdjYWt6c2x1d2ZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcwNzY4NjUsImV4cCI6MjA4MjY1Mjg2NX0.FHormkta5zOYK0-rmW1YDXizNzzIwRJQJ8nXuYa8oAM',
  );

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hasSession = Supabase.instance.client.auth.currentSession != null;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dharma CC Ops',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: hasSession ? Routes.dashboard : Routes.login,
      getPages: AppRoutes.pages,
    );
  }
}
