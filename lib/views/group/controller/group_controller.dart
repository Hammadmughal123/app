import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../model/group_model.dart';

class GroupController extends GetxController {
  @override
  void onInit() {
    getAllGroups();

    super.onInit();
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  var isGroupLoading = true.obs;
  RxList<GroupModel> myGroups = <GroupModel>[].obs;
  Future<void> getAllGroups() async {
    try {
      List<GroupModel> groupsList = [];
      await firebaseFirestore.collection('groups').get().then(
        (value) {
          groupsList = value.docs
              .map(
                (e) => GroupModel.fromJson(
                  e.data(),
                ),
              )
              .toList();
        },
      );
   
        print('........................al groups...${groupsList.length}');
      
   myGroups.clear();
      myGroups.value = groupsList
          .where((element) => element.groupMembers!
              .any((e) => e.uid == FirebaseAuth.instance.currentUser!.uid))
          .toList();
      
        print('..........................my groups...${myGroups.length}');
      
      isGroupLoading.value = false;
      update();
    } catch (e) {
      isGroupLoading.value = false;
      if (kDebugMode) {
        print('.......................$e');
      }
    }
  }
}
