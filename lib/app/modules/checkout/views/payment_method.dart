
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/model/address_model.dart';
import 'package:jiffy/app/modules/address/views/add_address.dart';
import 'package:jiffy/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:jiffy/app/modules/checkout/views/completed.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';

import '../../global/config/helpers.dart';



class PaymentMethod extends GetView<CheckoutController> {
  const PaymentMethod({super.key,  bool isFromCheckout = false});
  final bool isFromCheckout = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'Payment',
            svgPath: "assets/images/notification.svg",

          ),
          Padding(
            padding:  EdgeInsets.only(top: 160.h , left: 20.w,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text("Select Your Payment ", style: secondaryTextStyle(
                      color: Colors.black,
                      size: 16.sp.round(),
                      weight: FontWeight.w300
                    ),)),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Row(

                    children: [
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: primaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 140.w,
                        height: 45.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/payment/money-4.svg"),
                            SizedBox(width: 5.w,),
                            Text("Cash" , style: secondaryTextStyle(),)
                          ],
                        ),
                      ),
                      SizedBox(width: 20.w,),
                      Container(
                        width: 140.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 5,
                          //     blurRadius: 7,
                          //     offset: const Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/payment/card.svg"),
                              SizedBox(width: 5.w,),
                              Text("Credit Card" , style: secondaryTextStyle(),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        ],
      ),

      floatingActionButton: buildFloatingButton(


        buttonName: 'Confirm Order'  ,

        context: context,
        onPressed: () {

          print("pressed");
          Get.to(const Completed());
        },

      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }



}
