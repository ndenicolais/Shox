import 'package:get/get.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
