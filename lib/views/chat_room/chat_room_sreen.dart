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
                  imageUrl:
                      userModel?.image ?? '', // Use ?. to handle null userModel
                ),
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel?.name ?? 'User', // Use ?. to handle null userModel
                  style: const TextStyle(color: Colors.white),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return const SizedBox();
                    }

                    var model = UserModel.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    userOnline = model.status;

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
                    Stack(
                      children: [
                        StreamBuilder(
                          stream: chatroomController.getAllMessages(
                              userModel?.uid ??
                                  ''), // Use ?. to handle null userModel
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
                              print(
                                  '.......................Error: ${snapshot.error}');
                            }
                            return ListView.builder(
                              reverse: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data![index];
                                final bool isCurrentUserMessage =
                                    data.senderId ==
                                        chatroomController.user
                                            ?.uid; // Use ?. to handle null user
                                return Column(
                                  children: [
                                    buildMessageWidget(
                                      data,
                                      isCurrentUserMessage,
                                      userOnline ?? '',
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        ctrl.imageFile != null
                            ? Positioned(
                                bottom: -2,
                                left: 0,
                                right: 0,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 18.0, left: 18),
                                      child: SizedBox(
                                        height: 400,
                                        width: Get.width,
                                        child: Image.file(
                                          File(ctrl.imageFile!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: -15,
                                      child: GestureDetector(
                                        onTap: () {
                                          ctrl.clearImage();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
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
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
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
                          child: const Icon(Icons.browse_gallery),
                        ),
                        hintText: 'Send message....',
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                    ),
                  ),
                  Obx(() => ctrl.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: () {
                            chatroomController.sendMessage(
                              userModel?.uid ?? '',
                              userModel!,
                            ); // Use ?. to handle null userModel
                          },
                          icon: const Icon(Icons.send),
                        ))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildMessageWidget(
      MessageModel data, bool isCurrentUserMessage, String userOnline) {
    return Align(
      alignment:
          isCurrentUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isCurrentUserMessage ? Colors.blue : Colors.green,
        ),
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.type == 'text' && data.message != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: isCurrentUserMessage ? Colors.blue : Colors.green,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  data.message!,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            if (data.type == 'text' && data.time != null)
              Container(
                padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                child: Row(
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
                  // "973da56abfdfd75ea977d742f8adeb12      =36532730";
                ),
              ),
            if (data.type == 'image' && data.imageUrl != null)
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: data.imageUrl!,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
