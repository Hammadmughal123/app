import 'package:app/views/auth/complete_profile/controller/complete_profile_controller.dart';
import 'package:get/get.dart';

class CompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteProfileController>(() => CompleteProfileController());
  }
}
