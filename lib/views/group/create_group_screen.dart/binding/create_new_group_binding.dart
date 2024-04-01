import 'package:app/views/group/create_group_screen.dart/controller/create_new_group_controller.dart';
import 'package:get/get.dart';

class CreateNewGroupBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateNewGroupController>(() => CreateNewGroupController());
  }
}
