import 'package:get/get.dart';
import 'package:shox/features/auth/gender_selection/controller/gender_selection_controller.dart';

class GenderSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenderSelectionController>(() => GenderSelectionController());
  }
}
