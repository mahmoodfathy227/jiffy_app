
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/app/modules/auth/views/password_updated.dart';


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

class CreateNewPasswordView extends GetView<AuthController> {
  const CreateNewPasswordView({Key? key}) : super(key: key);

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
                labelText: 'Password'.tr,
                onChanged: (value) {
                  controller.password.value = value;
                  controller.checkPasswordStrength(value);
                },
                errorText: controller.passwordError.value,
                obscureText: true,
              )),
          SizedBox(height: 15.h,),




          Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding  ),
            child: Row(
              children:
              List.generate(4, (index) =>
                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      child: Container(
                        height: 7.h,
                        width: 63.w,
                        decoration: BoxDecoration(
                          color: controller.passwordStrength.value >= index
                              ? controller.strengthColor.value
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    );
                  }),),

            ),
          ),
          Obx(() {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:  EdgeInsets.only(right: kDefaultPadding * 2,

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(controller.passwordDescription.value,
                      style: primaryTextStyle(color: primaryColor,
                          size: 12.sp.round(),
                          weight: FontWeight.w400),),
                    controller.passwordDescription.value== "Strong".tr ?
                    ShowUp(
                      delay: 300,
                        child: const Icon(Icons.check_circle,color: Color(0xFF2EB070),))
                        : SizedBox(),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 30.h),

          ShowUp(
            delay: 600,
            child: CustomTextField(
              labelText: 'Confirm Password'.tr,
              onChanged: (value) => controller.confirmPassword.value = value,
              errorText:  controller.confirmPasswordError.value,
              obscureText: true,
            ),
          ),


          SizedBox(height: 40.h),
          ShowUp(
              delay: 800,
              child: MyDefaultButton(
errorText: controller.errorMessage.value,
                isloading: controller.isLoading.value,
                btnText: 'Reset Password'.tr,
                onPressed: () {

                  controller.resetPassword();


                },
              )),
          SizedBox(height: 35.h),
          ShowUp(
            delay: 400,
            child: InkWell(
              onTap: (){
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
                        "Set New Password".tr, overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle(
                            weight: FontWeight.w700,
                            size: 32.sp.round(),
                            color: primaryColor
                        ),),
                    ),
                    SizedBox(height: 10.h,),
                    Text("Must be at least 8 characters".tr,
                      overflow: TextOverflow.ellipsis, style: primaryTextStyle(
                          weight: FontWeight.w100,
                          size: 16.sp.round(),
                          color: Colors.black
                      ),),

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
