import 'package:app/routes/app_routes.dart';
import 'package:app/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashController extends GetxController {
  final NotificationService service = NotificationService();
  @override
  void onInit() {
    service.listenNotification();
    Future.delayed(const Duration(seconds: 3), () {
      checkUser();
    });
    super.onInit();
  }

  Future<void> checkUser() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (FirebaseAuth.instance.currentUser != null) {
      Get.toNamed(AppRoutes.bottom);
    } else {
      Get.toNamed(AppRoutes.login);
    }
  }
}
