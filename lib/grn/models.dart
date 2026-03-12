// class CollectionCenter {
//   final String id;
//   final String name;
//   CollectionCenter(this.id, this.name);
// }
//
// class Farmer {
//   final String id;
//   final String name;
//   final String phone;
//   Farmer(this.id, this.name, this.phone);
// }
// class Product {
//   final String id;
//   final String name;
//   Product(this.id, this.name);
// }
// // class CollectionCenter {
// //   final String id;
// //   final String name;
// //
// //
// //   CollectionCenter({
// //     required this.id,
// //     required this.name,
// //
// //   });
// // }
// // class Farmer {
// //   final String id;
// //   final String name;
// //   final String phone;
// //
// //   Farmer({
// //     required this.id,
// //     required this.name,
// //     required this.phone,
// //   });
// // }
// // class Product {
// //   final String id;
// //   final String name;
// //
// //
// //   Product({
// //     required this.id,
// //     required this.name,
// //
// //   });
// // }
//
//
// class GRNItem {
//   Product? product;
//   double qty = 0;
//   double price = 0;
//   String? quality;
//
//   double get total => qty * price;
// }
//
// class GRN {
//   final String grnNo;
//   final DateTime date;
//   final CollectionCenter center;
//   final Farmer farmer;
//   final List<GRNItem> items;
//   final List<String> crates;
//   final double totalQty;
//   final double totalAmount;
//   GRNStatus status;
//
//   GRN({
//     required this.grnNo,
//     required this.date,
//     required this.center,
//     required this.farmer,
//     required this.items,
//     required this.crates,
//     required this.totalQty,
//     required this.totalAmount,
//     this.status = GRNStatus.created,
//   });
// }
//
// enum GRNStatus {
//   created,
//   packingStarted,
//   packed,
//   dispatched,
// }
