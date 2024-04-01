import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  @override
  void onInit() {
    makeImageToVideoRequest();
    super.onInit();
  }

  var data;
  var isLoading = true.obs;
  Future<void> makeImageToVideoRequest() async {
    var url = Uri.parse('https://api.stability.ai/v2beta/image-to-video');

    // Load image from assets
    var imagePath = 'assets/images/1.jpg';
    var imageBytes = await rootBundle.load(imagePath);
    var imageFile = http.MultipartFile.fromBytes(
      'image',
      imageBytes.buffer.asUint8List(),
      filename: '1.jpg',
    );

    var apiKey = "sk-jMiF3J6WrHCR9zUmxZQ2G5ws3PgAPIoaLSPumYnoSkPSOKvZ";

    var request = http.MultipartRequest('POST', url)
      ..headers['authorization'] = 'Bearer sk-$apiKey'
      ..fields['seed'] = '0'
      ..fields['cfg_scale'] = '1.8'
      ..fields['motion_bucket_id'] = '127'
      ..files.add(imageFile);

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    debugPrint('.............................Response: ${response.statusCode}');

    if (response.statusCode == 200) {
      debugPrint('.............................Response: ${response.body}');
      data = response.body;
      isLoading.value = false;
      update();
    } else {
      isLoading.value = false;

      debugPrint(
          '...........................Request failed with status: ${response.statusCode}.');
    }
  }
}
