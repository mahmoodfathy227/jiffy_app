import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/builtInPackage/like_button-2.0.5/lib/like_button.dart';
import 'package:jiffy/app/modules/auth/views/register_view.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/config/constant.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/main/controllers/tab_controller.dart';
import 'package:jiffy/app/modules/product/controllers/product_controller.dart';
import 'package:jiffy/app/modules/product/views/product_view.dart';
import 'package:jiffy/app/modules/search/views/search_view.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:jiffy/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:jiffy/main.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../auth/views/login_view.dart';
import '../controllers/home_controller.dart';
import 'dart:math' as math;

class HomeView extends StatelessWidget {
  // Inject HomeController using GetX
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController =
   Get.put(CartController());
  final WishlistController wishListController = Get.put(WishlistController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F3FF),
        body: SingleChildScrollView(
            child: Column(

                mainAxisSize: MainAxisSize.min,
                children: [
                  //build App Bar
                  SizedBox(

                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 420.h,
                    child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SemiLunarScrollView(),
                          SvgPicture.asset(
                            'assets/images/home/circular.svg',
                            fit: BoxFit.fill,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,

                          ).animate().slideX(
                              duration: const Duration(milliseconds: 300)
                          ).fadeIn(),

                          Padding(
                            padding: EdgeInsets.only(top: 50.h),
                            child: SearchHomeBar(
homeController: homeController,
                              context: context,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 250.h),
                            child: SemiLunarScrollView().animate().slideY(
                                duration: const Duration(milliseconds: 500)
                            ).fadeIn(),),


                          // Slide-down animation using GetX controlled animations
//                         PositionedDirectional(
//                           start: -127.w,
//                           top: -290.h,
//                           child: Container(
//
//                             width: 644.w,
//                             height: 663.h,
//                             child: Stack(
//                               children: [
//                               Positioned(
//                               left: 15.w,
//                               top: 0,
//                               child: Obx(() {
//                                 // This widget will now reactively listen to changes in rotationAngleCircule
//                                 return Transform.rotate(
//                                   angle: homeController
//                                       .rotationAngleCircule
//                                       .value,
//                                   // Controlled by HomeController
//                                   child: RotationTransition(
//                                     turns: Tween(begin: 0.0, end: 1.0)
//                                         .animate(homeController
//                                         .rotatingUpperBarController),
//
//                                     child: SvgPicture.asset(
//                                       'assets/images/home/circule.svg',
//                                       fit: BoxFit.contain,
//
//                                       width: 645.w,
//                                       height: 598.h,
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             ),
//                                 // ListView with Rotation
//                                 Positioned.fill(
//                                   child: Column(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.end,
//                                     children: [
//                                       SemiLunarScrollView(),
//                                       // Add dots indicator below categories
//                                       buildDots(homeController),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // child: SlideTransition(
//                           //     position: homeController.slideAnimation,
//                           //     child: FadeTransition(
//                           //       opacity: homeController
//                           //           .fadeInAnimation, // GetX Fade-In
//                           //       child: Container(
//                           //         width: 644.w,
//                           //         height: 663.h,
//                           //         child: Stack(
//                           //           children: [
//                           //             Positioned(
//                           //               left: 15.w,
//                           //               top: 0,
//                           //               child: Obx(() {
//                           //                 // This widget will now reactively listen to changes in rotationAngleCircule
//                           //                 return Transform.rotate(
//                           //                   angle: homeController
//                           //                       .rotationAngleCircule
//                           //                       .value,
//                           //                   // Controlled by HomeController
//                           //                   child: SvgPicture.asset(
//                           //                     'assets/images/home/circule.svg',
//                           //                     fit: BoxFit.contain,
//                           //                     width: 645.w,
//                           //                     height: 598.h,
//                           //                   ),
//                           //                 );
//                           //               }),
//                           //             ),
//                           //             // ListView with Rotation
//                           //             Positioned.fill(
//                           //               child: Column(
//                           //                 mainAxisAlignment:
//                           //                 MainAxisAlignment.end,
//                           //                 children: [
//                           //                   SizedBox(
//                           //                     height: 150
//                           //                         .h,
//                           //                     // Adjust height if needed
//                           //                     width: MediaQuery
//                           //                         .of(context)
//                           //                         .size
//                           //                         .width +
//                           //                         85.w,
//                           //                     child: PageView.builder(
//                           //                       onPageChanged: (
//                           //                           int pageIndex) {
//                           //                         homeController
//                           //                             .onPageChanged(
//                           //                             pageIndex); // GetX Page change handler
//                           //                       },
//                           //                       controller: homeController
//                           //                           .pageController.value,
//                           //                       itemCount: (homeController
//                           //                           .categories.length /
//                           //                           4)
//                           //                           .ceil(),
//                           //                       // Number of pages
//                           //                       itemBuilder:
//                           //                           (context, pageIndex) {
//                           //                         int startIndex = pageIndex *
//                           //                             4;
//                           //                         int endIndex =
//                           //                         (startIndex + 4) >
//                           //                             homeController
//                           //                                 .categories
//                           //                                 .length
//                           //                             ? homeController
//                           //                             .categories.length
//                           //                             : startIndex + 4;
//                           //                         List<
//                           //                             String> currentCategories =
//                           //                         homeController.categories
//                           //                             .sublist(startIndex,
//                           //                             endIndex);
//                           //
//                           //                         return Center(
//                           //                           child: Padding(
//                           //                             padding: EdgeInsets
//                           //                                 .only(
//                           //                                 top: 0.h),
//                           //                             child: SizedBox(
//                           //                               height: 300
//                           //                                   .h,
//                           //                               // Adjust to fit your curve
//                           //                               child: ListView
//                           //                                   .builder(
//                           //                                 controller:
//                           //                                 homeController
//                           //                                     .scrollController
//                           //                                 ,
//                           //
//                           //                                 scrollDirection:
//                           //                                 Axis.horizontal,
//                           //
//                           //                                 // physics:
//                           //                                 // const NeverScrollableScrollPhysics(),
//                           //                                 itemCount:
//                           //                                 currentCategories
//                           //                                     .length,
//                           //                                 itemBuilder: (
//                           //                                     context,
//                           //                                     indexList) {
//                           //                                   // Adjust vertical offset based on index to create the curved effect
//                           //                                   double verticalShift =
//                           //                                   homeController
//                           //                                       .calculateVerticalShift(
//                           //                                       indexList,
//                           //                                       currentCategories
//                           //                                           .length);
//                           //                                   return Padding(
//                           //                                     padding: EdgeInsets
//                           //                                         .symmetric(
//                           //                                       horizontal: 34
//                           //                                           .w /
//                           //                                           2, // Horizontal spacing
//                           //                                     ),
//                           //                                     child: Transform
//                           //                                         .translate(
//                           //                                       offset: Offset(
//                           //                                           0,
//                           //                                           verticalShift),
//                           //                                       child: Column(
//                           //                                         children: [
//                           //                                           buildCategoryItem(
//                           //                                             currentCategories[
//                           //                                             indexList],
//                           //                                             Icons
//                           //                                                 .category,
//                           //                                           ),
//                           //                                         ],
//                           //                                       ),
//                           //                                     ),
//                           //                                   );
//                           //                                 },
//                           //                               ),
//                           //                             ),
//                           //                           ),
//                           //                         );
//                           //                       },
//                           //                     ),
//                           //                   ),
//                           //                   // Add dots indicator below categories
//                           //                   buildDots(homeController),
//                           //                 ],
//                           //               ),
//                           //             ),
//                           //           ],
//                           //         ),
//                           //       ),
//                           //     ))
//                         ),
//
//                         // Add Search bar with Slide and Fade animation
//                         Positioned(
//                             top: 36.h,
//                             left: 0,
//                             right: 0,
//                             child: ShowUp(
//                               delay: 300,
//                               child: SearchHomeBar(
//                                   homeController: homeController),
//                             )),
// // body of home
//                         PositionedDirectional(
//                             top: 400.h,
//                             child: Column(
//                               children: [
//                                 // Obx(() =>
//                                 //     SlideTransition(
//                                 //         position: Tween<Offset>(
//                                 //           begin: const Offset(1.0,
//                                 //               0.0),
//                                 //           // يبدأ خارج الشاشة على اليمين (x = 1)
//                                 //           end: const Offset(0.0,
//                                 //               0.0), // ينتهي في موقعه الطبيعي (x = 0)
//                                 //         ).animate(
//                                 //           CurvedAnimation(
//                                 //             parent: homeController.controller,
//                                 //             curve: Curves.easeInOut,
//                                 //           ),
//                                 //         ),
//                                 //         child: viewProductSection(
//                                 //             'Latest Product',
//                                 //             homeController
//                                 //                 .homePageData.value
//                                 //                 .latestProducts,
//                                 //             context))),
//                                 Obx(() {
//                                   return ShowUp(
//                                     delay: 500,
//                                     child: viewProductSection(
//                                         'Latest Product',
//                                         homeController
//                                             .homePageData.value
//                                             .latestProducts,
//                                         context),
//                                   );
//                                 })
//                               ],
//                             )),
//                       ],
                        ]),
                  ),
                  buildDots(homeController),
                  SizedBox(height: 10.h,),
                  // build Feature Products
                  Obx(() {
                    return viewProductSection(
                        'Featured Product'.tr,
                        homeController.homePageData.value
                            .featuredProducts,
                        context);
                  }),

