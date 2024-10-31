import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';


import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/app/modules/help/views/help_view.dart';
import 'package:jiffy/app/modules/help/views/send_a_message_view.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../services/api_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
class HelpController extends GetxController {
  //TODO: Implement HelpController

  final count = 0.obs;
  RxBool isLoading = false.obs;
  RxBool emailStatus = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;


  sendEmail(){
    print("pressed send email");

    //adding navigation to adding message
    Get.to(const SendAMessageView());
  }


  changeEmailStatus(bool status){
    //adding navigation to adding message
    emailStatus.value = status;

}

 List<File?> galleryFiles = <File?>[].obs;
  final picker = ImagePicker();
  RxString errorMessage = ''.obs;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();
  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {
      galleryFiles.add(File(pickedFile.path));


      print("image path is ${pickedFile.path} and name is ${pickedFile.name}" );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Nothing is selected')),
      // );
      Get.snackbar("Empty", "Nothing is selected");
    }
  }

  void removeFile(File? galleryFil) {
    galleryFiles.remove(galleryFil);
  }


  sendTicket() async {
    print("pressed send ticket");
    print("name is ${name.value.text}");
    print("email is ${email.value.text}");
    print("message is ${message.value.text}");
    print("attachment is ${galleryFiles}");
    isLoading.value = true;
List sendFiles = [];
    for (var i = 0; i < galleryFiles.length; i++){
      await MultipartFile.fromFile(galleryFiles[i]!.path)
          .then((value) => sendFiles.add(value));}

    var formData = dio.FormData.fromMap({
      'name': name.value.text,
      'email': email.value.text,
      'message': message.value.text,
      'attachment': sendFiles



    });


    // for (final path in galleryFiles) {
    //   formData.files.add(MapEntry(
    //     'attachment[]', // Use an appropriate field name for your API
    //     await MultipartFile.fromFile(File(path!.path).path),
    //   ));
    // }


    try
    {
      final response = await apiConsumer.post(
        'support',
        formDataIsEnabled: true,
        formData: formData,
      );

      isLoading.value = false;
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print("ticket send successful");

        print("response of ticket is ${response} ");






clearAllFields();
Get.snackbar("Success", "Ticket Send Successful",snackPosition: SnackPosition.TOP);
         Get.off(const HelpView(),);
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print("the message is ${apiResponse.message}");
        errorMessage.value = apiResponse.message.toString() ?? "Error Happened";
        HapticFeedback.vibrate();
      }
    } catch (e, stackTrace) {
      isLoading.value = false;

      print('Ticket failed: ${e}');
      // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
      // handleApiErrorUser(apiResponse.message);
      errorMessage.value = e.toString() ?? "Please Check Fields and Try Again";
      HapticFeedback.vibrate();
    }
}

  void clearAllFields() {
    name.clear();
    email.clear();
    message.clear();
    errorMessage.value = '';
  }

}



