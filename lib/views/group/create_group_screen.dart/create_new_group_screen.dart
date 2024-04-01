import 'package:app/views/group/create_group_screen.dart/controller/create_new_group_controller.dart';
import 'package:app/views/group/get_group_detail_screen/get_froup_scree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

class CreateNewGroup extends StatelessWidget {
  CreateNewGroup({super.key});
  final CreateNewGroupController controller =
      Get.find<CreateNewGroupController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewGroupController>(builder: (ctrl) {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: ctrl.groupMemberList.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  onPressed: () {
                    Get.to(() => GetGroupDetailScreen(
                          groupMemberList: ctrl.groupMemberList,
                        ));
                  },
                  child: const Icon(Icons.add),
                ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.groupMemberList.length,
                    itemBuilder: (context, index) {
                      var memberData = ctrl.groupMemberList[index];
                      if (kDebugMode) {
                        print('.......................${memberData.email}');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 10),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:18.0,left: 18),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: memberData.image!,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                               // Spacer(),
                                Positioned(
                                  bottom: -17,
                                  child: Text(
                                    memberData.name ?? '',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                memberData.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? const SizedBox.shrink()
                                    : Positioned(
                                        left: 44,
                                        top: -4,
                                        child: GestureDetector(
                                          onTap: () async {
                                            ctrl.removeUser(index);
                                          },
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              StreamBuilder(
                stream: controller.getAllChatUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.isEmpty || !snapshot.hasData) {
                    return const Center(
                      child: Text('No User Found'),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            controller.addMemberInList(data).then((value) {});
                          },
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: CachedNetworkImage(
                                  imageUrl: data.image!,
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              ),
                              title: Text(data.name ?? ''),
                              subtitle: Text(data.email ?? ''),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
