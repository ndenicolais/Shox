import 'package:get/get.dart';
import 'package:shox/features/database/controller/database_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<DatabaseController>(() => DatabaseController());
  }
}
