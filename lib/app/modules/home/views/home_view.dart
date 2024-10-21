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
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/wishlist/controllers/wishlist_controller.dart';
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
                width: MediaQuery.of(context).size.width,
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
                                              .value, // Controlled by HomeController
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
                                                .h, // Adjust height if needed
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width +
                                                85.w,
                                            child: PageView.builder(
                                              onPageChanged: (int pageIndex) {
                                                homeController.onPageChanged(
                                                    pageIndex); // GetX Page change handler
                                              },
                                              controller: homeController
                                                  .pageController.value,
                                              itemCount: (homeController
                                                          .categories.length /
                                                      4)
                                                  .ceil(), // Number of pages
                                              itemBuilder:
                                                  (context, pageIndex) {
                                                int startIndex = pageIndex * 4;
                                                int endIndex =
                                                    (startIndex + 4) >
                                                            homeController
                                                                .categories
                                                                .length
                                                        ? homeController
                                                            .categories.length
                                                        : startIndex + 4;
                                                List<String> currentCategories =
                                                    homeController.categories
                                                        .sublist(startIndex,
                                                            endIndex);

                                                return Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h),
                                                    child: SizedBox(
                                                      height: 300
                                                          .h, // Adjust to fit your curve
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            currentCategories
                                                                .length,
                                                        itemBuilder: (context,
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
                                                              horizontal: 34.w /
                                                                  2, // Horizontal spacing
                                                            ),
                                                            child: Transform
                                                                .translate(
                                                              offset: Offset(0,
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
                        child: SearchHomeBar(homeController: homeController)),
// body of home
                    PositionedDirectional(
                        top: 416.h,
                        child: Column(
                          children: [
                            Obx(() => SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0,
                                      0.0), // يبدأ خارج الشاشة على اليمين (x = 1)
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
                                        .homePageData.value.latestProducts,
                                    context))),
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
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
                  child: BannerAd()),
              SizedBox(
                height: 9.h,
              ),
              Obx(() => SlideTransition(
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
                  child: viewProductSection(
                      'Featured Product',
                      homeController.homePageData.value.featuredProducts,
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
                  child: newArrives()),
              SizedBox(
                height: 29.h,
              ),
              Obx(() => SlideTransition(
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
                  child: viewProductSection(
                      'Perfumes',
                      homeController.homePageData.value.featuredProducts,
                      context))),
              SizedBox(
                height: 9.h,
              ),
            ])));
  }

  Widget BannerAd() {
    return Image.asset(
      'assets/images/home/banner1.png',
      width: 375.w,
      height: 193.h,
      fit: BoxFit.cover,
    );
  }

  Widget newArrives() {
    return Image.asset(
      'assets/images/home/newArrives.png',
      width: 342.w,
      height: 144.h,
      fit: BoxFit.fill,
    );
  }

  Widget premiumProduct(context) {
    return Image.asset(
      'assets/images/home/premiumProduct.png',
      width: MediaQuery.sizeOf(context).width,
      height: 364.h,
      fit: BoxFit.fill,
    );
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
        SizedBox(height: 16.h), // المسافة بين العنوان والقائمة
        Container(
          height: 270.h + 55.h, // يمكنك تعديل الارتفاع بناءً على تصميمك
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsetsDirectional.only(start: 10.w),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: product.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsetsDirectional.only(end: 5.w, start: 5.w),
                  child: productCard(product[index]));
            },
          ),
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, dynamic product) async {
    try {
      // Check if the product is in the wishlist
      if (wishListController.isProductInWishList(product.id)) {
        // Remove from wishlist
        wishListController.wishlistProductIds
            .removeWhere((item) => item == product.id);
        wishListController.removeFromWishlist(product.id!);
      } else {
        // Add to wishlist
        wishListController.wishlistProductIds!.value.add(product.id);
        wishListController.addToWishlist(product.id);
      }
      return false;
      // Return the updated liked state (toggle)
    } catch (e) {
      return false;

      print("Error in like button: $e");
    }
  }

  Widget productCard(Product product) {
    int index = homeController.homePageData.value.latestProducts
        .indexWhere((item) => item.id == product.id);
    return Container(
        width: 165.w,
        height: 259.h + 100.h,
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
                      borderRadius: BorderRadius.only(
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
                                    placeholder: (context, url) => SizedBox(
                                        height: 120.h,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())), // مؤشر تحميل
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                      'https://jiffy.abadr.work/storage/products/01JAHWCTCQC9V501F1ZPF46G4T.png', // صورة بديلة عند فشل التحميل
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                                .lineThrough, // تحديد الخط السفلي
                                            decorationColor: Colors
                                                .red, // تحديد لون الخط السفلي
                                            decorationThickness:
                                                2, // يمكنك تغيير سمك الخط إذا رغبت
                                          ),
                                        ),
                                      ),
                                    if (index == 1) SizedBox(width: 10.w),
                                    Text(
                                      '\$${product.price?.toStringAsFixed(2)}',
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
            child: LikeButton(
              onTap: onLikeButtonTapped,
              isLiked: wishListController.isProductInWishList(product.id),
              size: 20.sp,
              circleColor:
                  CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xff33b5e5),
                dotSecondaryColor: Color(0xff0099cc),
              ),
              likeBuilder: (bool isLiked) {
                return SvgPicture.asset(
                  'assets/images/home/heart.svg',
                  color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                  width: 20.w,
                );
              },
            ),
          ),
          if (index == 1)
            PositionedDirectional(
              top: 0,
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

          // Add cart controls for each product
          PositionedDirectional(
            bottom: -15.h,
            end: 10.w,
            start: 0,
            child: SizedBox(
                height: 250.h,
                child: Stack(
                  children: [
                    // الخلفية SVG
                    PositionedDirectional(
                      bottom: 0,
                      end: 0,
                      start: 0,
                      child: SvgPicture.asset(
                        'assets/images/home/borderCart.svg',
                        height: 155.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Cart controls
                    PositionedDirectional(
                      bottom: 71.h,
                      end: 0,
                      start: 0,
                      child: SizedBox(
                          width: 80.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(start: 10.w),
                                  child: InkWell(
                                      onTap: () {
                                        cartController.updateQuantity(
                                            cartController.cartItems[
                                                cartController.cartItems
                                                    .indexWhere((item) =>
                                                        item.product.id ==
                                                        product.id)],
                                            cartController
                                                    .cartItems[cartController
                                                        .cartItems
                                                        .indexWhere((item) =>
                                                            item.product.id ==
                                                            product.id)]
                                                    .quantity -
                                                1);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/home/minus.svg',
                                        width: 20.w,
                                        height: 20.h,
                                      ))),
                              Obx(() => Text(
                                    cartController.cartItems.isEmpty ||
                                            cartController.cartItems.indexWhere(
                                                    (item) =>
                                                        item.product.id ==
                                                        product.id) ==
                                                -1
                                        ? '0'
                                        : '${cartController.cartItems[cartController.cartItems.indexWhere((item) => item.product.id == product.id)].quantity}',
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle(
                                      color: Color(0xFFFEFEFE),
                                      size: 20.sp.round(),
                                      weight: FontWeight.w900,
                                      letterSpacing: -0.41,
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    if (!cartController
                                        .isProductInCart(product)) {
                                      cartController.addToCart(
                                        product,
                                      );
                                      return;
                                    }
                                    if (cartController
                                            .isProductInCart(product) &&
                                        cartController.cartItems.isNotEmpty) {
                                      cartController.updateQuantity(
                                          cartController.cartItems[
                                              cartController.cartItems
                                                  .indexWhere((item) =>
                                                      item.product.id ==
                                                      product.id)],
                                          cartController
                                                  .cartItems[cartController
                                                      .cartItems
                                                      .indexWhere((item) =>
                                                          item.product.id ==
                                                          product.id)]
                                                  .quantity +
                                              1);
                                    } // زيادة الكمية
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/home/plus.svg',
                                    width: 20.w,
                                    height: 20.h,
                                  )),
                            ],
                          )),
                    )
                  ],
                )),
          ),
        ]));
  }

  Widget SearchBar() {
    return // Search Text Field inside the rounded container
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: [
          Container(
            width: 287.w,
            height: 44.h,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(31),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 30,
                  offset: Offset(0, 4),
                  spreadRadius: -5,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.only(start: 16.0.w, bottom: 5.h),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: primaryTextStyle(
                          color: Color(0xFF4F0099).withOpacity(0.3),
                          size: 16.sp.round(),
                          weight: FontWeight.w100,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 11.w), // Space between the search field and the icon
          // Search Icon next to the search field
          Container(
              width: 44.w,
              height: 44.h,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(),
                shadows: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 30,
                    offset: Offset(0, 4),
                    spreadRadius: -5,
                  )
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/home/search.svg',
                  width: 18.w,
                  height: 18.h,
                ),
              )),
        ],
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
