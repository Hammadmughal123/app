import 'package:app/views/botoom/cotroller/bottom_bar_controller.dart';
import 'package:app/views/call/controller/call_controller.dart';
import 'package:app/views/group/controller/group_controller.dart';
import 'package:app/views/home/controller/home_controller.dart';
import 'package:app/views/status/binding/status_binding.dart';
import 'package:get/get.dart';

import '../../status/controller/status_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(() => BottomBarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CallController>(() => CallController());
    Get.lazyPut<StatusController>(() => StatusController());
    Get.lazyPut<GroupController>(() => GroupController());




  }
}
