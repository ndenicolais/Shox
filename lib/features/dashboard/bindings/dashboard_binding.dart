import 'package:get/get.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
