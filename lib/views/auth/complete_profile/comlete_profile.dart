import 'dart:io';

import 'package:app/views/auth/complete_profile/controller/complete_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatelessWidget {
  CompleteProfile({super.key});
  final CompleteProfileController completeProfileController =
      Get.find<CompleteProfileController>();                       
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteProfileController>(builder: (ctrl) {
      return Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                ctrl.pickImage(ImageSource.gallery);
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: ctrl.imageFile != null
                    ? FileImage(File(ctrl.imageFile!.path))
                    : null,
              ),
            ),
            TextFormField(),
            ElevatedButton(
              onPressed: () {
                ctrl.uploadImageInFirebase(ctrl.imageFile);
              },
              child: Text('Save'),
            )
          ],
        ),
      );
    });
  }
}
