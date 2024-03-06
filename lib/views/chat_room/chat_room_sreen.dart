import 'dart:io';

import 'package:app/model/user_model.dart';
import 'package:app/views/chat_room/controller/chatroom_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/message_model.dart';

class ChatRoomScree extends StatelessWidget {
  final UserModel? userModel;

  ChatRoomScree({Key? key, this.userModel}) : super(key: key);

  final ChatroomController chatroomController =
      Get.put<ChatroomController>(ChatroomController());
  var userOnline;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatroomController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.black,
            leading: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                  imageUrl: userModel!.image ?? '',
                ),
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel!.name ?? 'User',
                  style: const TextStyle(color: Colors.white),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox();
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return const SizedBox();
                    }

                    var model = UserModel.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    userOnline = model;

                    return Text(
                      model.status ?? '',
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    );
                  },
                )
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    StreamBuilder(
                      stream:
                          chatroomController.getAllMessages(userModel!.uid!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Start Chat'),
                          );
                        }
                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];
                            final bool isCurrentUserMessage =
                                data.senderId == chatroomController.user!.uid;
                            return Align(
                              alignment: isCurrentUserMessage
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isCurrentUserMessage
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                                margin: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.message!,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            data.time!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          Text(
                                            userOnline == 'Online'
                                                ? 'Seen'
                                                : 'Delivered',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                      data.imageUrl == ''
                                          ?SizedBox.shrink(): CachedNetworkImage(
                                            height: 200,
                                            width: Get.width/2,
                                              imageUrl: data.imageUrl ?? '',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Icon(Icons.error),
                                              ),
                                            )
                                         
                                    ],
                                    // ctrl.imageUrl.value !=null?
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ctrl.imageFile != null
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 28.0),
                                      child: GestureDetector(
                                        onTap: () {
                                         
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: Get.height / 2,
                                  width: Get.width,
                                  child: Image.file(
                                    File(ctrl.imageFile!.path),
                                    //fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: chatroomController.msgCtrl,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              ctrl.pickImageFromGallery();
                            },
                            child: Icon(Icons.browse_gallery)),
                        hintText: 'Send message....',
                        contentPadding: EdgeInsets.only(left: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      chatroomController.sendMessage(
                          userModel!.uid!, userModel!);
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
  Widget buildMessageWidget(MessageModel data, bool isCurrentUserMessage, String userOnline) {
  return Align(
    alignment: isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isCurrentUserMessage ? Colors.blue : Colors.green,
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.message!,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.time!,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  userOnline == 'Online' ? 'Seen' : 'Delivered',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            data.imageUrl == ''
                ? SizedBox.shrink()
                : CachedNetworkImage(
                    height: 200,
                    width: Get.width / 2,
                    imageUrl: data.imageUrl ?? '',
                    placeholder: (context, url) => const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error),
                    ),
                  ),
          ],
        ),
      ),
    ),
  );
}

}
