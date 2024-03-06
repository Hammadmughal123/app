import 'package:app/views/call/controller/call_controller.dart';
import 'package:app/views/group/controller/group_controller.dart';
import 'package:app/views/home/controller/home_controller.dart';
import 'package:app/views/search/controller/search_controller.dart';
import 'package:app/views/status/controller/status_controller.dart';
import 'package:get/get.dart';

class HomeBindng extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<GroupController>(() => GroupController());
    Get.lazyPut<StatusController>(() => StatusController());
    Get.lazyPut<CallController>(() => CallController());
    Get.lazyPut<CustomSearchController>(() => CustomSearchController());
  }
}
