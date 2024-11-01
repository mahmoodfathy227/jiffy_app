import 'dart:io';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiffy/app/modules/auth/views/login_view.dart';
import 'package:jiffy/app/modules/cart/views/cart_view.dart';
import 'package:jiffy/app/modules/global/config/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../global/config/configs.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart';
import '../../global/theme/app_theme.dart';
import '../../global/theme/colors.dart';

import '../../global/widget/widget.dart';
import '../../services/api_service.dart';
import '../controllers/product_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'FullImage.dart';

// final CartController cartController = Get.put(CartController());

class ProductView extends GetView<ProductController> {
  const ProductView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductController().initialized ? null : Get.put(ProductController());
    controller.setIndex();
print("${"pro id is ${controller.product.value.id}"}");
    return Scaffold(
      backgroundColor: primaryBackgroundColor,

      body: SafeArea(
        child: Obx(() {
          return
            // controller.product.value.image == null
            //   ? SizedBox(
            //       height: MediaQuery.of(context).size.height,
            //       child: SingleChildScrollView(
            //         child: Column(
            //           children: [
            //             //Search Bar
            //             _buildSearchWidget(context),
            //             //Carousel Images
            //             Opacity(
            //               opacity: 0.3,
            //               child: controller.placeHolderImg.value.isEmpty
            //                   ? SizedBox()
            //                   : Image.network(
            //                       controller.placeHolderImg.value,
            //                       width: MediaQuery.of(context).size.width,
            //                       height:
            //                           MediaQuery.of(context).size.height / 2,
            //                       fit: BoxFit.cover,
            //                     ),
            //             ),
            //
            //             LoadingWidget(
            //               Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     //Product Name and Rating
            //                     _buildProductNameAndStartRating(
            //                         context, controller.product.value),
            //                     //Product Price
            //                     _buildProductPrice(
            //                         context, controller.product.value),
            //
            //                     //Product Details
            //                     _buildProductDetails(
            //                         context, controller.product.value),
            //
            //                     //Product Reviews
            //                     _buildProductReviews(
            //                         context, controller.product.value),
            //                   ]),
            //             )
            //           ],
            //         ),
            //       ),
            //     )
            //   :
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        _buildProductImagesCarousel(
                            context, [controller.product.value.image], "", controller.productImages),
                        CustomAppBar(
                          myFunction: () {},
                          title: "Product",
                          svgPath: "assets/images/shopping-cart.svg",
                        ),
                      ],
                    ),

                    //Search Bar
                    // _buildSearchWidget(context),
                    //Carousel Images

                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //build Small Photos

                          SizedBox(
                            height: 90.h,
                          ),
                          //Product Name and Rating
                          _buildProductNameAndStartRating(
                              context, controller.product.value),
                          //Product Price
                          _buildProductPrice(context, controller.product.value),
                          //Description
                          _buildProductDetails(
                              context, controller.product.value),

                          //Product rating
                          _buildProductRating(),
                          //Product Reviews
                          _buildProductReviews(
                              context, controller.product.value),

                          //Customer Reviews
                          _buildCustomersReviews(context),
                          SizedBox(
                            height: 100.h,
                          )

// //Product Colors
//                           _buildProductColors(context),

                          // //Product Sizes
                          // _buildProductSizes(context),
                          //Product Details
                          // _buildProductDetails(
                          //     context, controller.product.value),
                          //Product Size Guide

                          // _buildSizeGuide(
                          //     context, controller.product.value),

                          //See Also Products
                          // _buildSeeAlsoProduct(
                          //     context, controller.product.value),
                        ]),
                  ],
                ),
              ),
            );
        }),
      ),
      floatingActionButton: Obx(() {
        return

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                height: 75.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
                  border: Border.all(color: primaryColor),
                  color:  Colors.white
                ),

                width: controller.isAddToCartActive.value ?
                MediaQuery
                    .of(context)
                    .size
                    .width / 2.5
                    :
                0,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        var index = cartController
                            .cartItems
                            .indexWhere((item) =>
                        item.product.id ==
                            controller.product.value.id);
                        var currentItem = cartController
                            .cartItems[index];

                        // تحقق إذا كانت الكمية تساوي d_limit بعد النقصان، وحذف المنتج إذا كانت كذلك
                        if (controller.product.value.d_limit != 0 &&
                            currentItem.quantity >
                                controller.product.value.d_limit ||
                            controller.product.value.d_limit == 0 &&
                                currentItem.quantity >
                                    1) {
                          cartController.updateQuantity(
                            currentItem,
                            currentItem.quantity - 1,
                          );
                        } else if (controller.product.value.d_limit == 0 &&
                            currentItem.quantity ==
                                1 ||
                            currentItem.quantity ==
                                controller.product.value.d_limit) {
                          print('teasdsadsadsa');
                          cartController
                              .removeItem(currentItem);
                          controller.changeAddToCartStatus();
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/home/minus.svg',
                        width: 27.w,
                        height: 27.h,
                        color: Colors.red,
                      ),
                    ),
                    Obx(() {
                      return Text(
                        cartController.cartItems[controller.cartIndex.value]
                            .quantity.toString(),
                        style: secondaryTextStyle(
                            size: 15.sp.round()
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () {
                        var index = cartController
                            .cartItems
                            .indexWhere((item) =>
                        item.product.id ==
                            controller.product.value.id);
                        var currentItem = cartController
                            .cartItems[index];
                        cartController.updateQuantity(
                          currentItem,
                          currentItem.quantity + 1,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/home/plus.svg',
                        width: 27.w,
                        height: 27.h,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
                height: 91.h,
                width: controller.isAddToCartActive.value ?
                MediaQuery
                    .of(context)
                    .size
                    .width / 2.5
                    : MediaQuery
                    .of(context)
                    .size
                    .width - 60.w,

                child: SizedBox(


                  child: FloatingActionButton(

                      onPressed: () {

                      },
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      child: ShowUp(
                          delay: 200,
                          child: GestureDetector(
                            onTap: () async {

                            },
                            child: SizedBox(

                                child:

                                MyDefaultButton(
                                  isPlainBackground: false,
                                  height: 75.h,
                                  btnWidth: 350,
                                  onPressed: () {
                                    if(userToken == null){
                                      Get.to(()=> LoginView());
                                    }else {
                                      if (controller.isAddToCartActive.value) {
                                        Get.to(() => CartPage());
                                      } else {
                                        controller.changeAddToCartStatus();
                                      }
                                    }

                                  },

                                  isloading: false,
                                  btnText:
                                  controller.isAddToCartActive.value ?
                                  "View Cart"
                                      :
                                  "Add To Cart",
                                  isSecondaryTextStyle: true,
                                  borderRadius: 51,


                                )

                            ),
                          )
                      )
                  ),
                ),
              )
            ],
          );
// :
//           AnimatedContainer(
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.fastOutSlowIn,
//           height: 91.h,
//           width:  controller.isAddToCartActive.value ?
//           MediaQuery
//               .of(context)
//               .size
//               .width / 2.5
//               : MediaQuery
//               .of(context)
//               .size
//               .width - 60.w,
//           child: SizedBox(
//
//
//             child: FloatingActionButton(
//
//                 onPressed: () {
//
//                 },
//                 backgroundColor: Colors.transparent,
//                 elevation: 0.0,
//                 child: ShowUp(
//                     delay: 200,
//                     child: GestureDetector(
//                       onTap: () async {
//
//                       },
//                       child: SizedBox(
//
//                           child:
//
//                           MyDefaultButton(
//                             isPlainBackground: false,
//                             height: 75.h,
//                             btnWidth: 350,
//                             onPressed: () {
//                               controller.changeAddToCartStatus();
//                             },
//
//                             isloading: false,
//                             btnText:
//                             controller.isAddToCartActive.value ?
//                             "View Cart"
//                             :
//                             "Add To Cart",
//                             isSecondaryTextStyle: true,
//                             borderRadius: 51,
//
//
//                           )
//
//                       ),
//                     )
//                 )
//             ),
//           ),
//         );
      }),

      floatingActionButtonLocation:
      // controller.isAddToCartActive.value ? FloatingActionButtonLocation.endFloat :
      FloatingActionButtonLocation.centerFloat,

    );
  }

  buildBottomSheet(Product comingProduct, BuildContext context) {
    final DraggableScrollableController sheetController =
    DraggableScrollableController();
    final ScrollController scrollController = ScrollController();

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 3,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 1.0),
          BoxShadow(color: Colors.white70, offset: Offset(0, -1)),
          BoxShadow(color: Colors.white70, offset: Offset(0, 1)),
          BoxShadow(color: Colors.white70, offset: Offset(-1, -1)),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: CustomScrollView(controller: scrollController, slivers: [
        SliverList.list(children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                ///////////////////Size//////////////////////////////
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Size",
                          style: boldTextStyle(
                            size: 18.sp.round(),
                            letterSpacing: 0.8.w,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    // controller.product.value.sizeGuide?.fitType == null
                    //     ? SizedBox()
                    //     : GestureDetector(
                    //         onTap: () {
                    //           Get.to(
                    //               () => SizeGuideView(
                    //                     selectedFitType: controller
                    //                             .productSizeGuide
                    //                             .value
                    //                             .fitType ??
                    //                         "",
                    //                     selectedStretch: controller
                    //                         .productSizeGuide.value.stretch!,
                    //                     selectedAttr: controller
                    //                         .productSizeGuide.value.attr!,
                    //                   ),
                    //               transition: Transition.fadeIn,
                    //               curve: Curves.easeInOut,
                    //               duration: const Duration(milliseconds: 400));
                    //         },
                    //         child: LoadingWidget(
                    //           Padding(
                    //             padding: EdgeInsets.symmetric(horizontal: 15.w),
                    //             child: Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Text(
                    //                   "Size Guide",
                    //                   style: primaryTextStyle(
                    //                       color: Colors.grey[300]),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 3.w,
                    //                 ),
                    //                 Icon(
                    //                   Icons.arrow_forward_ios_rounded,
                    //                   color: Colors.grey[300],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       )
                  ],
                ),
                SizedBox(height: 10.h),

                const Spacer(),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.sp),
                      topRight: Radius.circular(20.sp),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                        const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      ShowUp(
                        delay: 300,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            children: [
                              Text(
                                "SubTotal",
                                style: primaryTextStyle(
                                  size: 17.sp.round(),
                                  weight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "\$ ${comingProduct.price!}",
                                style: primaryTextStyle(
                                  size: 17.sp.round(),
                                  weight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      ShowUp(
                        delay: 300,
                        child: GestureDetector(
                          onTap: () {
                            // // Handle Add to Cart action
                            // if (userToken != null) {
                            //   print('teasdsadsa');
                            //   bool isProductInCart =
                            //       cartController.cartItems.any(
                            //     (element) =>
                            //         element.product != null &&
                            //         controller.product != null &&
                            //         element.selectedSize ==
                            //             controller.selectedSize.value &&
                            //         element.product.id ==
                            //             controller.product.value.id,
                            //   );
                            //
                            //   print('teasdsadsa2');
                            //
                            //   if (isProductInCart) {
                            //     cartController.removeItem(cartController
                            //         .cartItems
                            //         .firstWhere((element) =>
                            //             element.product.id ==
                            //             controller.product.value.id));
                            //   }
                            //   print('teasdsadsa3');
                            //   cartController.loading.value = true;
                            //   controller.product.value.selectedSize =
                            //       controller.selectedSize.value;
                            //   controller.product.value.selectedColor =
                            //       controller.selectedColor.value;
                            //   if (controller.selectedSize.value.isNotEmpty &&
                            //       controller.selectedColor.value.isNotEmpty) {
                            //     cartController.addToCart(
                            //       controller.product.value,
                            //       controller.selectedSize.value,
                            //       controller.selectedColor.value,
                            //       quantity: 1,
                            //     );
                            //     print('teasdsadsa4');
                            //     Get.toNamed(Routes.CART);
                            //     cartController.loading.value = false;
                            //   } else {
                            //     Get.snackbar(
                            //         "Error", "Please Select From Options First",
                            //         backgroundColor: Colors.white);
                            //   }
                            // } else {
                            //   Get.to(() => CartPage());
                            // }
                          },
                          child: SvgPicture.asset(
                            "assets/images/product/add_to_cart.svg",
                            height: 60.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ])
      ]),
    );
  }

  buildRatingWidget(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  controller.product.value.rating == null
                      ? "0"
                      : controller.product.value.rating.toString(),
                  style: secondaryTextStyle(
                      color: Color(0xFF231F20),
                      height: 0.03,
                      letterSpacing: 0.48,
                      weight: FontWeight.w400,
                      size: 40.sp.round())),
              SizedBox(
                width: 10.w,
              ),
              Text("OUT OF 5",
                  style: secondaryTextStyle(
                      color: Color(0xFF8A8A8F),
                      height: 0.11,
                      letterSpacing: 0.07,
                      weight: FontWeight.w400,
                      size: 12.sp.round())),
              Spacer(),
              controller.product.value.rating == null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StarRating(
                      isCustomer: false,
                      rating: 5,
                      onRatingChanged: (v) {},
                      color: const Color(0xffFBBD51)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text("83 ratings",
                      style: secondaryTextStyle(
                        color: greyishColor,
                        size: 12.sp.round(),
                      ))
                ],
              )
                  : StarRating(
                  isCustomer: false,
                  rating: controller.product.value.rating!.toDouble(),
                  onRatingChanged: (v) {},
                  color: Color(0xffFBBD51))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // buildRatingBar(
          //     "5",
          //     controller.product.value.rating
          //         ? 0
          //         : controller.product.value.rating[4].toDouble()),
          // buildRatingBar(
          //     "4",
          //     controller.product.value.rating
          //         ? 0
          //         : controller.product.value.rating.toDouble()),
          // buildRatingBar(
          //     "3",
          //     controller.product.value.rating
          //         ? 0
          //         : controller.product.value.rating![2].toDouble()),
          // buildRatingBar(
          //     "2",
          //     controller.product.value.rating
          //         ? 0
          //         : controller.product.value.rating![1].toDouble()),
          // buildRatingBar(
          //     "1",
          //     controller.product.value.rating!.isEmpty
          //         ? 0
          //         : controller.product.value.rating![1].toDouble()),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  buildRatingBar(String number, double percentage) {
    return Container(
      height: 30.h,
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Text(
            number,
            style: secondaryTextStyle(color: greyishColor, size: 12.sp.round()),
          ),
          SizedBox(
            width: 3.w,
          ),
          Icon(
            Icons.star,
            color: Color(0xffFBBD51),
            size: 18.sp,
          ),
          SizedBox(
            width: 4.w,
          ),
          Flexible(
            flex: 12,
            child: LinearPercentIndicator(
              backgroundColor: Colors.grey[300],
              percent: percentage / 100,
              // progressColor: Color(0xffFBBD51),
              progressColor: primaryColor,
              barRadius: Radius.circular(25.w),
            ),
          ),
          Spacer(),
          Text(
            "${(percentage).toInt().toString()} %",
            style: secondaryTextStyle(
                weight: FontWeight.w300, size: 13.sp.round()),
          )
        ],
      ),
    );
  }

  _buildSearchWidget(context) {
    return Column(
      children: [
        SizedBox(
          height: 15.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            height: 50.h,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Row(
              children: [
                Obx(() {
                  ProductController productController =
                  Get.put(ProductController());
                  return InkWell(
                    onTap: () {
                      // productController.isHomeIcon.value
                      //     ? Get.to(() => MainView())
                      //     : Get.back();
                    },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: productController.isHomeIcon.value
                          ? const Icon(Icons.home)
                          : SvgPicture.asset(
                          "assets/images/forgot_password/Frame 361.svg"),
                    ),
                  );
                }),
                Spacer(),
                Obx(() {
                  return controller.isSharing.value
                      ? Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: primaryColor,
                        size: 30,
                      ))
                      : IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      await _shareProductWithImage();
                    },
                  );
                }),
                IconButton(
                  icon: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 26.w,
                      height: 26.h,
                    ),
                  ),
                  onPressed: () {
                    // HomeController homeController = HomeController().initialized
                    //     ? Get.find<HomeController>()
                    //     : Get.put(HomeController());
                    // var products = homeController.homeModel.value.product;
                    // var categories = homeController.homeModel.value.categories;
                    //
                    // Get.to(SearchView(),
                    //     arguments: [products, categories],
                    //     transition: Transition.fadeIn,
                    //     curve: Curves.easeInOut,
                    //     duration: const Duration(milliseconds: 400));
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          height: 2,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  Future<void> _shareProductWithImage() async {
    controller.startSharing();
    final url = "${controller.product.value.image}";
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/image.jpg');
    file.writeAsBytesSync(response.bodyBytes);

    final xFile = XFile(file.path);

    Share.shareXFiles([xFile],
        text:
        'Check out this Product: https://mariannela-8c357.web.app/product/?id=${controller
            .product.value.id} ');
    controller.endSharing();
  }

  _buildProductImagesCarousel(
      BuildContext context,
      List<String> imgList,
      placeHolderImg, List<Attachments> otherImgList) {

    //adding attachments
    // if (otherImgList.isNotEmpty) {
    //   for (var img in otherImgList) {
    //     if (img.name == "app_show") {
    //       imgList.addNonNull(img.path!);
    //     }
    //   }
    // }

    return ShowUp(
      delay: 200,
      child: Transform(
        transform: Matrix4.translationValues(0, 97.h, 0),
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 2.06,
            decoration: const BoxDecoration(
              color: primaryBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            child: ImageSliderWithIndicators(
              imgList: otherImgList.isNotEmpty
                  ?
              otherImgList.map((e) => e.path!).toList()
                  :

              imgList
              ,
              placeHolderImg: placeHolderImg,
            )),
      ),
    );
  }

  _buildProductNameAndStartRating(BuildContext context,
      Product comingProduct) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Name
          Row(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(comingProduct.name ?? "Purple Flower EDP",
                      style: secondaryTextStyle(
                          size: 25.sp.round(),
                          color: const Color(0xff20003D),
                          weight: FontWeight.w500))),
              const Spacer(),
              Align(
                  alignment: Alignment.topLeft,
                  child: SvgPicture.asset("assets/images/favourite.svg"))
            ],
          ),

          //Star Rating
          // Padding(
          //   padding: EdgeInsets.only(left: 10.w),
          //   child: Row(
          //     children: [
          //       StarRating(
          //         onRatingChanged: (double rating) {},
          //         color: Colors.green,
          //         rating: controller.product.value.rating == null
          //             ? 0
          //             : controller.product.value.rating.toDouble(),
          //         isCustomer: false,
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(top: 10.h),
          //         child: comingProduct.rating == null
          //             ? Text(
          //                 "(0)",
          //                 style: primaryTextStyle(),
          //               )
          //             : Text(
          //                 "(${comingProduct.rating.toString()})",
          //                 style: primaryTextStyle(),
          //               ),
          //       )
          //     ],
          //   ),
          // ),
          Text(
            "300 gm",
            style: secondaryTextStyle(
                weight: FontWeight.w400, size: 16.sp.round()),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  _buildProductPrice(BuildContext context, Product comingProduct) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          //Price
          Row(
            children: [
              Text("${comingProduct.price ?? "19.20"}\$",
                  style: secondaryTextStyle(
                      size: 28.sp.round(),
                      color: primaryColor,
                      weight: FontWeight.w900)),
              const Spacer(),
              Text("Available on fast delivery",
                  style: secondaryTextStyle(
                      size: 13.sp.round(),
                      color: secondaryPrimaryColor,
                      weight: FontWeight.w400))
            ],
          ),
          SizedBox(
            height: 13.h,
          ),
        ],
      ),
    );
  }

  _buildProductDetails(BuildContext context, Product comingProduct) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
      child: Column(
        children: [
          //Details

          Container(
            margin: EdgeInsets.symmetric(horizontal: 7.w),
            height: 1.h,
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5.h,
          ),
          Obx(() =>
          controller.isShowDescription.value
              ? DescriptionTextWidget(
            text: comingProduct.description ??
                ""
                    "",
          )
              : SizedBox()),
        ],
      ),
    );
  }

  _buildSeeAlsoProduct(BuildContext context, Product comingProduct) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Reviews
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text("Related Products",
              style: boldTextStyle(size: 22.sp.round())),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7.w),
          height: 1,
          color: Colors.grey[300],
        ),
        SizedBox(
          height: 15.h,
        ),
        _buildProductGrid(context)
      ],
    );
  }

  _buildProductReviews(BuildContext context, Product comingProduct) {
    return Column(
      children: [
        //Reviews
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.2),
          child: Row(
            children: [
              Text("Reviews",
                  style: secondaryTextStyle(
                      size: 18.sp.round(),
                      weight: FontWeight.w700,
                      color: Colors.black)),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: myCustomDivider(),
        ),
        SizedBox(
          height: 5.h,
        ),
        // Obx(() => controller.isShowReviews.value
        //     ? buildRatingWidget(context)
        //     : SizedBox())

        Obx(() {
          return buildRatingWidget(context);
        })
      ],
    );
  }

  _buildAddToCartButton(myContext, Product comingProduct) {
    return GestureDetector(
      onTap: () async {
        // try {
        //   // تحقق مما إذا كان المستخدم مسجلاً
        //   if (userToken != null) {
        //     print('Starting add to cart process...');
        //
        //     // التحقق مما إذا كان المنتج موجودًا بالفعل في السلة
        //     bool isProductInCart = cartController.cartItems.any(
        //       (element) =>
        //           element.product != null &&
        //           controller.product != null &&
        //           element.selectedSize == controller.selectedSize.value &&
        //           element.product.id == controller.product.value.id,
        //     );
        //
        //     print('Checking if product is already in cart...');
        //
        //     // إذا كان المنتج موجودًا في السلة، قم بإزالته
        //     // if (isProductInCart) {
        //     //   print('Product is in cart, removing...');
        //     //   await cartController.removeItem(
        //     //     cartController.cartItems.firstWhere((element) =>
        //     //         element.product.id == controller.product.value.id),
        //     //   );
        //     //   print('Product removed from cart.');
        //     // }
        //
        //     // تعيين حالة التحميل إلى true
        //     cartController.loading.value = true;
        //
        //     // ضبط الحجم واللون للمنتج
        //     controller.product.value.selectedSize =
        //         controller.selectedSize.value;
        //     controller.product.value.selectedColor =
        //         controller.selectedColor.value;
        //
        //     // التحقق من أن المستخدم قد اختار الحجم واللون
        //     if (controller.selectedSize.value.isNotEmpty &&
        //         controller.selectedColor.value.isNotEmpty) {
        //       print('Adding product to cart...');
        //
        //       // إضافة المنتج إلى السلة
        //       await cartController.addToCart(
        //         controller.product.value,
        //         controller.selectedSize.value,
        //         controller.selectedColor.value,
        //         quantity: 1,
        //       );
        //
        //       print('Product added to cart successfully.');
        //
        //       // الانتقال إلى صفحة السلة
        //       Get.toNamed(Routes.CART);
        //     } else {
        //       // إظهار رسالة خطأ إذا لم يتم اختيار الحجم أو اللون
        //       Get.snackbar("Error", "Please Select From Options First",
        //           backgroundColor: Colors.white);
        //     }
        //
        //     // إيقاف حالة التحميل
        //     cartController.loading.value = false;
        //   } else {
        //     // إذا لم يكن هناك userToken، انتقل إلى صفحة السلة
        //     Get.to(() => CartPage());
        //   }
        // } catch (e, stackTrace) {
        //   // في حالة حدوث خطأ، عرض الخطأ على وحدة التحكم
        //   print('Error adding to cart: $e $stackTrace');
        //   Get.snackbar("Error", "Something went wrong. Please try again.",
        //       backgroundColor: Colors.white);
        //
        //   // إيقاف حالة التحميل إذا حدث خطأ
        //   cartController.loading.value = false;
        // }
      },
      child: SizedBox(
          child: MyDefaultButton(
            height: 75.h,
            btnWidth: 350,
            onPressed: () {},
            isloading: false,
            btnText: 'Add To Cart',
            isSecondaryTextStyle: true,
            borderRadius: 50,
          )),
    );
  }

  _buildCustomersReviews(context) {
    print("the review is  1 ${controller.reviews}");
    return GetBuilder<ProductController>(
        id: "reviews",
        builder: (logic) {
          return controller.isReviewsLoading
              ? placeHolderWidget()
              : controller.reviews.isEmpty
              ? Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "No Comments Yet ..",
                  style: secondaryTextStyle(),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Icon(
                  Icons.comment_bank,
                  color: greyishColor,
                ),
                SizedBox(
                  height: 30.h,
                )
              ],
            ),
          )
              : Padding(
            padding: EdgeInsets.only(
                left: kDefaultPadding * 1.5,
                top: 10.h,
                right: kDefaultPadding * 1.5,
                bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCustomDivider(),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: kDefaultPadding * 0.6),
                  child: Text(
                    "Reviews (${controller.product.value.rating
                        .toString()})",
                    style: secondaryTextStyle(
                        color: greyishColor, size: 12.sp.round()),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _buildOneCustomerReview(
                            controller.reviews[index], context),
                    separatorBuilder: (context, index) =>
                        Divider(
                          height: 2,
                          color: Colors.grey[300],
                        ),
                    itemCount: controller.reviews.length),
              ],
            ),
          );
        });
  }

  _buildOneCustomerReview(ReviewsModel review, context) {
    print("the review is ${review.title}");
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/images/comment_avatar.png"),
              ),
              SizedBox(
                width: 5.w,
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 120.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customer!,
                      style: secondaryTextStyle(),
                    ),
                    Spacer(),
                    Container(
                      child: StarRating(
                        rating: review.rating!.toDouble(),
                        onRatingChanged: (v) {},
                        color: primaryColor,
                        isCustomer: true,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            review.comment!,
            style: secondaryTextStyle(
              color: greyishColor,
              size: 12.sp.round(),
            ),
          ),
        ],
      ),
    );
  }

  _buildProductGrid(context) {
    return GetBuilder<ProductController>(
        id: "related-products",
        builder: (logic) {
          return controller.isRelatedProductsLoading
              ? placeHolderWidget()
              : controller.finalRelatedProducts.isEmpty
              ? Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
              child: Text(
                "No Related Products Yet",
                style: primaryTextStyle(),
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio:
                  MediaQuery
                      .of(context)
                      .size
                      .width /
                      (MediaQuery
                          .of(context)
                          .size
                          .height *
                          heightDevidedRatio),
                  crossAxisCount: 2,
                  crossAxisSpacing: crossAxisSpacing,
                  mainAxisSpacing: mainAxisSpacing),
              itemBuilder: (context, index) {
                return SizedBox();
                // buildProductCard(
                //   product: controller.finalRelatedProducts[index]);
              },
              itemCount: controller.finalRelatedProducts.length,
            ),
          );
        });
  }

  _buildProductColors(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Colors", style: boldTextStyle(size: 22.sp.round())),
          SizedBox(height: 5.h),
          Divider(
            color: Colors.grey[300],
            height: 2,
          ),
          SizedBox(height: 10.h),
          ShowUp(
            delay: 300,
            child: Obx(() {
              return controller.isProductLoading.value
                  ? loadingIndicatorWidget()
                  : GetBuilder<ProductController>(
                builder: (logic) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    height:
                    70.h, // Increase height to accommodate the text
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) =>
                          GestureDetector(
                            onTap: () {
                              controller.setColor(
                                  controller.colorsList[index].name);
                              controller.changeImagesList(
                                  controller.colorsList[index].name);
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 45.w,
                                  height: 43.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.3)),
                                    color: Color(int.parse(
                                        '0xff${controller.colorsList[index].hex!
                                            .split('#')[1]}')),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child:
                                        controller.selectedColor.value ==
                                            controller
                                                .colorsList[index]
                                                .name
                                            ? ShowUp(
                                          delay: 200,
                                          child: SvgPicture.asset(
                                              'assets/images/selected.svg',
                                              width: 20.w,
                                              height: 20.w,
                                              color: controller
                                                  .colorsList[
                                              index]
                                                  .name ==
                                                  'White'
                                                  ? Colors.black
                                                  : Colors.white),
                                        )
                                            : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                // Spacing between the circle and the text
                                Text(
                                  controller.colorsList[index].name ??
                                      '', // Display color name
                                  style: primaryTextStyle(
                                      size: 12.sp.round(),
                                      weight: FontWeight
                                          .w400), // Adjust font size
                                ),
                              ],
                            ),
                          ),
                      separatorBuilder: (ctx, index) =>
                          SizedBox(width: 5.w),
                      itemCount: controller.colorsList.length,
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  _buildProductSizes(context) {
    // Column(
    //   children: [
    //     ShowUp(
    //       delay: 300,
    //       child: Obx(() {
    //         return controller.isProductLoading.value
    //             ? loadingIndicatorWidget()
    //             : GetBuilder<ProductController>(
    //           builder: (logic) {
    //             return Container(
    //               margin:
    //               EdgeInsets.symmetric(horizontal: 15.w),
    //               height: 50.h,
    //               width: MediaQuery.of(context).size.width,
    //               child: ListView.separated(
    //                 scrollDirection: Axis.horizontal,
    //                 itemBuilder: (ctx, index) =>
    //                     GestureDetector(
    //                       onTap: () {
    //                         controller.setSize(
    //                             controller.sizeList[index]);
    //                       },
    //                       child: Container(
    //                         width: 45.w,
    //                         height: 45.h,
    //                         decoration: ShapeDecoration(
    //                           color: controller.sizeList[index] ==
    //                               controller
    //                                   .selectedSize.value
    //                               ? Color(0xFF515151)
    //                               : Color(0xFFFAFAFA),
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius:
    //                             BorderRadius.circular(16.50),
    //                           ),
    //                         ),
    //                         child: Center(
    //                           child: Text(
    //                             controller.sizeList[index],
    //                             style: primaryTextStyle(
    //                               color: Color(0xffCCCCCC),
    //                               size: 15.sp.round(),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                 separatorBuilder: (ctx, index) =>
    //                     SizedBox(width: 5.w),
    //                 itemCount: controller.sizeList.length,
    //               ),
    //             );
    //           },
    //         );
    //       }),
    //     ),
    //   ],
    // ),
    // //////////////////////////////////////////////////
    // SizedBox(height: 20.h),
    // /////////////////Color//////////////////////////////
    // Padding(
    // padding: EdgeInsets.only(left: 15.w),
    // child: Align(
    // alignment: Alignment.topLeft,
    // child: Text(
    // "Color",
    // style: boldTextStyle(
    // size: 18.sp.round(),
    // letterSpacing: 0.8.w,
    // color: Colors.grey,
    // ),
    // ),
    // ),
    // ),
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //point here
          Row(
            children: [
              Text("Sizes", style: boldTextStyle(size: 22.sp.round())),
              Spacer(),
            ],
          ),
          SizedBox(height: 5.h),
          Divider(
            color: Colors.grey[300],
            height: 2,
          ),
          SizedBox(height: 10.h),
          ShowUp(
            delay: 300,
            child: Obx(() {
              return controller.isProductLoading.value
                  ? loadingIndicatorWidget()
                  : GetBuilder<ProductController>(
                builder: (logic) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    height: 32.h,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) =>
                          GestureDetector(
                            onTap: () {
                              controller.setSize(controller.sizeList[index]);
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 55.w,
                              ),
                              child: Container(
                                padding:
                                EdgeInsets.symmetric(horizontal: 4.w),
                                // width: 55.w,
                                decoration: ShapeDecoration(
                                  color: controller.sizeList[index] ==
                                      controller.selectedSize.value
                                      ? Color(0xFF515151)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(26.50),
                                    side: BorderSide(
                                        width: 2,
                                        color: controller.sizeList[index] ==
                                            controller.selectedSize.value
                                            ? Color(0xFF515151)
                                            : Colors.grey[300]!),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    controller.sizeList[index],
                                    style: primaryTextStyle(
                                      color: controller.sizeList[index] ==
                                          controller.selectedSize.value
                                          ? Color(0xffCCCCCC)
                                          : Colors.black,
                                      size: 15.sp.round(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      separatorBuilder: (ctx, index) =>
                          SizedBox(width: 5.w),
                      itemCount: controller.sizeList.length,
                    ),
                  );
                  //   Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 5.w),
                  //   height:
                  //       70.h, // Increase height to accommodate the text
                  //   width: MediaQuery.of(context).size.width,
                  //   child: ListView.separated(
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (ctx, index) => GestureDetector(
                  //       onTap: () {
                  //         controller.setColor(
                  //             controller.colorsList[index].name);
                  //         controller.changeImagesList(
                  //             controller.colorsList[index].name);
                  //       },
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //             width: 45.w,
                  //             height: 43.h,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               border: Border.all(
                  //                   color: Colors.grey.withOpacity(0.3)),
                  //               color: Color(int.parse(
                  //                   '0xff${controller.colorsList[index].hex!.split('#')[1]}')),
                  //             ),
                  //             child: Stack(
                  //               children: [
                  //                 Center(
                  //                   child:
                  //                       controller.selectedColor.value ==
                  //                               controller
                  //                                   .colorsList[index]
                  //                                   .name
                  //                           ? ShowUp(
                  //                               delay: 200,
                  //                               child: SvgPicture.asset(
                  //                                   'assets/images/selected.svg',
                  //                                   width: 20.w,
                  //                                   height: 20.w,
                  //                                   color: controller
                  //                                               .colorsList[
                  //                                                   index]
                  //                                               .name ==
                  //                                           'White'
                  //                                       ? Colors.black
                  //                                       : Colors.white),
                  //                             )
                  //                           : SizedBox(),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           SizedBox(height: 5.h),
                  //           // Spacing between the circle and the text
                  //           Text(
                  //             controller.colorsList[index].name ??
                  //                 '', // Display color name
                  //             style: primaryTextStyle(
                  //                 size: 12.sp.round(),
                  //                 weight: FontWeight
                  //                     .w400), // Adjust font size
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     separatorBuilder: (ctx, index) =>
                  //         SizedBox(width: 5.w),
                  //     itemCount: controller.colorsList.length,
                  //   ),
                  // );
                },
              );
            }),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }

  _buildProductRating() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: myCustomDivider(),
        ),
        SizedBox(
          height: 9.h,
        ),
        Row(
          children: [
            SizedBox(
              width: kDefaultPadding * 1.5,
            ),
            Text(
              "Rating",
              style: secondaryTextStyle(
                  weight: FontWeight.w300,
                  size: 16.sp.round(),
                  color: secondaryPrimaryColor),
            ),
            Spacer(),
            Icon(
              Icons.star,
              color: Color(0xffFBBD51),
            ),
            Text(
              controller.product.value.rating.toString(),
              style: secondaryTextStyle(color: primaryColor),
            ),
            SizedBox(
              width: kDefaultPadding * 1.5,
            ),
          ],
        ),
        SizedBox(
          height: 60.h,
        ),
      ],
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final bool isCustomer;

  StarRating({this.starCount = 5,
    required this.rating,
    required this.onRatingChanged,
    required this.color,
    required this.isCustomer});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Colors.grey,
        size: isCustomer ? 15 : 22,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme
            .of(context)
            .primaryColor,
        size: isCustomer ? 15 : 22,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme
            .of(context)
            .primaryColor,
        size: isCustomer ? 15 : 22,
      );
    }
    return InkResponse(
      onTap:
      onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
        List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(
        firstHalf!,
        style: secondaryTextStyle(
          size: 12.sp.round(),
          weight: FontWeight.w400,
          color: secondaryPrimaryColor,
          wordSpacing: 8.5,
        ),
      )
          : Column(
        children: <Widget>[
          Text(
            flag ? (firstHalf! + "...") : (firstHalf! + secondHalf!),
            style: secondaryTextStyle(
              size: 13.sp.round(),
              weight: FontWeight.w400,
              color: secondaryPrimaryColor,
              wordSpacing: 8.5,
            ),
          ),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? "show more" : "show less",
                  style: secondaryTextStyle(
                    size: 12.sp.round(),
                    weight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}

class BuildBundle extends StatefulWidget {
  const BuildBundle(
      {super.key, required this.image, required this.name, required this.type});

  final String image;
  final String name;
  final String type;

  @override
  State<BuildBundle> createState() => _BuildBundleState();
}

class _BuildBundleState extends State<BuildBundle> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isTapped = !isTapped;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(8.0.h),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(
              color: isTapped ? Colors.black : Colors.transparent, width: 2.w),
          borderRadius: BorderRadius.circular(15.sp),
        ),
        child: Row(
          children: [
            Image.network(
              widget.image,
              width: 50.w,
              height: 50.h,
            ),
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(
                        color: Colors.black, size: 15.sp.round()),
                  ),
                  Text(
                    widget.type,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(
                        color: Colors.grey, size: 13.sp.round()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageSliderWithIndicators extends StatefulWidget {
  final List<String> imgList;
  final String placeHolderImg;

  const ImageSliderWithIndicators({
    required this.imgList,
    required this.placeHolderImg,
    Key? key,
  }) : super(key: key);

  @override
  _ImageSliderWithIndicatorsState createState() =>
      _ImageSliderWithIndicatorsState();
}

class _ImageSliderWithIndicatorsState extends State<ImageSliderWithIndicators> {
  // int _currentIndex = 0;
  ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    print("your img list length are ${widget.imgList.length}");
    final List<Widget> imageWidgets = widget.imgList.isEmpty
        ? List.generate(
        3, (int index) => Image.asset("assets/images/placeholder.png"))
        : widget.imgList.map((image) {
      return InkWell(
        onTap: () =>
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    FullScreenImage(
                      imageUrls: widget.imgList.map((e) => e).toList(),
                      initialIndex: widget.imgList.indexOf(image),
                    ),
              ),
            ),
        child: Hero(
          tag: image,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0.r),
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.black12,
                  BlendMode.srcATop,
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.2,
                  fit: BoxFit.cover,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  placeholder: (context, url) => placeHolderWidget(),
                ),
              )),
        ),
      );
    }).toList();

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              carouselController: productController.carouselController,
              items: imageWidgets,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                initialPage: productController.selectedIndex.value,
                pauseAutoPlayOnManualNavigate: true,
                aspectRatio: 1.1,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  productController.setSelectedIndex(index);
                  // setState(() {
                  //   _currentIndex = index;
                  // });
                },
              ),
            ),
            _buildSmallImagesWithIndicators(),
          ],
        ),
      ],
    );
  }

  _buildSmallImagesWithIndicators() {
    ProductController myController = Get.put(ProductController());

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: SizedBox(
        height: 100.h,
        child: Column(
          children: [
            Expanded(
              // margin: EdgeInsets.only(left: 5.w),
              // height: 80.h,

              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      InkResponse(
                        onTap: () {
                          myController.setSelectedIndex(index);
                          myController.setCarouselControllerIndex(index);
                        },
                        child: Obx(() {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.sp),
                            child: SizedBox(
                                width: productController.selectedIndex.value ==
                                    index
                                    ? 80.w
                                    : 70.w,


                                child: index <=
                                    myController.productImages.length - 1
                                    ? productController.selectedIndex.value ==
                                    index
                                    ? ShowUp(
                                  child: CachedNetworkImage(
                                    height: 65.h,
                                    imageUrl: myController
                                        .productImages[index].path!,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) =>
                                        placeHolderWidget(),
                                  ),
                                )
                                    : SizedBox(
                                  height: 60.h,
                                  child: ColorFiltered(
                                    colorFilter:
                                    const ColorFilter.mode(
                                      Colors.black38,
                                      BlendMode.srcATop,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: myController
                                          .productImages[index].path!,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          placeHolderWidget(),
                                    ),
                                  ),
                                )
                                    : SizedBox()),
                          );
                        }),
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        width: 5.w,
                      ),
                  itemCount: myController.productImages.length),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgList
                  .asMap()
                  .entries
                  .map((entry) {
                return Obx(() {
                  return GestureDetector(
                    onTap: () =>
                        productController.carouselController
                            ?.animateToPage(entry.key),
                    child: productController.selectedIndex.value == entry.key
                        ? ShowUp(
                      child: Container(
                        width: 33.0,
                        height: 8.0,
                        margin: EdgeInsets.only(
                            top: 4.0.h, left: 2.0.w, right: 2.0.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.sp)),
                      ),
                    )
                        : Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.only(
                          top: 4.0.h, left: 2.0.w, right: 2.0.w),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[600]),
                    ),
                  );
                });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
