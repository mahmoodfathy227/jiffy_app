
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
                labelText: 'Email or Phone'.tr,
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
                btnText: 'Send'.tr,
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
                    'Back to login'.tr,
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
                          "Password Updated".tr, overflow: TextOverflow.ellipsis,
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
                            btnText: 'Return to Log in'.tr,
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
