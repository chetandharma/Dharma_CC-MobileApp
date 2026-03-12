import 'package:get/get.dart';

import '../clients/client_controller.dart';


class DispatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ClientController());
  }
}