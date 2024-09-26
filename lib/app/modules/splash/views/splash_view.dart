import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // لون الخلفية الأرجواني
      body: GestureDetector(
        onTap: () {
          // إعادة تشغيل الأنيميشن عند النقر
          splashController.animationController!.reset();
          splashController.animationController!.forward();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // الشعار مع أنيميشن Fade In + Scale
              FadeTransition(
                opacity: splashController.fadeAnimation!,
                child: ScaleTransition(
                  scale: splashController.scaleAnimation!,
                  child: SvgPicture.asset('assets/images/splash/logo.svg',
                      width: 90.w), // الشعار
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
