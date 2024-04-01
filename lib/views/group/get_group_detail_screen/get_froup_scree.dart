import 'dart:io';
import 'dart:ui';
import 'package:app/model/user_model.dart';
import 'package:app/resources/custom_widgets/custom_dailog.dart';
import 'package:app/resources/custom_widgets/custom_form_field.dart';
import 'package:app/resources/my_sized_box.dart';
import 'package:app/views/group/get_group_detail_screen/controller/get_group_detail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GetGroupDetailScreen extends StatelessWidget {
  final List<UserModel>? groupMemberList;
  GetGroupDetailScreen({super.key, this.groupMemberList});
  final GetGroupDetailController getGroupDetailController =
      Get.put<GetGroupDetailController>(GetGroupDetailController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetGroupDetailController>(builder: (ctrl) {
      return Scaffold(
        floatingActionButton: Obx(
          () => FloatingActionButton(
            backgroundColor: ctrl.data.value.isEmpty
                ? const Color.fromARGB(255, 178, 175, 175)
                : Colors.blueGrey[600],
            onPressed: () {
              if (ctrl.data.value != '') {
                ctrl.creteGroup(ctrl.data.value);
              } else {
                customDailog('ChatWat', 'Please Enter Name');
              }
            },
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(groupMemberList!.length.toString()),
        ),
        body: SizedBox(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      showCustomSheet(context, ctrl);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Obx(
                        () => ctrl.isImageUploading.value
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : ctrl.imageFile == null
                                ? const Icon(
                                    Icons.group_add,
                                    size: 35,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(ctrl.imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                    ),
                  )),
                  15.h,
                  CustomFormField(
                    controller: ctrl.name,
                    labelText: 'Enter Name',
                    onChangedMethod: (val) {
                      ctrl.nameData(val);
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupMemberList!.length,
                      itemBuilder: (context, index) {
                        var data = groupMemberList![index];
                        return ListTile(
                          title: Text(data.name ?? ''),
                          subtitle: Text(data.email ?? ''),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              imageUrl: data.image!,
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Obx(
                () => ctrl.isLoaing.value
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> showCustomSheet(
      BuildContext context, GetGroupDetailController ctrl) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Image From'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0, left: 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ctrl.getImageForGroup(ImageSource.camera).then((value) {
                          Get.back();
                        });
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ctrl
                            .getImageForGroup(ImageSource.gallery)
                            .then((value) {
                          Get.back();
                        });
                      },
                      child: const Icon(
                        Icons.photo_album,
                        size: 50,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
