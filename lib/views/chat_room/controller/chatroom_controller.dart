import 'dart:io';

import 'package:app/model/chat_room_model.dart';
import 'package:app/model/message_model.dart';
import 'package:app/model/user_model.dart';
import 'package:app/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatroomController extends GetxController {
  final msgCtrl = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  var uuid = Uuid();
  File? imageFile;
  Rx<String> imageUrl = ''.obs;
  final NotificationService notificationService = NotificationService();

  String getChatRoom(String targetUser) {
    var currentUser = user!.uid;
    if (currentUser[0].codeUnitAt(0) > targetUser[0].codeUnitAt(0)) {
      return '$currentUser$targetUser';
    } else {
      return '$targetUser$currentUser';
    }
  }

  UserModel getSender(UserModel currentUser, UserModel targetUser) {
    String cUser = currentUser.uid!;
    String tUser = targetUser.uid!;
    return cUser.compareTo(tUser) < 0 ? currentUser : targetUser;
  }

  UserModel getReceiver(UserModel currentUser, UserModel targetUser) {
    String cUser = currentUser.uid!;
    String tUser = targetUser.uid!;
    return cUser.compareTo(tUser) > 0 ? currentUser : targetUser;
  }

  Future<void> sendMessage(String targetUser, UserModel recieverDetail) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var roomId = getChatRoom(targetUser);
    var chatId = uuid.v6();
    DateTime time = DateTime.now();
    String formatTime = DateFormat().format(time);

    // user detail for save in sender details
    var senderDetail = UserModel(
      name: user!.displayName,
      email: user!.email,
      uid: user!.uid,
      image: user!.photoURL,
      time: DateTime.now(),
    );

    var messageDetails = MessageModel(
      imageUrl: imageUrl.value != '' ? imageUrl.value : null,
      message: msgCtrl.text,
      messageId: chatId,
      senderId: user!.uid,
      recieverId: targetUser,
      time: formatTime,
      type: 'text',
    );
    UserModel sender = getSender(senderDetail, recieverDetail);
    UserModel reciever = getReceiver(senderDetail, recieverDetail);

    var chatroomModel = ChatRoomModel(
      lastMessage: msgCtrl.text,
      lastSeen: formatTime,
      sender: sender,
      receiver: reciever,
      chatRoomId: roomId,
    );

    print("Sender: ${sender.email}");
    print("Reciever: ${reciever.email}");
    try {
      var data = await firebaseFirestore
          .collection('chatrooms')
          .doc(roomId)
          .collection('messages')
          .doc(chatId)
          .set(messageDetails.toJson())
          .then((value) async {
        await firebaseFirestore
            .collection('chatrooms')
            .doc(roomId)
            .set(chatroomModel.toJson())
            .then((value) {
          notificationService.pushNotificationFromFirebase(
            sendBy: recieverDetail.name ?? 'User',
            deviceToken: recieverDetail.idToken ?? '',
            msg: msgCtrl.text,
          );
          msgCtrl.clear();
          imageFile = null;
        });
      });
      update();
      print('.....................function work');
    } catch (e) {
      print('.......................Error:..$e');
    }
  }

  Stream<List<MessageModel>> getAllMessages(String targetUser) {
    String chatRoomId = getChatRoom(targetUser);
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return firebaseFirestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => MessageModel.fromjson(
                  e.data(),
                ),
              )
              .toList(),
        );
  }

  Future<void> pickImageFromGallery() async {
    var selectImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectImage != null) {
      imageFile = File(selectImage.path);
      croppedImage(File(imageFile!.path));
      imageUploadInFirebase(imageFile!);
      update();
    }
  }

  Future<void> croppedImage(File imagePath) async {
    var cropper = await ImageCropper().cropImage(sourcePath: imagePath.path);
    if (cropper != null) {
      imageFile = File(cropper.path);
    }
  }

  Future<void> imageUploadInFirebase(File image) async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    try {
      TaskSnapshot snapshot =
          await firebaseStorage.ref().child('chatImage').putFile(
                File(image.path),
                SettableMetadata(contentType: 'image/jpg'),
              );

      String url = await snapshot.ref.getDownloadURL();
      if (url != '') {
        imageUrl.value = url;
      }
      update();
    } catch (e) {
      print('.....................$e');
    }
  }
}
