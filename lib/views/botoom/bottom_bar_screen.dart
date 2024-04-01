import 'package:app/routes/app_routes.dart';
import 'package:app/views/botoom/binding/bottom_bar_binding.dart';
import 'package:app/views/botoom/cotroller/bottom_bar_controller.dart';
import 'package:app/views/call/call_screen.dart';
import 'package:app/views/group/grops_screen.dart';
import 'package:app/views/home/home_screen.dart';
import 'package:app/views/status/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBarScreen extends StatelessWidget {
  BottomBarScreen({super.key});
  final BottomBarController bottomBarController =
      Get.find<BottomBarController>();
  // List pages = [
  //   HomeScreen(),
  //   GroupsScreen(),
  //   StatusScreen(),
  //   CallScreen(),
  // ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.searchScreen);
                },
                child: const Icon(
                  Icons.search,
                  size: 27,
                  color: Colors.white,
                ),
              ),
            ),
            PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      bottomBarController.userSignOut();
                    },
                    child: Text('sign Out'),
                  )
                ];
              },
            )
          ],
          title: const Text(
            'Whatsap',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Chats',
              ),
              Tab(
                text: 'Groups',
              ),
              Tab(
                text: 'Status',
              ),
              Tab(
                text: 'Calls',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          //  SearchScreen(),
          HomeScreen(),
          GroupsScreen(),
          StatusScreen(),
          CallScreen(),
          //Placeholder()
        ]),
      ),
    );
  }
}
