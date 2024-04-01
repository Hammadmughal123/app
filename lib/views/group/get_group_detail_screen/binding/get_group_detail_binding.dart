import 'package:app/views/group/get_group_detail_screen/controller/get_group_detail_controller.dart';
import 'package:get/get.dart';

class GetGroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetGroupDetailController>(() => GetGroupDetailController());
  }
}
