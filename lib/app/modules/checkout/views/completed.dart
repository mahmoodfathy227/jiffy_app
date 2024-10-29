
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/add_address.dart';
import 'package:jiffy/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';

import '../../global/config/helpers.dart';



class Completed extends GetView<CheckoutController> {
  const Completed({super.key,  bool isFromCheckout = false});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'Completed',
            svgPath: "assets/images/notification.svg",

          ),
          Padding(
              padding:  EdgeInsets.only(top: 160.h , ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
Image.asset("assets/images/payment/completed.gif",height: 400.h,width: 400.w,),
                  Text("Thank you", style: primaryTextStyle(color: Color(0xFF10AE48),
                  weight: FontWeight.w900,
                    size: 24.sp.round()

                  ),),
                  Text("You can view your order in ‘My Orders’ section.", style:
                  primaryTextStyle(color: Colors.grey,
                  size: 12.sp.round()
                  ) )
                ],
              )
          ),
        ],
      ),

      floatingActionButton: buildFloatingButton(


        buttonName: 'Continue Shopping',
isPlainBackground: true,
        context: context,
        onPressed: () {
Get.offAll(MainView());
          print("pressed");

        },

      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }



}
