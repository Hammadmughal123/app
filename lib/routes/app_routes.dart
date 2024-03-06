import 'package:app/views/auth/complete_profile/bindig/complete_profile_binding.dart';
import 'package:app/views/auth/complete_profile/comlete_profile.dart';
import 'package:app/views/auth/login/binding/login_binding.dart';
import 'package:app/views/auth/login/login_screen.dart';
import 'package:app/views/auth/signup/signup_binding/signup_binding.dart';
import 'package:app/views/auth/signup/signup_screen.dart';
import 'package:app/views/botoom/binding/bottom_bar_binding.dart';
import 'package:app/views/botoom/bottom_bar_screen.dart';
import 'package:app/views/call/binding/call_binding.dart';
import 'package:app/views/call/call_screen.dart';
import 'package:app/views/chat_room/binding/search_binding.dart';
import 'package:app/views/chat_room/chat_room_sreen.dart';
import 'package:app/views/group/binding/group_binding.dart';
import 'package:app/views/group/grops_screen.dart';
import 'package:app/views/home/binding/home_binding.dart';
import 'package:app/views/home/home_screen.dart';
import 'package:app/views/search/biding/search_binding.dart';
import 'package:app/views/search/search_user.dart';
import 'package:app/views/splash/binding/splash_binding.dart';
import 'package:app/views/splash/splash_screen.dart';
import 'package:app/views/status/binding/status_binding.dart';
import 'package:app/views/status/status_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/splash_screen';
  static const String login = '/log_in';
  static const String sigup = '/signup_screen';
  static const String bottom = '/bottom_screen';
  static const String completeProfile = '/complete_profile_screen';
  static const String home = '/home_screen';
  static const String call = '/call_screen';
  static const String groupScreen = '/group_screen';
  static const String statusScreen = '/status_screen';
  static const String searchScreen = '/search_screen';
  static const String chatroom = '/chatroom_screen';

  static getPages() => [
        GetPage(
          name: splash,
          page: () => SplashScreen(),
          binding: SplashBinding(),
        ),
        GetPage(
          name: chatroom,
          page: () => ChatRoomScree(),
          binding: ChatRoomBinding(),
        ),
        GetPage(
          name: searchScreen,
          page: () => SearchScreen(),
          binding: SearchBinding(),
        ),
        GetPage(
          name: login,
          page: () => LoginScreen(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: sigup,
          page: () => SignupScreen(),
          binding: SignupBinding(),
        ),
        GetPage(
          name: completeProfile,
          page: () => CompleteProfile(),
          binding: CompleteProfileBinding(),
        ),
        GetPage(
          name: bottom,
          page: () => BottomBarScreen(),
          binding: BottomBarBinding(),
        ),
        GetPage(
          name: home,
          page: () => HomeScreen(),
          binding: HomeBindng(),
        ),
        GetPage(
          name: call,
          page: () => CallScreen(),
          binding: CallBinding(),
        ),
        GetPage(
          name: groupScreen,
          page: () => GroupsScreen(),
          binding: GroupBinding(),
        ),
        GetPage(
          name: statusScreen,
          page: () => StatusScreen(),
          binding: StatusBinding(),
        ),
      ];
}
