import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/config/configs.dart';
import '../../global/model/test_model_response.dart';
import '../../global/theme/app_theme.dart';
import '../../global/widget/widget.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (WishlistController().initialized) {
      print("true done yes");
    } else {
      print("true done no");

      Get.lazyPut<WishlistController>(() => WishlistController());
      controller.getWishlistProducts();
    }
    print(
        "starting wishlist view with a list of ${controller.resultSearchProducts.length}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: controller.isAuth.value
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Stack(children: [
                      CustomAppBar(

                        title: "WishList", myFunction: () {  },
                      ),
                      Positioned(
                          top: 150.h,
                          left: 0,
                          right: 0,
                          child: SingleChildScrollView(
                            key: const PageStorageKey<String>("pageThree"),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height - 100.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Obx(() {
                                    print(
                                        "loading value is ${controller.isWishlistLoading}");
                                    return controller.isWishlistLoading.value
                                        ? Expanded(
                                            child: loadingIndicatorWidget())
                                        : Expanded(
                                            child: ShowUp(
                                              child: buildProductGrid(context),
                                              delay: 400,
                                            ),
                                          );
                                  }),
                                ],
                              ),
                            ),
                          )),
                    ]))
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Stack(children: [
                      // CustomAppBar(
                      //   title: "WishList", myFunction: () {  },
                      // ),
                      Align(
                          alignment: Alignment.center,
                          child: socialMediaPlaceHolder()),
                    ]))));
  }

  buildProductGrid(context) {
    print("product grid are ${controller.resultSearchProducts}");

    return Obx(() {
      return Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          child: controller.resultSearchProducts.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Sorry , No Products Found",
                    style: primaryTextStyle(
                        size: 20.sp.round(),
                        color: Colors.black,
                        weight: FontWeight.w400),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height *
                              heightDevidedRatio),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 5.w),
                  itemBuilder: (context, index) {
                    return buildProductCard(
                      product:
                          // ViewProductData.fromJson(
                          //     controller.resultSearchProducts[index])
                          controller.resultSearchProducts[index],
                      isInWishlist: true,
                    );
                  },
                  itemCount: controller.resultSearchProducts.length,
                ));
    });
  }
}
