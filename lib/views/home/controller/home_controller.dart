import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/chat_room_model.dart';

class HomeController extends GetxController {
  Stream<List<ChatRoomModel>> getAllChatrooms() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('chatrooms')
        .orderBy('lastSeen', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => ChatRoomModel.fromJson(
                  e.data(),
                ),
              )          
              .where(
                (element) => element.chatRoomId!.contains(
                  FirebaseAuth.instance.currentUser!.uid,
                ),
              )
              .toList(),
        );
  }
}
