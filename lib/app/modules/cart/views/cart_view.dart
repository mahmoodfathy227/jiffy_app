import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/product/controllers/product_controller.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:jiffy/app/routes/app_pages.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _handAnimationController;
  late Animation<Offset> _handAnimation;
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAnimation;
  List<Product> cartProducts = [];

  //  Uri? _lastProcessedLink;
  // StreamSubscription<String?>? _linkSubscription;

  // Future<void> _handleIncomingLinks() async {
  //   // Handle initial link if app was launched via a deep link
  //   final initialLink = await getInitialLink();
  //   if (initialLink != null) {
  //     _processIncomingLink(Uri.parse(initialLink));
  //   }

  //   // Attach a listener to handle deep links after the app is already started
  //   _linkSubscription = linkStream.listen((String? link) {
  //     if (link != null) {
  //       _processIncomingLink(Uri.parse(link));
  //     }
  //   });
  // }

  // void _processIncomingLink(Uri uri) {
  //   if (_lastProcessedLink == uri) {
  //     print("Duplicate deep link ignored: $uri");
  //     return;
  //   }

  //   // Process only if the path is /cart/ and has query parameters
  //   if (uri.path == '/cart/' && uri.queryParameters.isNotEmpty) {
  //     _lastProcessedLink = uri; // Track the processed link

  //     cartController.shareLoading.value = true;
  //     _processDeepLink(uri);
  //   }
  // }

  // void _processDeepLink(Uri deepLinkUri) async {
  //   String products = deepLinkUri.queryParameters['products'] ?? '';

  //   // Split each product by commas
  //   List<String> productDetails = products.split(',');

  //   for (String productDetail in productDetails) {
  //     // Each productDetail contains id, size, and color, e.g., "59-XXXL-Pink"
  //     List<String> details = productDetail.split('-');
  //     if (details.length == 3) {
  //       String id = details[0];
  //       String size = details[1];
  //       String color = details[2];

  //       // Fetch product by id and assign size and color
  //       await productController.getProduct(id);
  //       var product = productController.product.value;
  //       product.selectedSize = size;
  //       product.selectedColor = color;

  //       cartShareProducts.add(product);
  //     }
  //   }

  //   cartController.shareLoading.value = false;
  //   setState(() {});
  // }
  @override
  void initState() {
    super.initState();
    cartController.fetchCartDetailsFromAPI();
    // _handleIncomingLinks();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _handAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _handAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.0, 0),
    ).animate(CurvedAnimation(
      parent: _handAnimationController,
      curve: Curves.easeInOut,
    ));

    _handAnimationController.repeat(reverse: false);
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleAnimationController.dispose();
    _handAnimationController.dispose();
    // _linkSubscription?.cancel();
    super.dispose();
  }

  Widget itemCart(Product product, CartItem item, int index) {
    return FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ).animate(_animation),
          child: InkWell(
              onTap: () {
                cartController.cartItems[index].isDismissible = false;
                cartController.cartItems.refresh();
              },
              child: Container(
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: product!.id.toString(),
                          child: Container(
                            width: 97.88.w,
                            height: 117.72.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: product!.image!.isEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                      fit: BoxFit.cover,
                                      width: 102.w,
                                      height: 96.h,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.network(
                                        'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                        fit: BoxFit.cover,
                                        width: 97.88.w,
                                        height: 117.72.h,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: product!.image!,
                                      fit: BoxFit.cover,
                                      width: 102.w,
                                      height: 96.h,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.network(
                                        'https://via.assets.so/shoe.png?id=1&q=95&w=360&h=360&fit=fill',
                                        fit: BoxFit.cover,
                                        width: 102.w,
                                        height: 96.h,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(width: 13.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 114.w,
                              child: Text(
                                GetMaxChar(product!.name ?? '', 16),
                                style: secondaryTextStyle(
                                  color: Color(0xFF20003D),
                                  size: 20.sp.round(),
                                  weight: FontWeight.w600,
                                  letterSpacing: -0.41,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Text(
                              GetMaxChar(product!.description ?? '', 16),
                              style: secondaryTextStyle(
                                color: Color(0x7F949494),
                                size: 14.sp.round(),
                                weight: FontWeight.w400,
                                letterSpacing: -0.41,
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Text(
                              '\$ ${product!.price}',
                              style: secondaryTextStyle(
                                color: Color(0xFF4F0099),
                                size: 16.sp.round(),
                                weight: FontWeight.w600,
                                letterSpacing: -0.41,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AnimatedPositionedDirectional(
                        duration: const Duration(milliseconds: 300),
                        top: 0.h,
                        end: !item.isDismissible ? 0.w : 0.w,
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 86.h,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      cartController.updateQuantity(
                                          item, item.quantity + 1);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/cart/plus.svg',
                                      width: 24.w,
                                      height: 24.h,
                                    )),
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        child: child, scale: animation);
                                  },
                                  child: Text(
                                    item.quantity.toString(),
                                    key: ValueKey<int>(item.quantity),
                                    style: secondaryTextStyle(
                                      color: Color(0xFF4F0099),
                                      size: 20.sp.round(),
                                      weight: FontWeight.w500,
                                      letterSpacing: -0.41,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      if (item.quantity > 1) {
                                        cartController.updateQuantity(
                                            item, item.quantity - 1);
                                        item.quantity - 1;
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/cart/minus.svg',
                                      width: 24.w,
                                      height: 24.h,
                                    )),
                              ],
                            ),
                          ),
                        ])),
                    PositionedDirectional(
                      bottom: 0.h,
                      end: 0.w,
                      child: Observer(
                        builder: (_) => Dismissible(
                          key: Key(item.product.toString()),
                          background: Container(
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(Icons.check,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                          direction: DismissDirection.startToEnd,
                          onUpdate: (details) {},
                          confirmDismiss: (direction) async {
                            cartController.cartItems[index].isDismissible =
                                false;
                            cartController.cartItems.refresh();
                            return false;
                          },
                          onDismissed: (direction) {
                            //   cartController.removeItem(item);
                          },
                          child: InkWell(
                            onTap: () {
                              cartController.removeItem(item);
                            },
                            child: Container(
                              width: item.isDismissible ? 50.w : 0,
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: item.isDismissible
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(Icons.delete,
                                    color: Colors.white, size: 24.w),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  void showCustomBlurDialog() {
    Get.dialog(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // The blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  color: Colors.black
                      .withOpacity(0.2), // Dark overlay with opacity
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 324.w,
                    padding: EdgeInsets.all(20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Are you sure?',
                          style: secondaryTextStyle(
                            color: Color(0xFF20003D),
                            size: 22.sp.round(),
                            weight: FontWeight.w600,
                            letterSpacing: -0.41,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 236.w,
                          child: Text(
                            'Are you sure you want to delete this item from Cart? ',
                            textAlign: TextAlign.center,
                            style: secondaryTextStyle(
                              color: Color(0xFF20003D),
                              size: 14.sp.round(),
                              fontFamily: 'MuseoModerno',
                              weight: FontWeight.w300,
                              letterSpacing: -0.41,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 119.w,
                                  height: 36.h,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(43),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x26000000),
                                        blurRadius: 30,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                      child: Text('Cancel',
                                          style: secondaryTextStyle(
                                            color: Colors.black,
                                            size: 16.sp.round(),
                                            weight: FontWeight.w500,
                                            letterSpacing: -0.41,
                                          ))),
                                )),
                            InkWell(
                                onTap: () {
                                  cartController
                                      .clearCart(); // Uncomment if cartController is defined
                                  Get.back();
                                },
                                child: Container(
                                  width: 119.w,
                                  height: 36.h,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFFF4141),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(43),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x4C000000),
                                        blurRadius: 30,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Delete',
                                      style: secondaryTextStyle(
                                        color: Colors.white,
                                        size: 16.sp.round(),
                                        weight: FontWeight.w500,
                                        letterSpacing: -0.41,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: cartController.isAuth.value
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 100.h,
                        left: 0,
                        right: 0,
                        child: buildCartWidgets(),
                      ),
                      CustomAppBar(
                        myFunction: () {
                          print('sadsadsad');
                          showCustomBlurDialog();
                        },
                        title: "Cart",
                        svgPath: "assets/images/cart/clear.svg",
                      ),
                    ],
                  ))
              : Align(
                  alignment: Alignment.center,
                  child: socialMediaPlaceHolder()));
    });
  }

  buildCartWidgets() {
    if (cartController.loading.value || cartController.shareLoading.value) {
      return SizedBox(
          width: 327.w,
          height: 670.h,
          child: Center(
              child: LoadingAnimationWidget.inkDrop(
            color: primaryColor,
            size: 50,
          )));
    } else if (cartController.cartItems.isEmpty) {
      return SizedBox(
          width: 327.w,
          height: 670.h,
          child: EmptyScreen(
            nameImage: 'assets/images/cart/shopping-cart.png',
            title: 'Your cart is empty!',
            desc:
                'Explore our products and add items to your cart. Your selections will appear here.',
            txtbutton: 'Start Shopping',
          ));
    } else {
      return SizedBox(
          width: 327.w,
          height: 670.h,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Expanded(
                child: AnimatedContainer(
                  width: 327.w,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.slowMiddle,
                  child: ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];

                      return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Observer(
                              builder: (_) => !item.isDismissible
                                  ? Dismissible(
                                      key: Key(item.product.toString()),
                                      background: Container(
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(
                                              width: 0.50,
                                              color: Color(0xFFFAFAFA)),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                        ),
                                        child: Center(
                                          child: Icon(Icons.delete,
                                              color: Colors.white, size: 30),
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      onUpdate: (details) {},
                                      confirmDismiss: (direction) async {
                                        //    cartController.removeItem(item);
                                        cartController.cartItems[index]
                                            .isDismissible = true;
                                        cartController.cartItems.refresh();

                                        return false; // إعادة false لمنع الحذف
                                      },
                                      onDismissed: (direction) {
                                        //    cartController.removeItem(item);
                                      },
                                      child:
                                          itemCart(item.product, item, index))
                                  : itemCart(item.product, item, index)));
                    },
                  ),
                ),
              ),
              Hero(
                tag: 'checkout',
                child: Material(
                  color: Colors.transparent,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Container(
                      width: 375.w,
                      height: 100.h, // Adjust height as per new design

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  textAlign: TextAlign.center,
                                  style: secondaryTextStyle(
                                    color: Color(0xFF20003D),
                                    size: 20.sp.round(),
                                    fontFamily: 'MuseoModerno',
                                    weight: FontWeight.w500,
                                    letterSpacing: -0.41,
                                  ),
                                ),
                                Text(
                                  '\$${cartController.cartItems.fold<double>(0, (sum, item) => sum + num.parse(item.product!.price.toString()) * item.quantity).toStringAsFixed(1)}',
                                  textAlign: TextAlign.center,
                                  style: secondaryTextStyle(
                                    color: Color(0xFF4F0099),
                                    size: 26.sp.round(),
                                    weight: FontWeight.w500,
                                    letterSpacing: -0.41,
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.CHECKOUT);
                              },
                              child: Container(
                                width: 181.w,
                                height: 64.h,
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(1.00, 0.04),
                                    end: Alignment(-1, -0.04),
                                    colors: [
                                      Color(0xFF20003D),
                                      Color(0xFF6900CC),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(43),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x4C000000),
                                      blurRadius: 30,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Check Out',
                                      style: primaryTextStyle(
                                        size: 16.sp.round(),
                                        weight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    CircleAvatar(
                                      radius: 16.w,
                                      backgroundColor: Color(0xFF6101BB),
                                      child: Text(
                                        '${cartController.cartItems.length}',
                                        style: primaryTextStyle(
                                          size: 18.sp.round(),
                                          weight: FontWeight.w700,
                                          color: Colors.white,

                                          letterSpacing: -0.45,
                                          // Match button color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }
  }
}
