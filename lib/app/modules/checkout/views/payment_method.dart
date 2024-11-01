import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:jiffy/app/modules/checkout/views/completed.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';


class PaymentMethod extends GetView<CheckoutController> {
  const PaymentMethod({super.key,});


  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: Stack(
        children: [
          CustomAppBar(myFunction: () {},
            title: 'Payment',
            svgPath: "assets/images/notification.svg",

          ),
          Padding(
              padding: EdgeInsets.only(top: 160.h, left: 20.w,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 30.w),
                      child: Text(
                        "Select Your Payment ", style: secondaryTextStyle(
                          color: Colors.black,
                          size: 16.sp.round(),
                          weight: FontWeight.w300
                      ),)),
                  SizedBox(height: 20.h,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(

                      children: [
                        Container(

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: primaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: 150.w,
                          height: 45.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/payment/money-4.svg"),
                              SizedBox(width: 5.w,),
                              Text("Cash", style: secondaryTextStyle(),)
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w,),
                        Container(
                          width: 150.w,
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
                                SvgPicture.asset(
                                    "assets/images/payment/card.svg"),
                                SizedBox(width: 5.w,),
                                Text(
                                  "Credit Card", style: secondaryTextStyle(
                                  size: 14.sp.round()
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  _buildProductScroll(),

                ],
              )
          ),
        ],
      ),

      bottomSheet: Container(

        height: 250.h,

        decoration: BoxDecoration(

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),

          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 7,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            return
              controller.isLoading.value?
              Center(child: CircularProgressIndicator(color: primaryColor,))
              :
              Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 30.h,),
                Expanded(
                  flex: 2,
                  child: Column(

                    children: [
                      Row(
                        children: [
                          Text(
                            "Subtotal:",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$ ${controller.subTotal.value.toString()}",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            "Shipping:",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                          Spacer(),
                          Text(
                           "\$ ${controller.shipping.value.toString()}",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            "Total:",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                          Spacer(),
                          Text(
                           "\$ ${controller.total.value.toString()}",
                            style: secondaryTextStyle(
                                size: 14.sp.round(),
                                weight: FontWeight.w400
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                Expanded(
                  flex: 2,
                  child: buildFloatingButton(
                    buttonName: 'Confirm Order',
                    isLoading: controller.isConfirmingOrder.value,
                    context: context,
                    onPressed: () {
                      print("pressed");
                    controller.confirmOrder();
                    },
                  ),),

                SizedBox(height: 20.h,),
              ],
            );
          }),
        ),
      ),
      // floatingActionButton: buildFloatingButton(
      //
      //
      //   buttonName: 'Confirm Order',
      //
      //   context: context,
      //   onPressed: () {
      //     print("pressed");
      //     Get.to(const Completed());
      //   },
      //
      // ),


      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  _buildProductScroll() {
    return Obx(() {
      return SizedBox(
        height: 320.h,
        child: controller.cartProducts.isEmpty ? Center(child:

        Text("Cart is empty", style: secondaryTextStyle(),),)
            :
        controller.isLoading.value ? Center(child: CircularProgressIndicator(color: primaryColor,)) :

        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _buildSingleProduct(context, index);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10.h,);
            },
            itemCount: controller.cartProducts.length
        ),
      );
    });
  }

  _buildSingleProduct(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.only(right: 20.w, left: 10.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: MediaQuery
            .of(context)
            .size
            .width - 40.w,
        height: 125.h,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 88.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(
                          0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CachedNetworkImage(
placeholder: (ctx, v) {
  return Image.asset("assets/images/placeholder.png", fit: BoxFit.fill,);
},
                    errorWidget: (ctx, v, w) {
                      return Image.asset("assets/images/placeholder.png", fit: BoxFit.fill,);
                    },
                      fit: BoxFit.fill,
                      imageUrl: controller.cartProducts[index].product!.image!,),
                ),

              ),
              SizedBox(width: 15.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text(controller.cartProducts[index].product!.name!,
                    style: secondaryTextStyle(
                        weight: FontWeight.w500,
                        color: const Color(0xff20003D), size: 20.sp.round()),),
                  SizedBox(
                    width: 200.w,
                    child: Row(
                      children: [
                        Text("300 gm",
                          style: secondaryTextStyle(color: greyishColor,
                              size: 14.sp.round(),
                              weight: FontWeight.w400

                          ),),
                        Spacer(),
                        Text("qty : ${controller.cartProducts[index].quantity}",
                          style: secondaryTextStyle(color: primaryColor,
                              weight: FontWeight.w700,
                              size: 12.sp.round()
                          ),),
                      ],
                    ),
                  ),
                  Text("\$ ${controller.cartProducts[index].product!.price.toString()}",
                    style: secondaryTextStyle(color: primaryColor,
                        weight: FontWeight.w700,
                        size: 16.sp.round()
                    ),),

                ],
              )
            ]
        ));
  }


}
