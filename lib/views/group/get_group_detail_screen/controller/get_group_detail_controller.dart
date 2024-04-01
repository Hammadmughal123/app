import 'dart:io';
import 'package:app/model/group_model.dart';
import 'package:app/views/group/create_group_screen.dart/controller/create_new_group_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../routes/app_routes.dart';

class GetGroupDetailController extends GetxController {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final name = TextEditingController();
  File? imageFile;
  var uid = const Uuid();
  String? imageUrl;
  var isLoaing = false.obs;
  var data = ''.obs;
  var isImageUploading = false.obs;
  final CreateNewGroupController createNewGroupController =
      Get.find<CreateNewGroupController>();

  Future<void> getImageForGroup(ImageSource source) async {
    final select = await ImagePicker().pickImage(source: source);
    if (select != null) {
      imageFile = File(select.path);

      update();
      cropImageForGroup(imageFile!).then((value) {
        imageUplodInFirebase(imageFile!);
      });
    }
  }

  void nameData(String value) {
    data.value = value;
    update();
  }

  Future<void> cropImageForGroup(
    File file,
  ) async {
    final crop = await ImageCropper().cropImage(sourcePath: file.path);
    if (crop != null) {
      imageFile = File(crop.path);
      update();
    }
  }

  Future<void> creteGroup(
    String name,
  ) async {
    var groupId = uid.v6();
    try {
      isLoaing.value = true;
      GroupModel model = GroupModel(
        groupId: groupId,
        groupName: name,
        groupMembers: createNewGroupController.groupMemberList,
        groupImage: imageUrl,
        admin: createNewGroupController.userModel!.name,
        createdAt: DateTime.now(),
      );
      await firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set(
            model.toJson(),
          )
          .then((value) {
        isLoaing.value = false;
        Get.offAllNamed(AppRoutes.groupScreen);
      });
      update();
    } catch (e) {
      if (kDebugMode) {
        isLoaing.value = false;

        print('..................................$e');
      }
    }
  }

  Future<void> imageUplodInFirebase(File groupImage) async {
    try {
      isImageUploading.value = true;
      TaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('groupImage')
          .child(DateTime.now().toString())
          .putFile(
            groupImage,
            SettableMetadata(contentType: 'image/jpg'),
          );
      String groupImageUrl = await snapshot.ref.getDownloadURL();
      print('....................group image..${groupImageUrl}');
      if (groupImageUrl != '') {
        imageUrl = groupImageUrl;
        isImageUploading.value = false;
        print('....................group image..${imageUrl}');
      }
    } catch (e) {
      isImageUploading.value = false;
      if (kDebugMode) {
        print('..............................$e');
      }
    }
  }
}
