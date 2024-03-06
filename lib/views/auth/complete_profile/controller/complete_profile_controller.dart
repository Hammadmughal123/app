import 'dart:io';
import 'dart:typed_data';

import 'package:app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CompleteProfileController extends GetxController {
  Uint8List? userImage;
  File? imageFile;

  Future<void> pickImage(ImageSource source) async {
    var selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      userImage = await selectedImage.readAsBytes();
      imageFile = File(selectedImage.path);
      cropImage(imageFile!);
      update();
    }
  }

  Future<void> cropImage(File image) async {
    var croppedImage = await ImageCropper().cropImage(sourcePath: image.path);
    if (croppedImage != null) {
      imageFile = File(croppedImage.path);
      update();
    }
  }

  Future<void> uploadImageInFirebase(File? image) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      EasyLoading.show();
      DateTime time = DateTime.now();
      var formatTime = DateFormat.Hm().format(time);
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('images')
          .child(formatTime)
          .putFile(
              File(image!.path), SettableMetadata(contentType: 'image/jpg'));

      var downloadUrl = await snapshot.ref.getDownloadURL();
      if (downloadUrl.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'image': downloadUrl,
        }).then((value) {
          EasyLoading.showSuccess('Image Saved');
          EasyLoading.dismiss();
          Get.toNamed(AppRoutes.bottom);
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('.................$e');
    }
  }
}
