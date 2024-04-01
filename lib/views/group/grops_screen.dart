import 'package:app/routes/app_routes.dart';
import 'package:app/views/group/controller/group_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsScreen extends StatelessWidget {
  GroupsScreen({super.key});
  final GroupController groupController =
      Get.put<GroupController>(GroupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createNewGroup);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => groupController.isGroupLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: groupController.myGroups.length,
                itemBuilder: (context, index) {
                  var data = groupController.myGroups[index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(data.groupName ?? ''),
                      subtitle: const Text('Last message'),
                      leading: data.groupImage == ''
                          ? Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300]),
                              child: const Center(
                                child: Icon(Icons.group),
                              ),
                            )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                imageUrl: data.groupImage ?? '',
                                placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.group),
                                ),
                              ),
                          ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
