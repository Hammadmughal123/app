import 'package:app/resources/my_sized_box.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/views/auth/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(),
            TextFormField(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0, top: 10),
                  child: Text('Forget Password'),
                ),
              ],
            ),
            20.h,
            ElevatedButton(
              onPressed: () {},
              child: Text('Login'),
            ),
            20.h,
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.sigup);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('If You Dont have account      Signup'),
                ],
              ),
            ),
            20.h,
            ElevatedButton(
              onPressed: () {
                loginController.googlSignInUser();
              },
              child: Text('Google Signin'),
            )
          ],
        ),
      ),
    );
  }
}
