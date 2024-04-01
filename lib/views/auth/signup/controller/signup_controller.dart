import 'package:app/model/user_model.dart';
import 'package:app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupCotroller extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  Future<void> signupUser() async {
    try {
      EasyLoading.show();
      var user = await auth
          .createUserWithEmailAndPassword(
              email: emailCtrl.text.trim(), password: passCtrl.text)
          .then((value) async {
        final SharedPreferences prfs = await SharedPreferences.getInstance();
        String? token = prfs.getString('token');
        UserModel userModel = UserModel(
            name: nameCtrl.text,
            email: emailCtrl.text,
            uid: value.user!.uid,
            time: DateTime.now(),
            idToken: token);
        var doc = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .set(userModel.toMap());
        Get.toNamed(AppRoutes.completeProfile);
        EasyLoading.showSuccess('Thanks for create account');
        EasyLoading.dismiss();
      });
    } on FirebaseException catch (ex) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('......................${ex.message}');
    } catch (e) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('..................${e}');
    }
  }
}
