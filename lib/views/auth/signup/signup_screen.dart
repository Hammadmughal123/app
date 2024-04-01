import 'package:app/resources/my_sized_box.dart';
import 'package:app/views/auth/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final SignupCotroller signupCotroller = Get.put<SignupCotroller>(SignupCotroller());
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
            20.h,
            AbsorbPointer(
              child: GestureDetector(
                  onTap: () {
                    signupCotroller.signupUser();
                  },
                  child: const Text('Signup')),
            )
          ],
        ),
      ),
    );
  }
}
