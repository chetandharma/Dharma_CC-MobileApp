import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assignment/assign_grn_list_page.dart';
import '../assignment/assignment_list_page.dart';
import '../assignment/assignment_page.dart';
import '../auth/auth_middleware.dart';
import '../auth/login_page.dart';
import '../dashboard/dashboard_page.dart';
import '../dispatch/dispatch_crate_list_page.dart';
import '../dispatch/dispatch_page.dart';
import '../farmers/farmer_list_page.dart';
import '../grn/create_grn_page.dart';
import '../grn/grn_list_page.dart';
import '../grn/grn_page.dart';
import '../grn/grn_view_page.dart';
import '../inventory/inventory_list_page.dart';
import '../packing/packing_page.dart';
import '../procurement_stock/procurement_stock_page.dart';

class Routes {
  static const login = '/login';
  static const dashboard = '/';
  static const grn = '/grn';

  static const grnList = '/grn-list';
  static const farmersList = '/farmers-list';
  static const inventoryList = '/inventory-list';
  static const grnCreate = '/grn-create';
  static const grnView = '/grn-view';
  static const grnPacking = '/packing';
  static const grnDispatch = '/dispatch';
  static const assignmentDetail = '/assignment';
  static const grnAssignListPage = '/grn-assigned-list';
  static const allAssignmentList = '/all-assigned-list';
  static const dispatchCrateList = '/ready-to-dispatch-assigned-list';
}

class AppRoutes {
  static final pages = [
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardPage(),
      middlewares: [AuthMiddleware()],
    ),
    //GetPage(name: Routes.grn, page: () => const GRNPage()),
    GetPage(name: Routes.grnList, page: () => GrnListPage()),
    GetPage(name: Routes.farmersList, page: () => FarmerListPage()),
    GetPage(name: Routes.dispatchCrateList, page: () => DispatchCrateListPage()),
    GetPage(name: Routes.inventoryList, page: () => ProcurementStockPage()), //InventoryListPage()),

    GetPage(name: Routes.grnCreate, page: () => CreateGrnPage()),
    //GetPage(name: Routes.grnView, page: () => const DispatchDetailPage()),
    GetPage(name: Routes.grnAssignListPage, page: () => GrnAssignListPage()),
    GetPage(
      name: Routes.allAssignmentList,
      page: () => AssignmentListPage(
        grnId: Get.arguments['grnId'],
      ),
    ),
    GetPage(
      name: Routes.assignmentDetail,
      page: () => AssignmentPage(
        grnId: Get.arguments['grnId'],
        grnNo: Get.arguments['grnNo'],
      ),
    ),


    GetPage(
      name: Routes.grnPacking,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;

        if (args == null ||
            !args.containsKey('grnId') ||
            !args.containsKey('grnNo') ||
            !args.containsKey('crateNo') ||
            !args.containsKey('crateId') ||
            !args.containsKey('assignmentId')) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Error: Packing data not provided',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        return PackingPage(
          grnId: args['grnId'] as String,
          grnNo: args['grnNo'] as String,
          crateNo: args['crateNo'] as String,
          crateId: args['crateId'] as String,
          assignmentId: args['assignmentId'] as String,
        );
      },
    ),



  ];
}