                  Obx(() {
                    return BannerAd();
                  }),
                  SizedBox(
                    height: 9.h,
                  ),
                  // Obx(() =>
                  //     SlideTransition(
                  //         position: Tween<Offset>(
                  //           begin: const Offset(
                  //               1.0, 0.0),
                  //           // يبدأ خارج الشاشة على اليمين (x = 1)
                  //           end: const Offset(
                  //               0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                  //         ).animate(
                  //           CurvedAnimation(
                  //             parent: homeController.controller,
                  //             curve: Curves.easeInOut,
                  //           ),
                  //         ),
                  //         child: viewProductSection(
                  //             'Featured Product',
                  //             homeController.homePageData.value
                  //                 .featuredProducts,
                  //             context))),
                  Obx(() {
                    return viewProductSection(
                        'Best Selling Product'.tr,
                        homeController.homePageData.value
                            .featuredProducts,
                        context);
                  }),
                  SizedBox(
                    height: 9.h,
                  ),

                  // SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: const Offset(
                  //           1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                  //       end: const Offset(
                  //           0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                  //     ).animate(
                  //       CurvedAnimation(
                  //         parent: homeController.controller,
                  //         curve: Curves.easeInOut,
                  //       ),
                  //     ),
                  //     child: Obx(() {
                  //       return BannerAd2();
                  //     })),

