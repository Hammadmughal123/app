import 'package:app/routes/app_routes.dart';
import 'package:app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyClHy8rWMMXtpT5baNMdNX9cD0zvaMv3Ao",
      appId: "1:456395600429:android:a0c528c2901564e293fea4",
      messagingSenderId: '456395600429',
      projectId: "newproject-34d86",
      storageBucket: 'newproject-34d86.appspot.com',
    ),
  );

  NotificationService.getNotoficationToken();
  NotificationService.initializeAwesomeNotifications();
  runApp(const MyApp());
  // "3b490196-e948-44a4-a2aa-98f7f527cb78";
  // "3b490196-e948-44a4-a2aa-98f7f527cb78";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.getPages(),
    );
  }
}
