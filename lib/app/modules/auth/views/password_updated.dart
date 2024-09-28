
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


// import 'package:ecommerceapp/app/modules/main/views/main_view.dart';

import 'package:jiffy/app/modules/auth/views/register_view.dart';
import '../../../routes/app_pages.dart';
import '../../global/config/configs.dart';
import '../../global/config/helpers.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import 'forgot_password_view.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class PasswordUpdated extends GetView<AuthController> {
  const PasswordUpdated({Key? key}) : super(key: key);

  Widget loginbyPasswordView(context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height - 300.h,
      child: Column(
        children: [


          ShowUp(
              delay: 600,
              child: CustomTextField(
                labelText: 'Email or Phone',
                onChanged: (value) {
                  controller.email.value = value;
                },
                errorText: controller.emailError.value ,
                obscureText: false,
              )),


          SizedBox(height: 80.h),
          ShowUp(
              delay: 800,
              child: MyDefaultButton(
                isloading: controller.isLoading.value,
                btnText: 'Send',
                onPressed: () => controller.forgotPassword(),
              )),
          SizedBox(height: 35.h),
          ShowUp(
            delay: 400,
            child: GestureDetector(
              onTap: () {
                Get.off(LoginView());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      "assets/images/forgot_password/arrow-left.svg"),
                  SizedBox(width: 5.w,),
                  Text(
                    'Back to login',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: const Color(0xFF555662),
                      size: 15.sp.round(),
                      weight: FontWeight.w700,


                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 35.h),


        ],
      ),
    );
  }

  Widget socialMediaView() {
    return Column(
      children: [
        ShowUp(
            delay: 400,
            child: Text(
              'Welcome to Marianella',
              textAlign: TextAlign.center,
              style: boldTextStyle(
                  color: const Color(0xFF090A0A),
                  size: 32.sp.round(),
                  weight: FontWeight.w400),
            )),
        Text(
          'Please log in or sign up to continue shopping',
          textAlign: TextAlign.center,
          style: secondaryTextStyle(
            color: const Color(0xFFCDCFD0),
            size: 16.sp.round(),
            weight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        // if (!GetPlatform.isIOS)
        InkWell(
            onTap: () {
              print('dsadsa');
              controller.googleLogin();
            },
            child: buttonSocialMedia(
                icon: 'assets/icons/google.svg',
                index: 0,
                text: 'Continue with Google',
                color: 0xffFFFFFF,
                txtColor: 0xFF090A0A,
                borderColor: 0xFFE3E4E5)),

        if (GetPlatform.isIOS)
          SizedBox(
            height: 16.h,
          ),
        if (GetPlatform.isIOS)
          InkWell(
              onTap: () {
                print('dsadsa');
                controller.appleLogin();
              },
              child: buttonSocialMedia(
                  icon: 'assets/icons/apple.svg',
                  index: 2,
                  text: 'Continue with Apple',
                  color: 0xFF090A0A,
                  txtColor: 0xffFFFFFF,
                  borderColor: 0xFFE3E4E5)),
        SizedBox(
          height: 35.h,
        ),
        DividerSocial(),
        SizedBox(
          height: 34.h,
        ),
        InkWell(
            onTap: () {
              controller.socialView.value = false;
              controller.password.value = '';
              controller.email.value = '';
            },
            child: buttonSocialMedia(
                icon: 'assets/icons/login.svg',
                index: 3,
                text: 'Sign in with password',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),
        SizedBox(
          height: 34.h,
        ),
        InkWell(
            onTap: () {
              controller.isGuest.value = true;
              Get.snackbar('Guest Mode', 'You\'re Acting As A Guest');
              // Get.to(MainView());
              Get.offNamedUntil(Routes.MAIN, (Route) => false);
            },
            child: buttonSocialMedia(
                icon: 'assets/images/onboarding/person.svg',
                index: 3,
                text: 'Sign in As a Guest',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),
        SizedBox(
          height: 26.h,
        ),
        ShowUp(
            delay: 500,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Don’t have an account?',
                    style: primaryTextStyle(
                      color: const Color(0xFFCDCFD0),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: primaryTextStyle(
                      color: const Color(0xFF979C9E),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign up',
                    style: primaryTextStyle(
                      color: const Color(0xFFAA61FF),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.clearFields();
                        Get.to(() => RegisterView());
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  void back() {
    controller.socialView.value = true;

    controller.password.value = '';
    controller.email.value = '';
  }

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: Obx(() {
          return SafeArea(
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      ShowUp(
                          delay: 200,
                          child: SvgPicture.asset(
                            LOGO,
                            width: 40.w,
                            height: 30.h,
                            fit: BoxFit.cover,
                          )),

                      SizedBox(
                        height: MediaQuery.of(context).size.height/3,
                      ),
SvgPicture.asset("assets/images/forgot_password/check.svg"),

                      SizedBox(height: 15.h,),
                      SizedBox(


                        child: Text(
                          "Password Updated", overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                              weight: FontWeight.w700,
                              size: 19.sp.round(),
                              color: primaryColor
                          ),),
                      ),
                        SizedBox(height: 15.h,),
                      ShowUp(
                          delay: 800,
                          child: MyDefaultButton(
                            isloading: controller.isLoading.value,
                            btnText: 'Return to Log in ',
                            onPressed: () {
                              Get.offAllNamed(Routes.LOGIN);
                            },
                          )),
                      // loginbyPasswordView(context),

                    ],
                  )),
            ),
          );
        }));
  }
}