                  Obx(() {
                    return BannerAd2();
                  }),
                  SizedBox(
                    height: 9.h,
                  ),
                  // SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: const Offset(
                  //           1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                  //       end: const Offset(
                  //           0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                  //     ).animate(
                  //       CurvedAnimation(
                  //         parent: homeController.controller,
                  //         curve: Curves.easeInOut,
                  //       ),
                  //     ),
                  //     child: premiumProduct(context)),
                  premiumProduct(context),
                  SizedBox(
                    height: 35.h,
                  ),
                  // SlideTransition(
                  //     position: Tween<Offset>(
                  //       begin: const Offset(
                  //           1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                  //       end: const Offset(
                  //           0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                  //     ).animate(
                  //       CurvedAnimation(
                  //         parent: homeController.controller,
                  //         curve: Curves.easeInOut,
                  //       ),
                  //     ),
                  //     child: Obx(() {
                  //       return newArrives();
                  //     })),
                  Obx(() {
                    return newArrives();
                  }),
                  SizedBox(
                    height: 29.h,
                  ),
                  // Obx(() =>
                  //     SlideTransition(
                  //         position: Tween<Offset>(
                  //           begin: const Offset(
                  //               1.0, 0.0),
                  //           // يبدأ خارج الشاشة على اليمين (x = 1)
                  //           end: const Offset(
                  //               0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                  //         ).animate(
                  //           CurvedAnimation(
                  //             parent: homeController.controller,
                  //             curve: Curves.easeInOut,
                  //           ),
                  //         ),
                  //         child: viewProductSection(
                  //             'Perfumes',
                  //             homeController.homePageData.value
                  //                 .featuredProducts,
                  //             context))),
                  Obx(() {
                    return viewProductSection(
                        'Perfumes'.tr,
                        homeController.homePageData.value
                            .featuredProducts,
                        context);
                  }),

                ])));
  }

  Widget BannerAd() {
    return

      homeController.homePageData.value.banners == null
          ?
      Image.asset(
        'assets/images/home/banner1.png',
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
      )
          :
      homeController.homePageData.value.banners!.isEmpty ?
      Image.asset(
        'assets/images/home/banner1.png',
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
      )
          :
      Transform.translate(
        offset: const Offset(0, 10),
        child: CachedNetworkImage(
          imageUrl: homeController.homePageData.value.banners![0].image!,
          width: 375.w,
          height: 193.h,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) =>
              Image.asset(
                'assets/images/home/banner1.png',
                width: 375.w,
                height: 193.h,
                fit: BoxFit.cover,
              ),
          placeholder: (context, url) =>
              Lottie.asset(
                  "assets/images/jiffy_placeholder.json"
              ),
        ),
      );
  }

  Widget BannerAd2() {
    return

      homeController.homePageData.value.banners == null
          ?
      Image.asset(
        'assets/images/home/banner1.png',
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
      )
          :
      homeController.homePageData.value.banners!.length < 2 ?
      Image.asset(
        'assets/images/home/banner1.png',
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
      )
          :
      CachedNetworkImage(
        imageUrl: homeController.homePageData.value.banners![1].image!,
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            Image.asset(
              'assets/images/home/banner1.png',
              width: 375.w,
              height: 193.h,
              fit: BoxFit.cover,
            ),
        placeholder: (context, url) =>
            Lottie.asset(
                "assets/images/jiffy_placeholder.json"
            ),
      );
  }

  Widget newArrives() {
    return

      homeController.homePageData.value.banners == null
          ?
      Image.asset(
        'assets/images/home/newArrives.png',
        width: 342.w,
        height: 144.h,
        fit: BoxFit.fill,
      )
          :
      homeController.homePageData.value.banners!.length < 3 ?
      Image.asset(
        'assets/images/home/newArrives.png',
        width: 342.w,
        height: 144.h,
        fit: BoxFit.fill,
      )
          :
      homeController.homePageData.value.banners![2].image!.isEmpty ?
      Image.asset(
        'assets/images/home/newArrives.png',
        width: 342.w,
        height: 144.h,
        fit: BoxFit.fill,
      )
          :
      CachedNetworkImage(
        imageUrl: homeController.homePageData.value.banners![2].image!,
        width: 375.w,
        height: 193.h,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            Image.asset(
              'assets/images/home/banner1.png',
              width: 375.w,
              height: 193.h,
              fit: BoxFit.cover,
            ),
        placeholder: (context, url) =>
            Lottie.asset(
                "assets/images/jiffy_placeholder.json"
            ),
      );
    ;
  }

  Widget premiumProduct(context) {
    return Obx(() {
      return Container(
        color: const Color(0xff1A0033),
        height: 401.h,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: [
            SizedBox(height: 15.h,),
            Text("Premium Products".tr, style: secondaryTextStyle(
                color: Colors.white,
                size: 23.sp.round(),
                weight: FontWeight.w700
            ),),
            SizedBox(height: 35.h,),
            Expanded(
              child: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/home/line_through_premium_products.svg",
                    fit: BoxFit.cover,),
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeController
                        .homePageData.value
                        .latestProducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: 5.w, start: 5.w),
                          child: premiumProductTemplate(homeController
                              .homePageData.value
                              .latestProducts[index], index, context)


                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

      );
    });
  }

  Widget viewProductSection(title, dynamic product, context) {
    return Column(
      children: [
        TitleWithSeeAll(
          title: title,
          actionText: 'See all'.tr,
          onTap: () {
            // Navigate to "See All" or perform some action
            print('See All tapped');
          },
        ),

        Transform.translate(
          offset: const Offset(0, -30),
          child: Container(
            height: 290.h + 65.h,
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsetsDirectional.only(start: 5.w),
            child:
            product.length == 0 ?
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                   return

                  productCard(AppConstants.sampleProduct, context, index);
              },
            )
                :
            Padding(
              padding: EdgeInsetsDirectional.only(start: 10.w),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: product.length,
                itemBuilder: (context, index) {
                  return productCard(product[index], context, index);
                },
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: const Duration(seconds: 1));
  }

  Future<bool> onLikeButtonTapped(bool isLiked, dynamic product) async {
    try {
      // Check if the product is in the wishlist
      if (wishListController
          .isProductInWishList(product.id)
          .value) {
        // Remove from wishlist
        wishListController.wishlistProductIds
            .removeWhere((item) => item == product.id);
        wishListController.removeFromWishlist(product.id!);
      } else {
        // Add to wishlist
        wishListController.wishlistProductIds!.value.add(product.id);
        wishListController.addToWishlist(product.id,);
      }
      return !isLiked;
      // Return the updated liked state (toggle)
    } catch (e) {
      return false;
    }
  }


  Widget premiumProductTemplate(Product product, int index, context) {
    CartController myCartController = Get.find();
    return GestureDetector(
      onTap: () async {
        ProductController productController = Get.put(ProductController());
        await productController.getProduct(product.id!);
        Get.to(const ProductView());
      },
      child: Padding(
        padding: EdgeInsets.only(

            top: 0.h),
        child: SizedBox(
          height: 290.h,
          width: 180.w,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SvgPicture.asset("assets/images/home/premium_product.svg",
                height: 320.h,
              ),
              SizedBox(
                height: 340.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h,),
                    CachedNetworkImage(
                      width: 100.w,
                      height: 100.h,
                      imageUrl: "${product.image}",
                      placeholder: (context, url) =>
                          Lottie.asset(
                            "assets/images/jiffy_placeholder.json",
                          ),
                      errorWidget: (context, url, error) =>
                          Image.asset(
                            "assets/images/placeholder.png",
                          ),


                    ),

                    Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      child: Text(
                        "${product.name}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: primaryTextStyle(
                          color: Color(0xFFFEFEFE),
                          size: 15.sp.round(),
                          height: 1.05,
                          weight: FontWeight.w900,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, 10),
                      child: Container(
                        width: 100.w,
                        alignment: Alignment.center,
                        child: Text(
                          "300 gm",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: primaryTextStyle(
                            color: Color(0xFFFEFEFE),
                            size: 14.sp.round(),
                            height: 1.05,
                            weight: FontWeight.w400,
                            letterSpacing: -0.41,
                          ),
                        ),
                      ),
                    ),

                    Transform.translate(
                      offset:  Offset(0, 55.h),
                      child: Container(
                          width: 100.w,
                          alignment: Alignment.center,
                          child: Text(
                              "\$ ${product.price}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: primaryTextStyle(
                                color: Color(0xFFFEFEFE),
                                size: 17.sp.round(),
                              )
                          )
                      ),
                    ),

                    SizedBox(height: 5.h,),
                    Obx(() {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: myCartController.cartItems.any((item) =>
                        item.product.id == product.id) ?
                        Transform.translate(
                          offset: Offset(0, 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  addToCart(product);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        height: 100.h,
                                        color: Colors.white,
                                        fit: BoxFit.cover,
                                        "assets/images/home/add_to_cart_premium.svg"),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15.h),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.only(
                                                start: 5.w,


                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  handleDecrement(product , myCartController);
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/images/home/minus.svg',
                                                  color: primaryColor,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            )
                                          ]),
                                          Column(children: [
                                            Text(
                                              '${myCartController
                                                  .cartItems[myCartController
                                                  .cartItems.indexWhere((item) =>
                                              item.product.id == product.id)]
                                                  .quantity}',
                                              textAlign: TextAlign.center,
                                              style: primaryTextStyle(

                                                size: 20.sp.round(),
                                                height: 1.05,
                                                weight: FontWeight.w900,
                                                letterSpacing: -0.41,
                                                color: primaryColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            )
                                          ]),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                Get.locale!.languageCode == 'ar' ?
                                                EdgeInsets.only(
                                                    left: 5.w


                                                )
                                                :
                                                EdgeInsets.only(


                                                  right: 5.w

                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    handleIncrement(product , myCartController);
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/home/plus.svg',
                                                    color: primaryColor,
                                                    height: 20.h,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                            :
                        GestureDetector(
                          onTap: () {
                            addToCart(product);
                          },
                          child: Transform.translate(
                            offset: Offset(0, 15),
                            child: SvgPicture.asset(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 3.9,
                                fit: BoxFit.cover,
                                "assets/images/home/add_to_cart_premium.svg"),
                          ),
                        ),
                      );
                    }),


                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build a category item with icon and text
  Widget buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 56.h,
          decoration: ShapeDecoration(
            shape: OvalBorder(),
            gradient: RadialGradient(
              colors: [
                Colors.white, // Inner color (center)
                Colors.black.withOpacity(0.25), // Slight outer glow (border)
              ],
              center: Alignment(0.0, 0.0),
              radius: 0.98, // Control how far the gradient spreads
              stops: [0.45, 1.0], // Define the transition points between colors
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 20,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Center(
              child: Image.asset(
                'assets/images/home/cate.png',
                width: 22.w,
                height: 22.h,
              )),
        ),
        SizedBox(height: 10.h),
        SizedBox(
            width: 60.w, // Static width to maintain horizontal alignment
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(
                  color: const Color(0xFF20003D),
                  size: 14.sp.round(),
                  weight: FontWeight.w600,
                  height: 1,
                  letterSpacing: -0.41,
                ),
              ),
            ))
      ],
    );
  }

  // Dots indicator for the bottom of the page
  Widget buildDots(HomeController controller) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        List.generate((controller.categories.length / 4).ceil(), (index) {
          return GestureDetector(
            onTap: () {
              // When the dot is tapped, animate to the corresponding page
              controller.pageController.value.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              // Update the current page index
              controller.currentPage.value = index;
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsetsDirectional.only(start: 5.w),
              width: controller.currentPage.value == index ? 34.w : 9.w,
              height: 8.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.9),
                color: controller.currentPage.value.round() == index
                    ? Color(0xFF4F0099)
                    : Color(0x334F0099).withOpacity(0.2),
              ),
            ),
          );
        }),
      );
    });
  }


}

