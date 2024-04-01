import 'package:app/model/user_model.dart';
import 'package:app/resources/custom_widgets/custom_dailog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewGroupController extends GetxController {
  @override
  void onInit() {
    getAdminData();
    super.onInit();
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<UserModel> groupMemberList = <UserModel>[].obs;
  UserModel? userModel;
  Future<void> addMemberInList(UserModel user) async {
    if (!groupMemberList.contains(user)) {
      groupMemberList.add(user);
      update();
    } else {
      customDailog(
        'User Already Added',
        'The selected user is already in the group.',
      );
    }
  }

  void removeUser(int index) {
    groupMemberList.removeAt(index);
    update();
  }

  Future<void> getAdminData() async {
    var data = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    userModel = UserModel.fromMap(data.data() as Map<String, dynamic>);
    groupMemberList.add(userModel!);
    update();
    print(
        '....................${userModel!.email}....${groupMemberList.length}');
  }

  Stream<List<UserModel>> getAllChatUsers() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('myChatUsers')
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => UserModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
