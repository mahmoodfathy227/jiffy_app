import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../global/config/configs.dart';
import '../../global/model/test_model_response.dart';
import '../../global/theme/app_theme.dart';
import '../../global/widget/widget.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.resultSearchProducts.clear();
    controller.getWishlistProducts();


    print(
        "starting wishlist view with a list of ${controller.resultSearchProducts
            .length}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:

        userToken == null ?
        SizedBox(
            height: MediaQuery
                .sizeOf(context)
                .height,
            width: MediaQuery
                .sizeOf(context)
                .width,
            child: Stack(children: [

              Align(
                  alignment: Alignment.center,
                  child: socialMediaPlaceHolder()),
            ]))

            :
        SizedBox(
            height: MediaQuery
                .sizeOf(context)
                .height,
            width: MediaQuery
                .sizeOf(context)
                .width,
            child: Stack(children: [
              CustomAppBar(
                back: false,
                title: "WishList".tr, myFunction: () {},

              ),
              Positioned(
                  top: 150.h,
                  left: 0,
                  right: 0,
                  child: SingleChildScrollView(

                    child: Container(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height - 100.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Obx(() {

                            return controller.isWishlistLoading.value
                                ? Expanded(
                                child: loadingIndicatorWidget())
                                : Expanded(
                              child: Transform.translate(
                                offset: Offset(0, -10.h),
                                child: ShowUp(
                                  child: buildProductGrid(context),
                                  delay: 400,
                                ),
                              ),
                            );
                          }),

                          SizedBox(height: 100.h)
                        ],
                      ),
                    ),
                  )),
            ]))
    );
  }

  buildProductGrid(context) {

    return Obx(() {
      return Container(
          padding:  EdgeInsets.only(left: 25.w),
          width: MediaQuery
              .of(context)
              .size
              .width,
          child:
          controller.resultSearchProducts.isEmpty
              ? Align(
            alignment: Alignment.center,
            child: Text(
              "Sorry , No Products Found".tr,
              style: primaryTextStyle(
                  size: 20.sp.round(),
                  color: Colors.black,
                  weight: FontWeight.w400),
            ),
          )
              :
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery
                    .of(context)
                    .size
                    .width /
                    (MediaQuery
                        .of(context)
                        .size
                        .height *
                        heightDevidedRatio *1.1),
                crossAxisCount: 2,
                mainAxisSpacing: 1.h,
                crossAxisSpacing: 1.w),
            itemBuilder: (context, index) {
              return
                productCard(controller.resultSearchProducts[index], context, index);


            },
            itemCount: controller.resultSearchProducts.length,
          )
      );

    });
  }
}
