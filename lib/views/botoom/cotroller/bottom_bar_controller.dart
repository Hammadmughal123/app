import 'package:app/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int? value) {
    currentIndex.value = value!;
    update();
  }

  Future<void> userSignOut() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      EasyLoading.show();
      var user = await firebaseAuth.signOut().then((value) async {
        print('......................user signout');
        Get.toNamed(AppRoutes.login);
        print('...........................${firebaseAuth.currentUser!.uid}');
        var data = await firebaseFirestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .delete()
            .then((value) {
          EasyLoading.showSuccess('status');
          EasyLoading.dismiss();
        });
      });
    } on FirebaseException catch (e) {
      EasyLoading.showError('Error');
      EasyLoading.dismiss();
      print('........................${e.message}');
    } catch (e) {
      EasyLoading.showError('error');
      EasyLoading.dismiss();
      print('.....................$e');
    }
  }
}
