import 'package:app/views/auth/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final SignupCotroller signupCotroller = Get.find<SignupCotroller>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: signupCotroller.nameCtrl,
            ),
            TextFormField(
              controller: signupCotroller.emailCtrl,
            ),
            TextFormField(
              controller: signupCotroller.passCtrl,
            ),
            ElevatedButton(
              onPressed: () {
                signupCotroller.createUserFromEmailAndPassword();
              },
              child: Text('Signup'),
            )
          ],
        ),
      ),
    );
  }
}
