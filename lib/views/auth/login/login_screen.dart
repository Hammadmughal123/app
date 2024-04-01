import 'package:app/resources/my_sized_box.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/views/auth/login/controller/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Obx(() => GestureDetector(
                  onTap: () {
                    loginController.googlSignInUser();
                  },
                  child: AnimatedContainer(
                    duration:const Duration(microseconds: 300),
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: loginController.isLoading.value
                            ? []
                            : [
                                const BoxShadow(
                                    offset: Offset(10, 10),
                                    color: Colors.grey,
                                    spreadRadius: -2)
                              ]),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.person_badge_plus_fill),
                          Spacer(),
                          Text(
                            'Signin With Google',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
