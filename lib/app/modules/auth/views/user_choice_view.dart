
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:ecommerceapp/app/modules/main/views/main_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
import '../../global/config/configs.dart';
import '../../global/theme/app_theme.dart';
import '../../global/widget/widget.dart';
import 'forgot_password_view.dart';
import '../controllers/auth_controller.dart';
import 'login_view.dart';

class UserChoiceView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  UserChoiceView({super.key}) {
    controller.requestNotificationPermissions();
    controller.initFCMToken();
  }

  Widget loginbyPasswordView(context) {
    return Column(
      children: [
        ShowUp(
            delay: 200,
            child: SizedBox(
                width: 326.w,
                child:  Text(
                  'Please Choose User Type',
                  textAlign: TextAlign.center,
                  style: boldTextStyle(
                      color: const Color(0xFF090A0A),
                      size: 28.sp.round(),
                      weight: FontWeight.w400),
                ))),

        SizedBox(height: MediaQuery.of(context).size.height * 0.15,),

        InkWell(
            onTap: () async{
//caching
final preferences = await SharedPreferences.getInstance();
preferences.setBool('isUser', true);
            //routing
Get.to(() => LoginView());
            },
            child: buttonSocialMedia(
                icon: 'assets/images/onboarding/person.svg',
                index: 3,
                text: 'Sign in as a User',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

        InkWell(
            onTap: () async{
//caching
              final preferences = await SharedPreferences.getInstance();
              preferences.setBool('isUser', false);
              //routing
              Get.to(() => LoginView());
            },
            child: buttonSocialMedia(
                icon: 'assets/images/onboarding/person.svg',
                index: 3,
                text: 'Sign in as a Dealer',
                color: 0xFFD4B0FF,
                txtColor: 0xFF21034F,
                borderColor: 0xFFD4B0FF)),

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
    return Obx(() {
      return Scaffold(
          appBar: CustomAppBar(
            myFunction: (){},
            function: controller.socialView.value == true ? null : back,
            back: controller.socialView.value == true ? false : true,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: controller.socialView.value ? 60.h : 0,
                ),
                ShowUp(
                    delay: 200,
                    child: SvgPicture.asset(
                      LOGO,
                      width: 124.w,
                      height: 82.h,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: 13.h,
                ),
                // if (!GetPlatform.isIOS)
                loginbyPasswordView(context),
              ],
            )),
          ));
    });
  }
}
