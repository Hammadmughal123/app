import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../controller/status_controller.dart';

class StatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatusController>(() => StatusController());
  }
}
