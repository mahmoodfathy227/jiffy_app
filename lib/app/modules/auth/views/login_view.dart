
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


import 'package:jiffy/app/modules/auth/views/register_view.dart';
import 'package:jiffy/app/modules/help/views/help_view.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';

import '../../../routes/app_pages.dart';
import '../../global/config/configs.dart';
import '../../global/config/helpers.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import 'forgot_password_view.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  LoginView({super.key}) {
    controller.requestNotificationPermissions();
    controller.initFCMToken();
    controller.getUserType();
  }

  Widget loginbyPasswordView(context) {
    return Obx(() {
      return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height - 300.h,
        child: Column(
          children: [


            ShowUp(
                delay: 400,
                child: CustomTextField(
                  labelText: 'Your Email',
                  onChanged: (value) => controller.email.value = value,
                  errorText:  controller.emailError.value,
                )),
SizedBox(height:25.h ,),

            ShowUp(
                delay: 600,
                child: CustomTextField(

                  labelText: 'Password',
                  onChanged: (value) => controller.password.value = value,
                  errorText: controller.passwordError.value,
                  obscureText: true,
                )),
            SizedBox(height: 15.h),
            SizedBox(
                width: 320.w,
                child: GestureDetector(
                    onTap: () {
                      // Get.toNamed(Routes.FORGOT_PASSWORD);
                      Get.to(() => const ForgotPasswordView());
                    },
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: primaryTextStyle(
                          color: primaryColor,
                          size: 12.sp.round(),
                          weight: FontWeight.w400,
                        ),
                      ),
                    ))),
            SizedBox(height: 60.h),



            SizedBox(height: 5.h,),
            MyDefaultButton(
              errorText: controller.errorMessage.value,
              isloading: controller.isLoading.value,
              btnText: 'Log In',
              onPressed: () => controller.login(),
            ),
            SizedBox(height: 15.h),
            ShowUp(
              delay: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    textAlign: TextAlign.center,
                    style: primaryTextStyle(
                      color: Color(0xFF555662),
                      size: 13.sp.round(),
                      weight: FontWeight.w400,


                    ),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => RegisterView()),
                    child: Text(
                      'Sign up',
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: primaryColor,
                        size: 13.sp.round(),
                        weight: FontWeight.w400,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          Spacer(),
            Text("Sign In With", style: primaryTextStyle(color: Colors.black,
                size: 13.sp.round(),
                weight: FontWeight.w400),),

            SizedBox(height: 10.h,),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 60.w,
              height: 80.h,
              child: Row(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(10),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.grey.withOpacity(0.1),
                  //           spreadRadius: 5,
                  //           blurRadius: 7,
                  //           offset: Offset(0, 3), // changes position of shadow
                  //         ),
                  //       ],
                  //     ),
                  //     child: SizedBox(
                  //       height: 50.h,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/icons/facebook.svg", color: Colors.blue,),
                  //           SizedBox(width: 10.w,),
                  //           Text("Facebook",
                  //             style: primaryTextStyle(color: Colors.black,
                  //                 size: 13.sp.round(), weight: FontWeight.w100
                  //             ),),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: 15.w,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/google.svg"),
                            SizedBox(width: 10.w,),
                            Text("Google", style: primaryTextStyle(
                                color: Colors.black,
                                size: 13.sp.round(),
                                weight: FontWeight.w400),),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )


          ],
        ),
      );
    });
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
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: SafeArea(
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
                        child: Row(

                          children: [
                            SizedBox(width: 10.w,),
                            GestureDetector(
                              onTap: () {
                                Get.to(()=>  MainView());
                              },
                              child: ConstrainedBox(

                                  constraints: BoxConstraints(

                                      maxWidth: 110.w,
                                      maxHeight: 50.h
                                  ),
                                  child: Container(
                                    width: 90.w,
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                        color:   Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0, 1), // changes position of shadow
                                          ),
                                        ]
                                    ),
                                    child: Row(

                                        children: [
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Icon(Icons.home_outlined, color: primaryColor, weight: 21.w, ),
                                          SizedBox(width: 5.w,),
                                          Text("Guest",
                                            style: primaryTextStyle(
                                              weight: FontWeight.w500,
                                              size: 12.sp.round(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),

                                        ]),
                                  )


                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              LOGO,
                              width: 41.w,
                              height: 30.h,
                              fit: BoxFit.cover,
                            ),
SizedBox(width: 90.w,),
                            GestureDetector(
                              onTap: () {
                                Get.to(()=> const HelpView());
                              },
                              child: ConstrainedBox(

                                constraints: BoxConstraints(

                                  maxWidth: 100.w,
                                  maxHeight: 50.h
                                ),
                                child: Container(
                                  width: 80.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                  color:   Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ]
                                  ),
                                  child: Row(

                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/help.svg',
                                        width: 20.w,
                                        height: 20.h,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 5.w,),
                                      Text("Help",
                                        style: secondaryTextStyle(
                                          weight: FontWeight.w500,
                                          size: 12.sp.round(),
                                        ),
                                      )

                                  ]),
                                )


                              ),
                            ),
                            SizedBox(width: 10.w,),
                          ],
                        )),
                    SizedBox(
                      height: kDefaultPadding,
                    ),

                    SizedBox(

                      width: 255.w,
                      height: 120.h,
                      child: Column(
                        children: [
                          Text("Login to", overflow: TextOverflow.ellipsis,
                            style: primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 32.sp.round(),
                                color: primaryColor
                            ),),
                          Text("your account", overflow: TextOverflow.ellipsis,
                            style: primaryTextStyle(
                                weight: FontWeight.w700,
                                size: 32.sp.round(),
                                color: primaryColor
                            ),),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 60.h,
                    ),

                    loginbyPasswordView(context),

                  ],
                )),
          ),
        ));
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome Home", style: primaryTextStyle(),),
      ),
    );
  }
}

