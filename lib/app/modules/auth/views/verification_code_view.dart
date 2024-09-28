import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/app/modules/auth/views/login_view.dart';

import 'package:pinput/pinput.dart';

import '../../global/config/configs.dart';
import '../../global/config/helpers.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';
import '../../global/widget/widget.dart';
import '../controllers/auth_controller.dart';

class VerificationCodeView extends GetView<AuthController> {
  const VerificationCodeView({Key? key}) : super(key: key);

  Widget buildCodePinView(context) {
    final defaultPinTheme = PinTheme(
      width: 55.w,
      height: 60.h,
      textStyle: primaryTextStyle(
          color: primaryColor
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffA5A7AC)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = PinTheme(
      width: 55.w,
      height: 60.h,
      textStyle: primaryTextStyle(color: primaryColor),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffA5A7AC)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final submittedPinTheme = PinTheme(
      width: 55.w,
      height: 60.h,
      textStyle: primaryTextStyle(color: primaryColor),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffA5A7AC)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final errorPinTheme = PinTheme(
      width: 55.w,
      height: 60.h,
      textStyle: primaryTextStyle(color: Colors.red),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Obx(() {
      return SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height - 300.h,
        child: Column(
          children: [


            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Pinput(
                  length: 5,
                  defaultPinTheme:  !controller.isTyping.value && !controller.isCorrectOTP.value
                      ? errorPinTheme : defaultPinTheme,
                  focusedPinTheme: !controller.isTyping.value && !controller.isCorrectOTP.value
                      ? errorPinTheme : focusedPinTheme,
                  submittedPinTheme: !controller.isTyping.value && !controller.isCorrectOTP.value
                      ? errorPinTheme: submittedPinTheme,
                  // errorPinTheme: errorPinTheme ,
                  // errorPinTheme: !controller.isTyping.value
                  //     ? errorPinTheme
                  //     : submittedPinTheme,
                  onChanged: (value) => controller.validateOTP(value),
                  // validator: (value) => controller.isCorrectOTP.value ? null : 'Pin is incorrect',

                  // validator: (value) =>
                  // controller.isCorrectOTP.value ? null :
                  // controller.isTyping.value?
                  // 'Pin is incorrect' :
                  // null,
                  // pinputAutovalidateMode: PinputAutovalidateMode.disabled,

                  showCursor: true,
                  onCompleted: (pin) => print("your pin ${pin}"),
                )),
            !controller.isTyping.value && !controller.isCorrectOTP.value?
            SizedBox(height: 10.h,)
            :
                const SizedBox()
            ,
            !controller.isTyping.value && !controller.isCorrectOTP.value?
            Padding(
              padding:  EdgeInsets.only(left: kDefaultPadding * 2.7),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Pin is incorrect", style: primaryTextStyle(
                    color: Colors.red,
                  weight: FontWeight.w300,
                  size: 15.sp.round(),
                ),),
              ),
            )
            :
                SizedBox()
            ,
            SizedBox(height: 29.h),

            Obx(() {
              return ShowUp(
                  delay: 800,
                  child: MyDefaultButton(
                    errorText: controller.errorMessage.value,
                    isloading: controller.isLoading.value,
                    btnText: 'Send',
                    isActive: controller.isValidOTP.value,


                    onPressed: () {
                      if (controller.isValidOTP.value) {
                        controller.sendOTP(true);
                      }
                    },
                  ));
            }),

            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Obx(
                        () =>
                        Column(
                          children: [
                            TweenAnimationBuilder<Duration>(
                                key: ValueKey(controller.tweenId.value),
                                duration: const Duration(minutes: 1),
                                tween: Tween(
                                    begin: const Duration(minutes: 1),
                                    end: Duration.zero),
                                onEnd: () {
                                  controller.endTimer();
                                  print('Timer ended');
                                },
                                builder: (BuildContext context, Duration value,
                                    Widget? child) {
                                  final minutes = value.inMinutes;
                                  final seconds = value.inSeconds % 60;
                                  return Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                      child:
                                      controller.isEnded.value

                                          ?
                                      SizedBox()
                                          : Text(
                                          '$minutes:$seconds',
                                          textAlign: TextAlign.center,
                                          style: primaryTextStyle(
                                              color: primaryColor,
                                              weight: FontWeight.w300
                                          )));
                                }),
                          ],
                        ),
                  )),
            ),
            Obx(() {
              return ShowUp(
                  delay: 450,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Didn’t get a code?',
                          style: primaryTextStyle(
                            color: const Color(0xFFCDCFD0),
                            size: 14.sp.round(),
                            weight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: primaryTextStyle(
                            color: const Color(0xFF979C9E),
                            size: 14.sp.round(),
                            weight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Click to resend',
                          style: primaryTextStyle(
                            color: !controller.isEnded.value ? const Color(
                                0xFF979C9E) : const Color(0xFFAA61FF),
                            size: 13.sp.round(),
                            weight: FontWeight.w400,
                            decoration: !controller.isEnded.value
                                ? TextDecoration
                                .none
                                : TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (controller.isEnded.value) {
                                controller.clearFields();
                                controller.startTimer();
                                controller.forgotPassword();
                              }
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ));
            }),
            SizedBox(height: 35.h),
            ShowUp(
              delay: 400,
              child: InkWell(
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
    });
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
                        child: SvgPicture.asset(
                          LOGO,
                          width: 40.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(
                      height: kDefaultPadding,
                    ),

                    SizedBox(


                      child: Text(
                        "Code Verification", overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle(
                            weight: FontWeight.w700,
                            size: 32.sp.round(),
                            color: primaryColor
                        ),),
                    ),
                    SizedBox(height: 10.h,),
                    Text("We've sent the code to the email \n on your device",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis, style: primaryTextStyle(
                          weight: FontWeight.w100,
                          size: 16.sp.round(),
                          color: Colors.black
                      ),),

                    SizedBox(
                      height: 60.h,
                    ),

                    buildCodePinView(context),

                  ],
                )),
          ),
        ));
  }


}
//end timer


////Tween + Timer //


