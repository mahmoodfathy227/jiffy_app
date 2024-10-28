import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/config/helpers.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';

import '../../global/widget/widget.dart';
import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
   Get.put(HelpController());
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [

              ShowUp(
                child: Padding(
                  padding: EdgeInsets.only(top: 105.h),
                  // transform: Matrix4.translationValues(0, 105.h, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
SizedBox(height: 70.h,),
                      Stack(
                        children: [
                          Container(
                            width: 190,
                            height: 200,
                            decoration: BoxDecoration(
                              // Set your desired background color
                              borderRadius: BorderRadius.circular(10), // Adjust the corner radius
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.2), // Shadow color and opacity
                                  blurRadius: 40, // Shadow blur radius
                                  offset: Offset(0, 9), // Shadow offset (adjust the Y value for vertical position)
                                ),
                              ],
                            ),
                        // Replace with your image
                          ),


                          BackdropFilter(

                            filter: ImageFilter.blur(
                             

                            ),

                            child: Image.asset('assets/images/help/3d_character_207 1.png'),
                          ),
                        ],
                      ),

                  
                      SizedBox(height: kDefaultPadding * 2,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 3),
                        child: Text("How can we help you today?",
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(
                            size: 28.sp.round(),

                            weight: FontWeight.w500,
                            color: primaryColor

                        ),),
                      ),
                      SizedBox(height: kDefaultPadding,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                        child: Text(
                          "Lorem ipsum can emily and talanted Support Lorem ipsum can emily and talanted",
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(
                              size: 14.sp.round(),
                              weight: FontWeight.w300,
                              color: greyishColor

                          ),),
                      ),
                      SizedBox(height: kDefaultPadding * 3,),
                      Obx(() {
                        return MyDefaultButton(onPressed: () => controller.sendEmail(),
                          isloading: controller.isLoading.value,
                          btnText: "Send a Message",
                        isSecondaryTextStyle: true,
                       borderRadius: 30.sp,
                     btnWidth: 245,
                          height: 60.h,
                          iconPadding: 15,
                          Icon: "assets/images/help/send.svg",

                        );
                      }),
                      SizedBox(height: 10.h,),
                      Obx(() {
                        return MyDefaultButton(onPressed: () => controller.sendEmail(),
                          isloading: controller.isLoading.value,
                          btnText: "Call Us",
                          isSecondaryTextStyle: true,
                          borderRadius: 30.sp,
                          btnWidth: 240,
                          height: 60.h,
                  isPlainBackground: true,
                          iconPadding: 50,
                          Icon: "assets/images/help/call.svg",

                        );
                      }),
                      SizedBox(height: kDefaultPadding * 3,),
                    ],
                  ),
                ),
              ),
              CustomAppBar(
                myFunction: () {},
                svgPath: "assets/images/notification.svg",
                title: 'Help Center',

              ),
            ],
          ),
        )
    );
  }
}
