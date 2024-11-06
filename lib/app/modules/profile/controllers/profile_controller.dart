import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jiffy/app/modules/auth/views/login_view.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/profile/views/update_profile.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:jiffy/main.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isAuth = false.obs;

  @override
  void onInit() {
    super.onInit();
    print(userToken.toString() + 'test token');
    if (userToken == null) {
      print('tesadsadsa');
      isAuth.value = false;
    } else {
      isAuth.value = true;

      fetchProfile();
    }
  }

  @override
  void onReady() {
    super.onReady();
    print(userToken.toString() + 'test token');
  }

  var userModel = User(
    id: 0,
    firstName: '',
    lastName: '',
    photo: '',
    email: '',
    phone: '',
    dob: '',
    total_points: 0,
  ).obs;

  var isLoading = true.obs;
  var firstNameError = ''.obs;
  var lastNameError = ''.obs;
  var phoneError = ''.obs;
  var dobError = ''.obs;
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var passwordError = ''.obs;
  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  bool validatePassword(String password) {
    if (password.isEmpty) {
      passwordError.value = 'Old password cannot be empty';
      return false;
    } else {
      passwordError.value = '';
      return true;
    }
  }

  bool validateNewPassword(String newPassword) {
    if (newPassword.isEmpty) {
      newPasswordError.value = 'New password cannot be empty';
      return false;
    } else {
      newPasswordError.value = '';
      return true;
    }
  }

  bool validateConfirmPassword(String confirmPassword, String newPassword) {
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Confirm password cannot be empty';
      return false;
    } else if (confirmPassword != newPassword) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    } else {
      confirmPasswordError.value = '';
      return true;
    }
  }

  bool validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      firstNameError.value = 'First name cannot be empty';
      return false;
    } else {
      firstNameError.value = '';
      return true;
    }
  }

  bool validateLastName(String lastName) {
    if (lastName.isEmpty) {
      lastNameError.value = 'Last name cannot be empty';
      return false;
    } else {
      lastNameError.value = '';
      return true;
    }
  }

  bool validatePhone(String phone) {
    if (phone.isEmpty) {
      phoneError.value = 'Phone cannot be empty';
      return false;
    } else {
      phoneError.value = '';
      return true;
    }
  }

  bool validateDob(String dob) {
    if (dob.isEmpty) {
      dobError.value = 'Date of birth cannot be empty';
      return false;
    } else {
      dobError.value = '';
      return true;
    }
  }

  void navigateToUpdateProfile() {
    Get.off(() => ProfileUpdate());
  }

  void updateUserProfile(Map<String, dynamic> data) async {
    try {
      isLoading(true);
      await apiConsumer.post(
        'profile/update-information',
        body: data,
      );

      fetchProfile();
      isLoading(false);
      update();
      Get.snackbar('Success', 'Information updated successfully');
    } finally {
      isLoading(false);
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await prefs.clear();
    print('User data cleared');
  }

  void reset() {
    userToken = null;
    clearUserData();
    Get.offAll(LoginView()); // Navigate to signup screen
  }

  void Logout() async {
    try {
      isLoading(true);
      await apiConsumer.post(
        'logout',
      );
      if (await GoogleSignIn().isSignedIn()) {
        GoogleSignIn().disconnect();
      }
      reset();
      firebase.FirebaseAuth.instance.signOut();
      if (firebase.FirebaseAuth.instance.currentUser != null) {
        firebase.FirebaseAuth.instance.currentUser!.delete();
      }
      Get.snackbar('Success', 'Logged out successfully');
      reset();
    } finally {

      isLoading(false);
    }
  }





  void deleteAccount() async {
    try {
      isLoading(true);
      await apiConsumer.post(
        'customer-delete',
      );

      Get.snackbar('Success', 'Account Deleted successfully');
      reset();
    } finally {
      isLoading(false);
    }
  }

  void updatePassword(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final response = await apiConsumer.post(
        'change-password',
        body: data,
      );

      final apiResponse = ApiResponse.fromJson(response);
      print('reset successful');
      Get.snackbar('Success', 'Password updated successfully');
      oldPassword.value = '';
      newPassword.value = '';
      confirmPassword.value = '';
      isLoading(false);

      // Handle successful resetpassowrd
    } catch (e, stackTrace) {
      isLoading(false);
      print('reset failed: ${e}');
      print(e.toString() + stackTrace.toString());

      final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));

      handleApiErrorUser(apiResponse.message);
    }
  }

  void updatePhoto(String filePath) async {
    try {
      isLoading(true);
      var formData = dio.FormData.fromMap({
        'avatar': await dio.MultipartFile.fromFile(filePath),
      });
      await apiConsumer.post('profile/update-photo',
          formData: formData, formDataIsEnabled: true);
      fetchProfile();

      Get.snackbar('Success', 'Avatar updated successfully');
    } finally {
      isLoading(false);
    }
  }

  void fetchProfile() async {
    try {
      isLoading(true);

      final response = await apiConsumer.get(
        'user',
      );
      print('teasdsada');
      userModel.value = User.fromJson(response['data']);
      isLoading(false);
      print(userModel.value.firstName + 'test value');
    } catch (e) {
      print('test $e');
      isLoading(false);
    }
  }
}
