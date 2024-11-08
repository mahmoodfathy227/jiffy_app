import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;
import 'package:jiffy/app/modules/home/views/home_view.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as authTest;
import 'package:device_info_plus/device_info_plus.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../global/config/constant.dart';
import '../../global/model/model_response.dart';
import '../../services/api_service.dart';
import '../views/create_new_password_view.dart';
import '../views/login_view.dart';
import '../views/password_updated.dart';
import '../views/verification_code_view.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var company = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var emailError = ''.obs;
  var companyError = ''.obs;
  var passwordError = ''.obs;
  var isGuest = false.obs;
  var confirmPasswordError = ''.obs;
  var isLoading = false.obs;
  var socialView = false.obs;
  var user = Rxn<User>();
  var firstNameError = ''.obs;
  var lastNameError = ''.obs;
  var googleSignIn = GoogleSignIn();
  var  errorMessage = ''.obs;

  authTest.FirebaseAuth auth = authTest.FirebaseAuth.instance;

  String fcmToken = '';
  String deviceId = '';
  FirebaseMessaging? messaging;


  RxBool isEnded = false.obs;
  RxInt timer = 20.obs;
  RxInt tweenId = 0.obs;
  int randomId = 0;
  RxBool isResetDone = false.obs;
  @override
  void onReady() {
    super.onReady();
    // _requestNotificationPermissions();
    //_initFCMToken();
  }

  @override
  void onInit() {
    super.onInit();
    getDeviceId();
    socialView.value = true;
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; // المعرف الصحيح لجهاز Android
      print('Android ID: $deviceId');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor!;
      print('iOS ID: $deviceId');
    }
  }

  Future<void> requestNotificationPermissions() async {
    // طلب الأذونات للإشعارات لكل من Android وiOS
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    if (GetPlatform.isIOS) {
      await messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        print('User canceled the Google Sign-In process');
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null) {
        googleAuth = await googleUser.authentication;
      }

      if (googleAuth.accessToken != null) {
        final providerToken = googleAuth.accessToken;

        final authTest.OAuthCredential credential =
            authTest.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final authTest.UserCredential userCredential =
            await auth.signInWithCredential(credential);
        email.value = userCredential.user!.email ?? '';
        firstName.value = userCredential.user!.displayName ?? '';
        lastName.value = '(G)'; // يمكن تعديلها حسب الحاجة

        loginWithSocial(userCredential.user!.uid!);
      } else {
        print(
            'Failed to retrieve idToken. The Google Sign-In might have failed.');
        Get.snackbar(
            'Error', 'Failed to sign in with Google. Please try again.');
      }
    } catch (e, stackTrace) {
      isLoading.value = false;
      print("Google Login Failed: $e\n$stackTrace");
      Get.snackbar('Error',
          'An error occurred during Google Sign-In. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initFCMToken() async {
    messaging = FirebaseMessaging.instance;

    // توليد الـ FCM Token
    messaging!.getToken().then((value) {
      if (value != null) {
        fcmToken = value;
        print('FCM Token: $fcmToken');
      } else {
        print('Failed to generate FCM Token.');
      }
    });

    messaging!.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      print('FCM Token refreshed: $fcmToken');
    });
  }


  bool isUser = true;
  Future<void> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isUserValue = prefs.getBool('isUser');
    if (isUserValue != null) {
      if (isUserValue == false) {
        isUser = false;
      } else {
        isUser = true;
      }
    }
    print("isUser: $isUser");
  }

  Future<void> appleLogin() async {
    try {
      isLoading.value = true;

      // Step 1: Get the credential from Apple
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Step 2: Use the credential to sign in with Firebase or call your API
      final providerToken = credential.userIdentifier;

      email.value = credential.email ?? '';
      firstName.value = credential.givenName ?? '';
      lastName.value = '(A)'; // يمكن تعديلها حسب الحاجة

      // استدعاء API الخاص بك
      loginWithSocial(providerToken!);
    } catch (e, stackTrace) {
      isLoading.value = false;
      print("Apple Login Failed: $e\n$stackTrace");
      Get.snackbar(
          'Error', 'An error occurred during Apple Sign-In. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  String invalidEmailError = 'Enter a valid email';

  bool validateEmail() {
    if (!GetUtils.isEmail(email.value)) {
      emailError.value = invalidEmailError;
      return false;
    }
    emailError.value = '';
    return true;
  }

  void loginWithSocial(String providerToken) async {
    if (validateEmail()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';

      var formData = dio.FormData.fromMap({
        'provider_token': providerToken,
        'email': email.value,
        'first_name': firstName.value,
        'last_name': lastName.value,
        'imei': deviceId, // استخدام الجهاز الديناميكي الفريد
        'device_token': fcmToken, // FCM token للإشعارات
        'device_type': GetPlatform.isAndroid ? 'android' : 'ios',
      });

      try {
        final response = await apiConsumer.post(
          'login/google',
          formDataIsEnabled: true,
          formData: formData,
        );

        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          isGuest.value = false;
          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          clearFields();

          Get.offNamedUntil(Routes.MAIN, (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('Login failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        isGuest.value = false;
        isLoading.value = false;
        print('Login failed: $e $stackTrace');
        final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        handleApiErrorUser(apiResponse.message);
      }
    }
  }
 String userType = "user";
  setUser(value){
    userType = value;
  }
  void register() async {
    bool isValid = validateFirstName() &
        validateLastName() &
        validateEmail() &
        validatePassword() &
        validateConfirmPassword();
    if (isValid) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      var formData = dio.FormData.fromMap({
        'first_name': firstName.value,
        'last_name': lastName.value,
        'email': email.value,
        'password': password.value,
        'password_confirmation': confirmPassword.value,
        'type': userType,
        // 'imei': deviceId, // استخدام معرف الجهاز الديناميكي الفريد
        // 'token': fcmToken.isEmpty ? 'test' : fcmToken, // FCM token
        // 'device_type': GetPlatform.isAndroid ? 'android' : 'ios',
      });
      try {
        final response = await apiConsumer.post(
          'register',
          formDataIsEnabled: true,
          formData: formData,
        );

        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Registration successful');
          isGuest.value = false;

          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          clearFields();
Get.toNamed(Routes.LOGIN);
          // Get.offNamedUntil(Routes.MAIN, (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          errorMessage.value = apiResponse.message ?? "Error Happened";
          print('Registration failed: ${response.statusMessage}');
        }
        isLoading.value = false;
      } catch (e, stackTrace) {
        isGuest.value = false;
        isLoading.value = false;
        print('Registration failed:  ${e} $stackTrace');
        print('Registration failed:  ${e} $stackTrace');
        final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        handleApiErrorUser(apiResponse.message);
        errorMessage.value = apiResponse.message ?? "Error Happened";
      }
    }
  }

  void clearFields() {
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    firstName.value = '';
    lastName.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    firstNameError.value = '';
    lastNameError.value = '';
  }

  static const String shortPasswordError =
      'Password must be at least 6 characters';

  bool validatePassword() {
    if (password.value.length < 6) {
      passwordError.value = shortPasswordError;
      return false;
    }
    passwordError.value = '';
    return true;
  }

  bool validateConfirmPassword() {
    if (confirmPassword.value != password.value) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    }
    confirmPasswordError.value = '';
    return true;
  }

  bool validateFirstName() {
    if (firstName.value.isEmpty) {
      firstNameError.value = 'First name required!';
      return false;
    }
    firstNameError.value = '';
    return true;
  }

  bool validateLastName() {
    if (lastName.value.isEmpty) {
      lastNameError.value = 'Last name required!';
      return false;
    }
    lastNameError.value = '';
    return true;
  }

  void login() async {
    getDeviceId();
    print(deviceId.toString() + 'test device imemi');
    print(fcmToken.toString() + 'test token fcm');
    if (validateEmail() && validatePassword()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      var formData = dio.FormData.fromMap({
        'email': email.value,
        'password': password.value,
        // 'token': fcmToken.isEmpty ? 'test' : fcmToken, // FCM token
        // 'imei': deviceId, // استخدام معرف الجهاز الديناميكي الفريد
        // 'device_type': GetPlatform.isAndroid ? 'android' : 'ios',
      });
      try {
        final response = await apiConsumer.post(
          'login',
          formDataIsEnabled: true,
          formData: formData,
        );

        isLoading.value = false;
        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print("Login successful");
          isGuest.value = false;

          await cacheUserData(apiResponse.data!);
          AppConstants.userData = apiResponse.data!;
          user.value = apiResponse.data!.user;
          userToken = AppConstants.userData!.token;
          clearFields();
          Get.off(MainView());
           // Get.offUntil(LoginView(), (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          errorMessage.value = apiResponse.message ?? "Error Happened";
          HapticFeedback.vibrate();
        }
      } catch (e, stackTrace) {
        isLoading.value = false;
        isGuest.value = false;
        print('Login failed: ${e}');
        // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        // handleApiErrorUser(apiResponse.message);
        errorMessage.value = "Please Check Email and Password and Try Again";
        HapticFeedback.vibrate();
      }
    }
  }

  void forgotPassword() async {


    if (validateEmail()) {
      isLoading.value = true;
      globalController.errorMessage.value = '';
      var formData = dio.FormData.fromMap({
        'email': email.value,

      });
      try {
        await saveStringToPrefs("reset_email", email.value);

        final response = await apiConsumer.post(
          '/password/forget',
          formDataIsEnabled: true,
          formData: formData,
        );

        isLoading.value = false;
        final apiResponse = ApiResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print("sent successful");
          clearFields();
          Get.off(const VerificationCodeView());

        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          // Get.snackbar("Error", apiResponse.message?? "Error Happened");
          errorMessage.value = apiResponse.message ?? "Error Happened";
        }
      } catch (e, stackTrace) {
        isLoading.value = false;
        isGuest.value = false;
        print('Login failed: ${e}');

        // Get.snackbar("Error", e.toString()?? "Error Happened");
        // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        // handleApiErrorUser(apiResponse.message);
        errorMessage.value = "Error Happened Please Try Again";
      }
    }
  }
  Future<void> cacheUserData(UserData data) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = jsonEncode(data.toJson());
    await prefs.setString('user_data', userDataString);
    print('User data cached: $userDataString');
  }


   RxString myPassword = "".obs;

 RxInt passwordStrength = 0.obs;
 Rx<Color> strengthColor = const Color(0xFFBBBBBB).obs;
 RxString passwordDescription = "".obs;
  void checkPasswordStrength(String value) {
    myPassword.value = value.trim();

    if (myPassword.isEmpty) {
      passwordStrength.value = 0;
      passwordDescription.value = "Very Weak";
strengthColor.value =  Color(0xFFB80F28);
    } else if (myPassword.value.length > 5 && myPassword.value.length < 8) {
      passwordStrength.value = 1;

      strengthColor.value =  Color(0xFFF79B00);
      passwordDescription.value = "Weak";
    } else if (myPassword.value.length == 8) {
      passwordStrength.value = 2;
      passwordDescription.value = "Moderate";
      strengthColor.value =  Color(0xFFCBF7B8);
    } else if (myPassword.value.length > 8 && myPassword.contains(RegExp(r'[0-9]')) && myPassword.contains(RegExp(r'[a-zA-Z]'))) {
      passwordStrength.value = 3;
      passwordDescription.value = "Strong";
      strengthColor.value =  Color(0xFF2EB070);
    } else {

    }
  }


  startTimer() async {
    randomTheId();
    tweenId.value = randomId;
    isEnded.value = false;


  }
  endTimer() {
    isEnded.value = true;
  }
  randomTheId() {
    randomId = Random().nextInt(999999);
  }