class SemiLunarScrollView extends StatefulWidget {
  @override
  _SemiLunarScrollViewState createState() => _SemiLunarScrollViewState();
}

class _SemiLunarScrollViewState extends State<SemiLunarScrollView> {
  final ScrollController _scrollController = ScrollController();
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
        homeController.isCategoriesLoading.value ?
        //Loading One
        ListView.separated(
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 8,
          itemBuilder: (context, index) {
            double offset = _scrollController.hasClients
                ? _scrollController.offset
                : 0.0;

            upperValue(index, offset) {
              if (index < 3) {
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 9;
              } else if (index ==3){
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 6;
              }
              else {
                // homeController.toggleRotation();
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 7;
              }
            }
            double curveOffset = math.sin(
                (upperValue(index, offset) - offset) / 90) * 10;

            return GestureDetector(
              onTap: () {
                print("sdfsdfdsfsd");
                var bodyRequest = {
                  "category_ids[0]": homeController.categories[index].id
                      .toString(),
                  'orderBy': 'high-low',

                };
                customSearchController.toggleSelectedCategory(
                    homeController.categories[index].name);
                customSearchController.getProducts(bodyRequest);


                Get.to(() => const SearchView());
                // customSearchController.scrollListener();
                customSearchController.animateToCategory(index);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 30.0.h, left: 20.w, right: 20.w),
                child: Transform.translate(
                  offset: Offset(0.w, curveOffset),
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Lottie.asset(
                          "assets/images/jiffy_placeholder.json",


                        ),
                      )
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 2.w,);
          },
        )
            :
        //Data One
        ListView.separated(
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: homeController
              .categories.length,
          itemBuilder: (context, index) {
            double offset = _scrollController.hasClients
                ? _scrollController.offset
                : 0.0;

            upperValue(index, offset) {
              if (index < 3) {
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 9;
              } else if (index ==3){
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 6;
              }
              else {
                // homeController.toggleRotation();
                return index * MediaQuery
                    .of(context)
                    .size
                    .height / 7;
              }
            }
            double curveOffset = math.sin(
                (upperValue(index, offset) - offset) / 100) * 20;

            return SizedBox(
              child: GestureDetector(
                onTap: () {
                  print("sdfsdfdsfsd");
                  var bodyRequest = {
                    "category_ids[0]": homeController.categories[index].id
                        .toString(),
                    'orderBy': 'high-low',

                  };
                  customSearchController.toggleSelectedCategory(
                      homeController.categories[index].name);
                  customSearchController.getProducts(bodyRequest);


                  Get.to(() => const SearchView());
                  // customSearchController.scrollListener();
                  customSearchController.animateToCategory(index);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 30.0.h, left: 20.w, right: 20.w),
                  child: Transform.translate(
                    offset: Offset(0.w, curveOffset),
                    child: Column(
                      children: [
                        Container(

                          decoration: BoxDecoration(
                              boxShadow: [

                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                )

                              ]
                          ),
                          child: CircleAvatar(

                            backgroundColor: Colors.white,
                            backgroundImage: CachedNetworkImageProvider(
                              homeController.categories[index].image!,

                            ),


                            radius: 30,

                          ),
                        ),
                        SizedBox(height: 5.h,),
                        InkWell(
                          onTap: () {

                          },
                          child: SizedBox(
                            width: 52.w,

                            child: Text(homeController.categories[index].name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: secondaryTextStyle(
                                  size: 12.sp.round()
                              ),),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: 2.w,);
          },
        );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

