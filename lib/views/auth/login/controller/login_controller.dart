import 'package:app/model/user_model.dart';
import 'package:app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pasCtrl = TextEditingController();
  final GoogleSignIn signIn = GoogleSignIn();

  Future<void> googlSignInUser() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await signIn.signIn();
      if (googleSignInAccount != null) {
        EasyLoading.show();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        User? user = userCredential.user;
        if (user != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? token = prefs.getString('token');
         
          DateTime time = DateTime.now();
          String formatTime = DateFormat.jm().format(time);
          UserModel userModel = UserModel(
              name: user.displayName,
              email: user.email,
              uid: user.uid,
              time: DateTime.now(),
              image: user.photoURL,
              idToken: token);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap())
              .then((value) {
            EasyLoading.showSuccess('You are Successfully Login');
            EasyLoading.dismiss();
            Get.toNamed(AppRoutes.bottom);
          });
        }
      }
    } on FirebaseException catch (ex) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('..............................${ex.message}');
    } catch (e) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('.........................$e');
    }
  }

  Future<void> loginUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      EasyLoading.show();
      var userCredential = await auth
          .signInWithEmailAndPassword(
              email: emailCtrl.text, password: pasCtrl.text)
          .then((value) {
        EasyLoading.showSuccess('You are successfuly Login');
        EasyLoading.dismiss();
        Get.toNamed(AppRoutes.bottom);
      });
    } on FirebaseException catch (ex) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('......................${ex.message}');
    } catch (e) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('.................$e');
    }
  }
}
