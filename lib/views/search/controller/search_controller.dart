import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchController extends GetxController {
  @override
  void onInit() {
    getAllUsers();
    searchCtrl.addListener(() {
      searchUser();
    });
    super.onInit();
  }

  List userList = [];
  List resultUser = [];
  final searchCtrl = TextEditingController();

  Future<void> getAllUsers() async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var data = await firebaseFirestore.collection('users').get();
    userList = data.docs;
    update();
  }

  Future<void> searchUser() async {
    List data = [];
    if (searchCtrl.text.isNotEmpty) {
      for (var resultUsers in userList) {
        var name = resultUsers['name'].toString().toLowerCase();
        var email = resultUsers['email'].toString().toLowerCase();
        if (name.contains(searchCtrl.text.toLowerCase()) ||
            email.contains(searchCtrl.text.toLowerCase())) {
          data.add(resultUsers);
        }
      }
      resultUser = data;
      getAllUsers();
      print('..............${resultUser.length}');
      update();
    }
  }
}
