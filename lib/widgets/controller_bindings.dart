import 'package:dropin_pos/controllers/auth_controller.dart';
import 'package:dropin_pos/controllers/menu_controller.dart';
import 'package:dropin_pos/controllers/navigation_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<MenuController>(MenuController());
    Get.put<NavigationController>(NavigationController());
  }
}