import 'package:get/get.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';
import 'package:shox/features/users/controller/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<ShoesController>(() => ShoesController());
  }
}
