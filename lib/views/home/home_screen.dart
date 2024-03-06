import 'package:app/model/chat_room_model.dart';
import 'package:app/views/chat_room/chat_room_sreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    checkUserOnline('Online');
    homeController = Get.find<HomeController>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkUserOnline('Online');
    } else {
      checkUserOnline('Offline');
    }
  }

  Future<void> checkUserOnline(String status) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: homeController.getAllChatrooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              final data = snapshot.data![index];
              return ChatRoomTile(
                chatRoomData: data,
                onTap: () {
                  final userModel = data.receiver!.uid ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? data.sender
                      : data.receiver;
                  Get.to(ChatRoomScree(userModel: userModel));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final ChatRoomModel chatRoomData;
  final VoidCallback onTap;

  const ChatRoomTile({
    Key? key,
    required this.chatRoomData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ListTile(
        onTap: onTap,
        trailing: Text(chatRoomData.lastSeen ?? ''),
        tileColor: Colors.white,
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
                  imageUrl: chatRoomData.receiver!.uid ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? chatRoomData.sender!.image ??
                          'https://firebasestorage.googleapis.com/v0/b/newproject-34d86.appspot.com/o/images%2F09%3A41?alt=media&token=0628ba78-4513-4272-8aed-2f6520753ac7%22'
                      : chatRoomData.receiver!.image ??
                          'https://firebasestorage.googleapis.com/v0/b/newproject-34d86.appspot.com/o/images%2F09%3A41?alt=media&token=0628ba78-4513-4272-8aed-2f6520753ac7%22',
                ),
              ),
            ),
            if (chatRoomData.receiver!.status == 'Online')
              Positioned(
                right: -12,
                child: Container(
                  height: 16,
                  width: 20,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 29, 5, 187)),
                ),
              )
          ],
        ),
        title: Text(
            chatRoomData.receiver!.uid == FirebaseAuth.instance.currentUser!.uid
                ? chatRoomData.sender!.name ?? ''
                : chatRoomData.receiver!.name ?? ''),
        subtitle: Text(chatRoomData.lastMessage ?? ''),
      ),
    );
  }
}
