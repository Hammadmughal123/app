import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController customDailog(String title, String msg) {
  return Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.white,
    colorText: Colors.black,
  );
}
