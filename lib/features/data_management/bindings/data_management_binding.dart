import 'package:get/get.dart';
import 'package:shox/features/data_management/controller/backup_controller.dart';
import 'package:shox/features/database/controller/database_controller.dart';

class DataManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BackupController>(() => BackupController());
    // Used by PdfService for the PDF export.
    Get.lazyPut<DatabaseController>(() => DatabaseController());
  }
}
