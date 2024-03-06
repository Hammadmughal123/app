import 'package:app/views/group/controller/group_controller.dart';
import 'package:get/get.dart';

class GroupBinding extends Bindings{
  @override
  void dependencies() {
 Get.lazyPut<GroupController>(() => GroupController());

  }
}