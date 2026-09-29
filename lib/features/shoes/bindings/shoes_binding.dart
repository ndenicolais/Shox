import 'package:get/get.dart';
import 'package:shox/features/shoes/controller/shoes_controller.dart';

class ShoesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShoesController>(() => ShoesController());
  }
}
