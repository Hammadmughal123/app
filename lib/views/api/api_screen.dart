import 'package:app/views/api/controller/api_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiScreen extends StatelessWidget {
  ApiScreen({super.key});
  final ApiController apiController = Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Column(
        children: [
         // InputChip(label: 'label')
          Center(
                child: apiController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(child: Text(apiController.data)),
              ),
        ],
      )),
    );
  }
}
