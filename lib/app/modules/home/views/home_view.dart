import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/builtInPackage/like_button-2.0.5/lib/like_button.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/product/controllers/product_controller.dart';
import 'package:jiffy/app/modules/product/views/product_view.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:jiffy/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:lottie/lottie.dart';
import '../../../routes/app_pages.dart';
import '../../auth/views/login_view.dart';
import '../../main/controllers/tab_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  // Inject HomeController using GetX
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController =
  Get.put(CartController()); // ربط CartController
  final WishlistController wishListController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xFFF8F3FF),
        body: SingleChildScrollView(
            child: Column(
              // استخدام Column لضمان التمرير
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 750.h, // يمكن تخصيص الارتفاع أو جعله مرنًا
                    child: Stack(
                      children: [
                        // Slide-down animation using GetX controlled animations
                        PositionedDirectional(
                            start: -127.w,
                            top: -280.h,
                            child: SlideTransition(
                                position: homeController.slideAnimation,
                                child: FadeTransition(
                                  opacity: homeController
                                      .fadeInAnimation, // GetX Fade-In
                                  child: Container(
                                    width: 644.w,
                                    height: 663.h,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 15.w,
                                          top: 0,
                                          child: Obx(() {
                                            // This widget will now reactively listen to changes in rotationAngleCircule
                                            return Transform.rotate(
                                              angle: homeController
                                                  .rotationAngleCircule
                                                  .value,
                                              // Controlled by HomeController
                                              child: SvgPicture.asset(
                                                'assets/images/home/circule.svg',
                                                fit: BoxFit.contain,
                                                width: 644.w,
                                                height: 598.h,
                                              ),
                                            );
                                          }),
                                        ),
                                        // ListView with Rotation
                                        Positioned.fill(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: 150
                                                    .h,
                                                // Adjust height if needed
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width +
                                                    85.w,
                                                child: PageView.builder(
                                                  onPageChanged: (
                                                      int pageIndex) {
                                                    homeController
                                                        .onPageChanged(
                                                        pageIndex); // GetX Page change handler
                                                  },
                                                  controller: homeController
                                                      .pageController.value,
                                                  itemCount: (homeController
                                                      .categories.length /
                                                      4)
                                                      .ceil(),
                                                  // Number of pages
                                                  itemBuilder:
                                                      (context, pageIndex) {
                                                    int startIndex = pageIndex *
                                                        4;
                                                    int endIndex =
                                                    (startIndex + 4) >
                                                        homeController
                                                            .categories
                                                            .length
                                                        ? homeController
                                                        .categories.length
                                                        : startIndex + 4;
                                                    List<
                                                        String> currentCategories =
                                                    homeController.categories
                                                        .sublist(startIndex,
                                                        endIndex);

                                                    return Center(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            top: 0.h),
                                                        child: SizedBox(
                                                          height: 300
                                                              .h,
                                                          // Adjust to fit your curve
                                                          child: ListView
                                                              .builder(
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            physics:
                                                            const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                            currentCategories
                                                                .length,
                                                            itemBuilder: (
                                                                context,
                                                                indexList) {
                                                              // Adjust vertical offset based on index to create the curved effect
                                                              double verticalShift =
                                                              homeController
                                                                  .calculateVerticalShift(
                                                                  indexList,
                                                                  currentCategories
                                                                      .length);
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal: 34
                                                                      .w /
                                                                      2, // Horizontal spacing
                                                                ),
                                                                child: Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      0,
                                                                      verticalShift),
                                                                  child: Column(
                                                                    children: [
                                                                      buildCategoryItem(
                                                                        currentCategories[
                                                                        indexList],
                                                                        Icons
                                                                            .category,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              // Add dots indicator below categories
                                              buildDots(homeController),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))),

                        // Add Search bar with Slide and Fade animation
                        Positioned(
                            top: 36.h,
                            left: 0,
                            right: 0,
                            child: SearchHomeBar(
                                homeController: homeController)),
// body of home
                        PositionedDirectional(
                            top: 400.h,
                            child: Column(
                              children: [
                                Obx(() =>
                                    SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0,
                                              0.0),
                                          // يبدأ خارج الشاشة على اليمين (x = 1)
                                          end: const Offset(0.0,
                                              0.0), // ينتهي في موقعه الطبيعي (x = 0)
                                        ).animate(
                                          CurvedAnimation(
                                            parent: homeController.controller,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                        child: viewProductSection(
                                            'Latest Product',
                                            homeController
                                                .homePageData.value
                                                .latestProducts,
                                            context))),
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(
                            1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                        end: const Offset(
                            0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                      ).animate(
                        CurvedAnimation(
                          parent: homeController.controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Obx(() {
                        return BannerAd();
                      })),
                  SizedBox(
                    height: 9.h,
                  ),
                  Obx(() =>
                      SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(
                                1.0, 0.0),
                            // يبدأ خارج الشاشة على اليمين (x = 1)
                            end: const Offset(
                                0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                          ).animate(
                            CurvedAnimation(
                              parent: homeController.controller,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: viewProductSection(
                              'Featured Product',
                              homeController.homePageData.value
                                  .featuredProducts,
                              context))),
                  SizedBox(
                    height: 9.h,
                  ),

                  SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(
                            1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                        end: const Offset(
                            0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                      ).animate(
                        CurvedAnimation(
                          parent: homeController.controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Obx(() {
                        return BannerAd2();
                      })),


                  SizedBox(
                    height: 9.h,
                  ),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(
                            1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                        end: const Offset(
                            0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                      ).animate(
                        CurvedAnimation(
                          parent: homeController.controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: premiumProduct(context)),
                  SizedBox(
                    height: 35.h,
                  ),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(
                            1.0, 0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
                        end: const Offset(
                            0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                      ).animate(
                        CurvedAnimation(
                          parent: homeController.controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Obx(() {
                        return newArrives();
                      })),
                  SizedBox(
                    height: 29.h,
                  ),
                  Obx(() =>
                      SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(
                                1.0, 0.0),
                            // يبدأ خارج الشاشة على اليمين (x = 1)
                            end: const Offset(
                                0.0, 0.0), // ينتهي في موقعه الطبيعي (x = 0)
                          ).animate(
                            CurvedAnimation(
                              parent: homeController.controller,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: viewProductSection(
                              'Perfumes',
                              homeController.homePageData.value
                                  .featuredProducts,
                              context))),
                  SizedBox(
                    height: 9.h,
                  ),
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
      CachedNetworkImage(
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
            Text("Premium Products", style: secondaryTextStyle(
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
                              .latestProducts[index], index)


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
          actionText: 'See all',
          onTap: () {
            // Navigate to "See All" or perform some action
            print('See All tapped');
          },
        ),
        Container(
          height: 290.h + 65.h, // يمكنك تعديل الارتفاع بناءً على تصميمك
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsetsDirectional.only(start: 10.w),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsetsDirectional.only(end: 5.w, start: 5.w),
                  child: productCard(product[index])


              );
            },
          ),
        ),
      ],
    );
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
        wishListController.addToWishlist(product.id);
      }
      return !isLiked;
      // Return the updated liked state (toggle)
    } catch (e) {
      return false;
    }
  }

  Widget productCard(Product product) {
    int index = homeController.homePageData.value.latestProducts
        .indexWhere((item) => item.id == product.id);
    return Obx(() {
      return GestureDetector(
        onTap: () async {
          ProductController productController = Get.put(ProductController());
          await productController.getProduct(product.id!);
          Get.to(const ProductView());
        },
        child: Container(
            decoration: const BoxDecoration(
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),)
            ),
            padding: EdgeInsets.all(15.w),
            width: 195.w,

            child: Stack(children: [
              PositionedDirectional(
                  top: 10,
                  child: ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Container(
                        width: 170.w,
                        height: 259.h + 55.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 120.h,
                                      child: CachedNetworkImage(
                                        imageUrl: product.image,
                                        placeholder: (context, url) =>
                                        Lottie.asset(
                                          "assets/images/jiffy_placeholder.json"
                                        ),
                                            // SizedBox(
                                            //     height: 120.h,
                                            //     child: Center(
                                            //         child:
                                            //         CircularProgressIndicator())),
                                        // مؤشر تحميل
                                        errorWidget: (context, url, error) =>
                                            Image.network(
                                              'https://jiffy.abadr.work/storage/products/01JAHWCTCQC9V501F1ZPF46G4T.png',
                                              // صورة بديلة عند فشل التحميل
                                              height: 120.h,
                                            ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // صورة المنتج

                                    Text(
                                      GetMaxChar(product.name, 12),
                                      textAlign: TextAlign.center,
                                      style: secondaryTextStyle(
                                        color: Color(0xFF20003D),
                                        size: 16.sp.round(),
                                        weight: FontWeight.w600,
                                        letterSpacing: -0.41,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                    Text(
                                      '${product.size ?? 300} gm',
                                      style: secondaryTextStyle(
                                        color: Color(0xFF20003D),
                                        size: 12.sp.round(),
                                        weight: FontWeight.w300,
                                        letterSpacing: -0.41,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                  ]),
                              FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        if (index == 1)
                                          Opacity(
                                            opacity: 0.50,
                                            child: Text(
                                              '24.40',
                                              textAlign: TextAlign.start,
                                              style: secondaryTextStyle(
                                                color: Color(0xFFA1A1A1),
                                                size: 12.sp.round(),
                                                fontFamily: 'MuseoModerno',
                                                weight: FontWeight.w400,
                                                height: 3,
                                                letterSpacing: -0.41,
                                                decoration: TextDecoration
                                                    .lineThrough,
                                                // تحديد الخط السفلي
                                                decorationColor: Colors
                                                    .red,
                                                // تحديد لون الخط السفلي
                                                decorationThickness:
                                                2, // يمكنك تغيير سمك الخط إذا رغبت
                                              ),
                                            ),
                                          ),
                                        if (index == 1) SizedBox(width: 10.w),
                                        Text(
                                          '\$${product.price ?? ""}',
                                          textAlign: TextAlign.center,
                                          style: secondaryTextStyle(
                                            color: Color(0xFF4F0099),
                                            size: 22.sp.round(),
                                            weight: FontWeight.w600,
                                            letterSpacing: -0.41,
                                          ),
                                        ),
                                        if (index == 1) SizedBox(width: 20.w),
                                      ])),
                              SizedBox(height: 8),
                            ]),
                      ))),
              PositionedDirectional(
                  top: 20,
                  end: 10.w,
                  child: Obx(
                        () =>
                        LikeButton(
                          onTap: onLikeButtonTapped,
                          product: product,
                          isLiked: wishListController
                              .isProductInWishList(product.id)
                              .value,
                          size: 20.sp,
                          circleColor: const CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeCountAnimationDuration: Duration(seconds: 1),
                          likeCountAnimationType: LikeCountAnimationType.all,
                          countBuilder: (int? count, bool isLiked,
                              String text) {
                            var color =
                            isLiked ? Colors.deepPurpleAccent : Colors.grey;

                            return Text(
                              '',
                              style: TextStyle(color: color),
                            );
                          },
                          likeBuilder: (bool isLiked) {
                            return SvgPicture.asset(
                              wishListController
                                  .isProductInWishList(product.id)
                                  .value
                                  ? 'assets/images/addwish.svg'
                                  : 'assets/images/home/heart.svg',
                              color: isLiked ? Colors.deepPurpleAccent : Colors
                                  .grey,
                              width: 20.w,
                            );
                          },
                        ),
                  )),
              if (index == 1)
                PositionedDirectional(
                  top: -4.h,
                  start: 5.w,
                  child: ShowUp(
                      child: Container(
                          width: 38.w * 1.8,
                          height: 44.h * 1.8,
                          child: Stack(children: [
                            SvgPicture.asset(
                              'assets/images/home/off.svg',
                              width: 38.w * 1.8,
                              height: 44.h * 1.8,
                              fit: BoxFit.cover,
                            ),
                            PositionedDirectional(
                                bottom: 35.h,
                                start: 17.w,
                                child: ShowUp(
                                  child: Text(
                                    '${50}%',
                                    style: secondaryTextStyle(
                                      color: Colors.white,
                                      size: 12.sp.round(),
                                      weight: FontWeight.w800,
                                      letterSpacing: -0.41,
                                    ),
                                  ),
                                )),
                          ]))),
                ),
              PositionedDirectional(
                bottom: -15.h,
                end: 0.w,
                start: -10.w,
                child: SizedBox(
                  height: 250.h,
                  child: Stack(
                    children: [
                      // الخلفية SVG
                      PositionedDirectional(
                        bottom:
                        cartController.cartItems.isEmpty ||
                            cartController.cartItems.indexWhere(
                                    (item) =>
                                item.product.id ==
                                    product.id) ==
                                -1
                            ?
                        8
                            :
                        4
                        ,
                        end:
                        cartController.cartItems.isEmpty ||
                            cartController.cartItems.indexWhere(
                                    (item) =>
                                item.product.id ==
                                    product.id) ==
                                -1
                            ?
                        -12.w
                            :
                        15.w
                        ,
                        start:

                        cartController.cartItems.isEmpty ||
                            cartController.cartItems.indexWhere(
                                    (item) =>
                                item.product.id ==
                                    item.product.id) ==
                                -1
                            ? 22.w : 15.w,
                        child: SvgPicture.asset(
                          cartController.cartItems.isEmpty ||
                              cartController.cartItems.indexWhere(
                                      (item) =>
                                  item.product.id ==
                                      product.id) ==
                                  -1
                              ?
                          "assets/images/home/add_background.svg"

                              :
                          'assets/images/home/borderCart.svg'
                          ,
                          fit: BoxFit.cover,

                          height: 134.h,

                        ),
                      ),
                      // Cart controls
                      PositionedDirectional(
                        bottom: 66.h,
                        end:
                        cartController.cartItems.isEmpty ||
                            cartController.cartItems.indexWhere(
                                    (item) =>
                                item.product.id ==
                                    product.id) ==
                                -1
                            ?
                        -3.w

                            :
                        0,
                        start: 12,
                        child: SizedBox(
                          width: 80.w,
                          child: Obx(
                                () =>
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: cartController.cartItems.isEmpty ||
                                      cartController.cartItems.indexWhere(
                                              (item) =>
                                          item.product.id ==
                                              product.id) ==
                                          -1
                                      ? InkWell(
                                    onTap: () {
                                      if (userToken == null) {
                                        Get.to(() => LoginView());
                                      } else {
                                        int initialQty = product.d_limit > 0
                                            ? product.d_limit
                                            : 1;
                                        cartController.addToCart(product,
                                            quantity: initialQty);
                                      }
                                    },
                                    child:
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/images/home/add_icon.svg',
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                    ),

                                  )
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(
                                            start: 10.w,

                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (userToken == null) {
                                                Get.to(() => LoginView());
                                                return;
                                              }
                                              var index = cartController
                                                  .cartItems
                                                  .indexWhere((item) =>
                                              item.product.id ==
                                                  product.id);
                                              var currentItem = cartController
                                                  .cartItems[index];

                                              // تحقق إذا كانت الكمية تساوي d_limit بعد النقصان، وحذف المنتج إذا كانت كذلك
                                              if (product.d_limit != 0 &&
                                                  currentItem.quantity >
                                                      product.d_limit ||
                                                  product.d_limit == 0 &&
                                                      currentItem.quantity >
                                                          1) {
                                                cartController.updateQuantity(
                                                  currentItem,
                                                  currentItem.quantity - 1,
                                                );
                                              } else if (product.d_limit == 0 &&
                                                  currentItem.quantity ==
                                                      1 ||
                                                  currentItem.quantity ==
                                                      product.d_limit) {
                                                print('teasdsadsadsa');
                                                cartController
                                                    .removeItem(currentItem);
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/home/minus.svg',
                                              width: 20.w,
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
                                          '${cartController
                                              .cartItems[cartController
                                              .cartItems.indexWhere((item) =>
                                          item.product.id == product.id)]
                                              .quantity}',
                                          textAlign: TextAlign.center,
                                          style: primaryTextStyle(
                                            color: Color(0xFFFEFEFE),
                                            size: 20.sp.round(),
                                            height: 1.05,
                                            weight: FontWeight.w900,
                                            letterSpacing: -0.41,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        )
                                      ]),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 5.w),
                                            child: InkWell(
                                              onTap: () {
                                                if (userToken == null) {
                                                  Get.to(() => LoginView());
                                                  return;
                                                }
                                                var index = cartController
                                                    .cartItems
                                                    .indexWhere((item) =>
                                                item.product.id ==
                                                    product.id);
                                                var currentItem = cartController
                                                    .cartItems[index];
                                                cartController.updateQuantity(
                                                  currentItem,
                                                  currentItem.quantity + 1,
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/home/plus.svg',
                                                width: 20.w,
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
                                ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ])),
      );
    });
  }

  Widget premiumProductTemplate(Product product, int index) {
    return GestureDetector(
      onTap: () async {
        ProductController productController = Get.put(ProductController());
        await productController.getProduct(product.id!);
        Get.to(const ProductView());
      },
      child: Padding(
        padding: EdgeInsets.only(

            top: index.isOdd ? 0.h : 50.h),
        child: SizedBox(
          height: index.isOdd ? 290.h : 160.h,
          width: index.isOdd ? 180.w : 120.w,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SvgPicture.asset("assets/images/home/premium_product.svg",
                height: index.isOdd ? 320.h : 260.h,
              ),
              SizedBox(
                height: index.isOdd ? 340.h : 270.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h,),
                    CachedNetworkImage(
                      width: index.isOdd ? 100.w : 70.w,
                      height: index.isOdd ? 80.h : 50.h,
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
                    SizedBox(height: 10.h,),
                    Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      child: Text(
                        "${product.name}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: primaryTextStyle(
                          color: Color(0xFFFEFEFE),
                          size: index.isOdd ? 20.sp.round() : 15.sp.round(),
                          height: 1.05,
                          weight: FontWeight.w900,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h,),
                    Container(
                      width: 100.w,
                      alignment: Alignment.center,
                      child: Text(
                        "300 gm",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: primaryTextStyle(
                          color: Color(0xFFFEFEFE),
                          size: index.isOdd ? 14.sp.round() : 10.sp.round(),
                          height: 1.05,
                          weight: FontWeight.w400,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h,),
                    Container(
                        width: 100.w,
                        alignment: Alignment.center,
                        child: Text(
                            "${product.price}",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: primaryTextStyle(
                              color: Color(0xFFFEFEFE),
                              size: index.isOdd ? 22.sp.round() : 15.sp.round(),
                            )
                        )
                    ),

                    SizedBox(height: index.isOdd ? 5.h : 20.h,),
                    Obx(() {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: cartController.cartItems.any((item) =>
                        item.product.id == product.id) ?
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (userToken == null) {
                                  Get.to(() => LoginView());
                                } else {
                                  int initialQty = product.d_limit > 0
                                      ? product.d_limit
                                      : 1;
                                  cartController.addToCart(product,
                                      quantity: initialQty);
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                      height: index.isOdd ? 100.h : 70.h,
                                      color: primaryColor,
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
                                                if (userToken == null) {
                                                  Get.to(() => LoginView());
                                                  return;
                                                }
                                                var index = cartController
                                                    .cartItems
                                                    .indexWhere((item) =>
                                                item.product.id ==
                                                    product.id);
                                                var currentItem = cartController
                                                    .cartItems[index];

                                                // تحقق إذا كانت الكمية تساوي d_limit بعد النقصان، وحذف المنتج إذا كانت كذلك
                                                if (product.d_limit != 0 &&
                                                    currentItem.quantity >
                                                        product.d_limit ||
                                                    product.d_limit == 0 &&
                                                        currentItem.quantity >
                                                            1) {
                                                  cartController.updateQuantity(
                                                    currentItem,
                                                    currentItem.quantity - 1,
                                                  );
                                                } else
                                                if (product.d_limit == 0 &&
                                                    currentItem.quantity ==
                                                        1 ||
                                                    currentItem.quantity ==
                                                        product.d_limit) {
                                                  print('teasdsadsadsa');
                                                  cartController
                                                      .removeItem(currentItem);
                                                  // cartController.updateQuantity(
                                                  //   currentItem,
                                                  //   currentItem.quantity -
                                                  //       product.d_limit,
                                                  // );
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/home/minus.svg',

                                                height: index.isOdd ? 20.h : 15
                                                    .h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          )
                                        ]),
                                        Column(children: [
                                          Text(
                                            '${cartController
                                                .cartItems[cartController
                                                .cartItems.indexWhere((item) =>
                                            item.product.id == product.id)]
                                                .quantity}',
                                            textAlign: TextAlign.center,
                                            style: primaryTextStyle(
                                              color: Color(0xFFFEFEFE),
                                              size: 20.sp.round(),
                                              height: 1.05,
                                              weight: FontWeight.w900,
                                              letterSpacing: -0.41,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          )
                                        ]),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 5.w),
                                              child: InkWell(
                                                onTap: () {
                                                  if (userToken == null) {
                                                    Get.to(() => LoginView());
                                                    return;
                                                  }
                                                  var index = cartController
                                                      .cartItems
                                                      .indexWhere((item) =>
                                                  item.product.id ==
                                                      product.id);
                                                  var currentItem = cartController
                                                      .cartItems[index];
                                                  cartController.updateQuantity(
                                                    currentItem,
                                                    currentItem.quantity + 1,
                                                  );
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/images/home/plus.svg',

                                                  height: index.isOdd
                                                      ? 20.h
                                                      : 15.h,
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
                        )
                            :
                        GestureDetector(
                          onTap: () {
                            if (userToken == null) {
                              Get.to(() => LoginView());
                            } else {
                              int initialQty = product.d_limit > 0
                                  ? product.d_limit
                                  : 1;
                              cartController.addToCart(product,
                                  quantity: initialQty);
                            }
                          },
                          child: SvgPicture.asset(
                              height: index.isOdd ? 100.h : 80.h,
                              fit: BoxFit.cover,
                              "assets/images/home/add_to_cart_premium.svg"),
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

