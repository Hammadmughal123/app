import 'package:app/views/chat_room/controller/chatroom_controller.dart';
import 'package:app/views/search/controller/search_controller.dart';
import 'package:get/get.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatroomController>(() => ChatroomController());
  }
}
