import 'package:app/model/user_model.dart';
import 'package:app/views/chat_room/chat_room_sreen.dart';
import 'package:app/views/search/controller/search_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final CustomSearchController searchController =
      Get.find<CustomSearchController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomSearchController>(builder: (ctrl) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10),
          child: Column(
            children: [
              TextFormField(
                controller: searchController.searchCtrl,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: ctrl.resultUser.length,
                itemBuilder: (context, index) {
                  var snapsht = ctrl.resultUser[index];

                  UserModel userModel =
                      UserModel.fromMap(snapsht.data() as Map<String, dynamic>);

                  print('..............................${userModel.image}');
                  return GestureDetector(
                    onTap: () {
                      Get.to(ChatRoomScree(
                        userModel: userModel,
                      ));
                    },
                    child: Card(
                      elevation: 6,
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Center(
                                    child: Icon(Icons.error),
                                  ),
                              placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                              imageUrl:
                                  userModel.image ?? 'assets/images/1.jpg'),
                        ),
                        title: Text(userModel.name ?? ''),
                        subtitle: Text(userModel.uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? '${userModel.email}(You)' ?? ''
                            : userModel.email ?? ''),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      );
    });
  }
}
