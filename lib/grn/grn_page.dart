// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../widgets/common_widgets.dart';
// // import 'grn_controller.dart';
// // import 'models.dart';
// //
// // class GRNPage extends StatelessWidget {
// //   const GRNPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final c = Get.put(GRNController());
// //     final formKey = GlobalKey<FormState>();
// //
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Create GRN")),
// //       body: Form(
// //         key: formKey,
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //
// //               /// HEADER
// //               card(
// //                 "GRN Details",
// //                 Column(
// //                   children: [
// //                     readOnlyField("GRN Number", c.grnNo),
// //                     readOnlyField(
// //                       "Date",
// //                       "${c.date.day}-${c.date.month}-${c.date.year}",
// //                     ),
// //                     dropdown<CollectionCenter>(
// //                       label: "Collection Center",
// //                       items: c.centers,
// //                       value: c.selectedCenter,
// //                       text: (v) => v.name,
// //                       onChanged: (v) => c.selectedCenter = v,
// //                     ),
// //                     dropdown<Farmer>(
// //                       label: "Farmer",
// //                       items: c.farmers,
// //                       value: c.selectedFarmer,
// //                       text: (v) => v.name,
// //                       onChanged: (v) => c.selectedFarmer = v,
// //                     ),
// //                     if (c.selectedFarmer != null)
// //                       readOnlyField("Phone", c.selectedFarmer!.phone),
// //                   ],
// //                 ),
// //               ),
// //
// //               card(
// //                 "Crate Tracking (Mandatory)",
// //                 Column(
// //                   children: [
// //                     TextFormField(
// //                       controller: c.crateInputCtrl,
// //                       keyboardType: TextInputType.number,
// //                       decoration: const InputDecoration(
// //                         labelText: "Number of Crates",
// //                       ),
// //                       validator: (v) {
// //                         final n = int.tryParse(v ?? '');
// //                         if (n == null || n <= 0) {
// //                           return "Enter valid crate count";
// //                         }
// //                         return null;
// //                       },
// //                       onChanged: (_) => c.addCrates(),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Obx(() => Wrap(
// //                       spacing: 8,
// //                       children: c.crateNumbers
// //                           .map((e) => Chip(label: Text(e)))
// //                           .toList(),
// //                     )),
// //                   ],
// //                 ),
// //               ),
// //
// //               /// ITEMS
// //               card(
// //                 "Items",
// //                 Obx(() => Column(
// //                   children: [
// //                     ...c.items.map((item) => itemCard(item, c)),
// //                     TextButton.icon(
// //                       onPressed: c.addItem,
// //                       icon: const Icon(Icons.add),
// //                       label: const Text("Add Item"),
// //                     ),
// //                   ],
// //                 )),
// //               ),
// //
// //               /// SUMMARY
// //               card(
// //                 "Summary",
// //                 Obx(() => Column(
// //                   children: [
// //                     row("Total Qty", c.totalQty.toStringAsFixed(2)),
// //                     row("Total Amount", "₹ ${c.totalAmt.toStringAsFixed(2)}"),
// //                   ],
// //                 )),
// //               ),
// //
// //               ElevatedButton(
// //                 onPressed: () {
// //                   if (!formKey.currentState!.validate() ||
// //                       c.items.isEmpty) {
// //                     Get.snackbar("Error", "Please complete GRN properly");
// //                     return;
// //                   }
// //                   Get.snackbar("Success", "GRN Created");
// //                 },
// //                 child: const Text("Submit GRN"),
// //               )
// //               const SizedBox(height: 16),
// //
// //               Obx(() => ElevatedButton(
// //                 onPressed: c.isFormValid
// //                     ? () => Get.to(() => const GRNPreviewPage())
// //                     : null,
// //                 child: const Text("Preview GRN"),
// //               )),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget itemCard(GRNItem item, GRNController c) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Column(
// //           children: [
// //             dropdown<Product>(
// //               label: "Product",
// //               items: c.products,
// //               value: item.product,
// //               text: (v) => v.name,
// //               onChanged: (v) => item.product = v,
// //             ),
// //             numberField("Qty (KG)", (v) => item.qty = v),
// //             numberField("Price / KG", (v) => item.price = v),
// //             dropdown<String>(
// //               label: "Quality",
// //               items: const ['A', 'B', 'C'],
// //               value: item.quality,
// //               text: (v) => v,
// //               onChanged: (v) => item.quality = v,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// COMMON WIDGETS
// //   Widget card(String title, Widget child) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// //             const Divider(),
// //             child,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget dropdown<T>({
// //     required String label,
// //     required List<T> items,
// //     required T? value,
// //     required String Function(T) text,
// //     required void Function(T?) onChanged,
// //   }) {
// //     return DropdownButtonFormField<T>(
// //       value: value,
// //       decoration: InputDecoration(labelText: label),
// //       items: items
// //           .map<DropdownMenuItem<T>>(
// //             (e) => DropdownMenuItem<T>(
// //           value: e,
// //           child: Text(text(e)),
// //         ),
// //       )
// //           .toList(),
// //       onChanged: onChanged,
// //       validator: (v) => v == null ? "Required" : null,
// //     );
// //   }
// //
// //   Widget numberField(String label, Function(double) onChanged) {
// //     return TextFormField(
// //       keyboardType: TextInputType.number,
// //       decoration: InputDecoration(labelText: label),
// //       validator: (v) =>
// //       double.tryParse(v ?? '') == null ? "Invalid number" : null,
// //       onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
// //     );
// //   }
// //
// //   Widget readOnly(String label, String value) {
// //     return TextFormField(
// //       initialValue: value,
// //       readOnly: true,
// //       decoration: InputDecoration(labelText: label),
// //     );
// //   }
// //
// //   Widget row(String l, String r) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [Text(l), Text(r)],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../widgets/common_widgets.dart';
// import 'grn_controller.dart';
// import 'grn_preview_page.dart';
// import 'models.dart';
// import '../widgets/common_widgets.dart';
//
// class GRNPage extends StatelessWidget {
//   const GRNPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // final GRNController c = Get.put(GRNController());
//     final GRNController c = Get.find<GRNController>();
//
//     final formKey = GlobalKey<FormState>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create GRN"),
//       ),
//       body: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               /// =========================
//               /// GRN DETAILS
//               /// =========================
//               card(
//                 "GRN Details",
//                 Column(
//                   children: [
//                     readOnlyField("GRN Number", c.grnNo),
//                     readOnlyField(
//                       "Date",
//                       "${c.date.day}-${c.date.month}-${c.date.year}",
//                     ),
//
//                     dropdown<CollectionCenter>(
//                       label: "Collection Center",
//                       items: c.centers,
//                       value: c.selectedCenter,
//                       text: (v) => v.name,
//                       onChanged: (v) {
//                         c.selectedCenter = v;
//                         c.update();
//                       },
//                     ),
//                     // dropdown<CollectionCenter>(
//                     //   label: "Collection Center",
//                     //   items: c.centers,
//                     //   value: c.selectedCenter,
//                     //   text: (v) => v.name,
//                     //   onChanged: (v) => c.selectedCenter = v,
//                     // ),
//                     dropdown<Farmer>(
//                       label: "Farmer",
//                       items: c.farmers,
//                       value: c.selectedFarmer,
//                       text: (v) => v.name,
//                       onChanged: (v) {
//                         c.selectedFarmer = v;
//                         c.update();
//                       },
//                     ),
//
//                     if (c.selectedFarmer != null)
//                       readOnlyField(
//                         "Farmer Phone",
//                         c.selectedFarmer!.phone,
//                       ),
//                   ],
//                 ),
//               ),
//
//               /// =========================
//               /// GRN ITEMS
//               /// =========================
//               card(
//                 "Procurement Items",
//                 Obx(
//                       () => Column(
//                     children: [
//                       if (c.items.isEmpty)
//                         const Padding(
//                           padding: EdgeInsets.all(8),
//                           child: Text(
//                             "No items added",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//
//                       ...c.items.map(
//                             (item) => itemCard(item, c),
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       OutlinedButton.icon(
//                         onPressed: c.addItem,
//                         icon: const Icon(Icons.add),
//                         label: const Text("Add Item"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// =========================
//               /// CRATE TRACKING (MANDATORY)
//               /// =========================
//               card(
//                 "Crate Tracking (Mandatory)",
//                 Column(
//                   children: [
//                     TextFormField(
//                       controller: c.crateInputCtrl,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: "Number of Crates",
//                         hintText: "Enter total crates",
//                       ),
//                       validator: (v) {
//                         final n = int.tryParse(v ?? '');
//                         if (n == null || n <= 0) {
//                           return "Enter valid crate count";
//                         }
//                         return null;
//                       },
//                       onChanged: (_) => c.addCrates(),
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     Obx(
//                           () => Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: c.crateNumbers
//                             .map(
//                               (e) => Chip(
//                             label: Text(e),
//                             backgroundColor:
//                             Colors.green.shade100,
//                           ),
//                         )
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               /// =========================
//               /// SUMMARY
//               /// =========================
//               card(
//                 "Summary",
//                 Obx(
//                       () => Column(
//                     children: [
//                       summaryRow(
//                         "Total Quantity (KG)",
//                         c.totalQty.toStringAsFixed(2),
//                       ),
//                       summaryRow(
//                         "Total Amount (₹)",
//                         c.totalAmt.toStringAsFixed(2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               /// =========================
//               /// PREVIEW BUTTON
//               /// =========================
//               // Obx(
//               //       () => SizedBox(
//               //     width: double.infinity,
//               //     child: ElevatedButton(
//               //       onPressed: c.isFormValid
//               //           ? () {
//               //         if (!formKey.currentState!.validate()) {
//               //           return;
//               //         }
//               //         Get.to(() => const GRNPreviewPage());
//               //       }
//               //           : null,
//               //       child: const Text("Preview GRN"),
//               //     ),
//               //   ),
//               // ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (!formKey.currentState!.validate()) {
//                       Get.snackbar("Error", "Please complete the form");
//                       return;
//                     }
//                     if (!c.isFormValid) {
//                       Get.snackbar("Error", "Please complete all required fields");
//                       return;
//                     }
//
//                     Get.to(() => const GRNPreviewPage());
//                   },
//                   child: const Text("Preview GRN"),
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
//   /// =========================
//   /// ITEM CARD
//   /// =========================
//   Widget itemCard(GRNItem item, GRNController c) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             /// HEADER ROW WITH DELETE
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Item",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     Get.defaultDialog(
//                       title: "Remove Item?",
//                       middleText: "This item will be deleted",
//                       textConfirm: "Yes",
//                       textCancel: "No",
//                       onConfirm: () {
//                         c.removeItem(item);
//                         Get.back();
//                       },
//                     );
//                   },
//
//                 ),
//               ],
//             ),
//
//             dropdown<Product>(
//               label: "Product",
//               items: c.products,
//               value: item.product,
//               text: (v) => v.name,
//               onChanged: (v) => item.product = v,
//             ),
//
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Qty (KG)"),
//               validator: (v) {
//                 final n = double.tryParse(v ?? '');
//                 if (n == null || n <= 0) return "Qty must be > 0";
//                 return null;
//               },
//               onChanged: (v) => item.qty = double.tryParse(v) ?? 0,
//             ),
//
//             TextFormField(
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Price / KG"),
//               validator: (v) {
//                 final n = double.tryParse(v ?? '');
//                 if (n == null || n <= 0) return "Price must be > 0";
//                 return null;
//               },
//               onChanged: (v) => item.price = double.tryParse(v) ?? 0,
//             ),
//
//             dropdown<String>(
//               label: "Quality Grade",
//               items: const ['A', 'B', 'C'],
//               value: item.quality,
//               text: (v) => v,
//               onChanged: (v) => item.quality = v,
//             ),
//
//             const SizedBox(height: 8),
//
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "Line Total: ₹ ${item.total.toStringAsFixed(2)}",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   /// =========================
//   /// UI HELPERS
//   /// =========================
//   Widget card(String title, Widget child) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.bold)),
//             const Divider(height: 20),
//             child,
//           ],
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
//         children: [
//           Text(label),
//           Text(value,
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//   Widget dropdown<T>({
//     required String label,
//     required List<T> items,
//     required T? value,
//     required String Function(T) text,
//     required void Function(T?) onChanged,
//   }) {
//     return DropdownButtonFormField<T>(
//       value: value,
//       decoration: InputDecoration(labelText: label),
//       items: items
//           .map<DropdownMenuItem<T>>(
//             (e) => DropdownMenuItem<T>(
//           value: e,
//           child: Text(text(e)),
//         ),
//       )
//           .toList(),
//       onChanged: onChanged,
//       validator: (v) => v == null ? "Required" : null,
//     );
//   }
// }