RxBool isValidOTP = false.obs;
  RxBool isCorrectOTP = false.obs;
  RxBool isTyping = true.obs;
  String otpValue = "";


  validateOTP(otp) {
    isTyping.value = true;
    otpValue = otp;
    if (otp.length == 5) {
      isValidOTP.value = true;
      print("isvalid true");
      // sendOTP(false);
    } else {
      isValidOTP.value = false;
      print("isvalid false");

    }
    // if (otp == "11111") {
    //   Get.to(() => const CreateNewPasswordView());
    // }
  }


  resetPassword() async{
    if(validateConfirmPassword() && validatePassword()){
      isLoading.value = true;
      String? email = await getStringFromPrefs("reset_email");
      String? otp = await getStringFromPrefs("reset_otp");
      var formData = dio.FormData.fromMap({
        'email': email,
        'otp': otp,
        'password': password.value,
        'password_confirmation': confirmPassword.value
      });
      try {
        print("your form data is ${formData.fields}");
        final response = await apiConsumer.post(
          'password/reset',
          formDataIsEnabled: true,
          formData: formData,
        );

        isLoading.value = false;
        final apiResponse = ApiDataResponse.fromJson(response);
        if (apiResponse.status == 'success') {
          print("reset successful");


          clearFields();
          Get.offAll(const PasswordUpdated());
          isLoading.value = false;
          return true;
          // Get.offAll(const CreateNewPasswordView());
          // Get.off(HomeScreen());
          // Get.offUntil(LoginView(), (Route) => false);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          errorMessage.value = apiResponse.message ?? "Error Happened Please Try Again";
          HapticFeedback.vibrate();
          isLoading.value = false;
          return false;
        }
      } catch (e, stackTrace) {
        isLoading.value = false;

        print('otp failed: ${e}');
        // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
        // handleApiErrorUser(apiResponse.message);
        errorMessage.value = "Error Happened Please Try Again";
        HapticFeedback.vibrate();
        isLoading.value = false;
        return false;
      }
      Get.off(const PasswordUpdated());
    }
  }
  Future<dynamic> sendOTP(isFromButton) async {
    isLoading.value = true;
    isTyping.value = false;
    print("isTyping ${isTyping.value}");

    if(await checkOTP()){

      isCorrectOTP.value = true;
      print("correct otp yes");
      if(isFromButton){
        Get.offAll(const CreateNewPasswordView());
      }
      isLoading.value = false;
    } else {
      isCorrectOTP.value = false;
      print("correct otp no");
      isLoading.value = false;
    }





  }

  Future<bool> checkOTP() async{
    String? email = await getStringFromPrefs("reset_email");
    saveStringToPrefs("reset_otp", otpValue);
    var formData = dio.FormData.fromMap({
      'email': email,
      'otp': otpValue,
    });
    try {
      print("your form data is ${formData.fields}");
      final response = await apiConsumer.post(
        'password/verify',
        formDataIsEnabled: true,
        formData: formData,
      );

      isLoading.value = false;
      final apiResponse = ApiDataResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print("otp successful");


        clearFields();
        return true;
        // Get.offAll(const CreateNewPasswordView());
        // Get.off(HomeScreen());
        // Get.offUntil(LoginView(), (Route) => false);
      } else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        errorMessage.value = apiResponse.message ?? "Please Check OTP and Try Again";
        HapticFeedback.vibrate();
        return false;
      }
    } catch (e, stackTrace) {
      isLoading.value = false;

      print('otp failed: ${e}');
      // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
      // handleApiErrorUser(apiResponse.message);
      errorMessage.value = "Please Check OTP and Try Again";
      HapticFeedback.vibrate();
      return false;
    }
  }

  Future<String?> getStringFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveStringToPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> removeStringFromPrefs(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }





}


