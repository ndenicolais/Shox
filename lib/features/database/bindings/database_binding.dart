import 'package:get/get.dart';
import 'package:shox/features/database/controller/database_controller.dart';

class DatabaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseController>(() => DatabaseController());
  }
}
