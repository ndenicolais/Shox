import 'package:get/get.dart';
import 'package:shox/features/auth/login/controller/login_controller.dart';
import 'package:shox/features/auth/signup/controller/signup_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
