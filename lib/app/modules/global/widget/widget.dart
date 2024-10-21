import 'dart:async';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:jiffy/app/modules/home/controllers/home_controller.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:jiffy/app/modules/auth/controllers/auth_controller.dart';
// import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/config/configs.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart' hide Colors;
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
// import 'package:jiffy/app/modules/home/controllers/home_controller.dart';
// import 'package:jiffy/app/modules/main/controllers/tab_controller.dart';
// import 'package:jiffy/app/modules/product/controllers/product_controller.dart';
// import 'package:jiffy/app/modules/product/views/product_view.dart';
// import 'package:jiffy/app/modules/search/controllers/search_controller.dart';
// import 'package:jiffy/app/modules/search/views/result_view.dart';
// import 'package:jiffy/app/modules/search/views/search_view.dart';
import 'package:jiffy/app/modules/services/dio_consumer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../../auth/views/login_view.dart';
import '../../auth/views/register_view.dart';
import '../../services/api_consumer.dart';
import '../../services/api_service.dart';

final AuthController authcontroller = Get.put(AuthController());

class TitleWithSeeAll extends StatelessWidget {
  final String title; // Title text
  final String actionText; // Action text ("See All")
  final VoidCallback onTap; // Action when "See All" is clicked

  const TitleWithSeeAll({
    Key? key,
    required this.title,
    required this.actionText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title Text
              Text(
                title,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(
                  color: Color(0xFF20003D),
                  size: 24.sp.round(),
                  fontFamily: 'MuseoModerno',
                  weight: FontWeight.w600,
                  letterSpacing: -0.41,
                ),
              ),

              // "See All" Text
              GestureDetector(
                onTap: onTap, // Action when "See All" is tapped
                child: Text(
                  actionText,
                  style: secondaryTextStyle(
                    color: Color(0xFF20003D),
                    size: 14.sp.round(),
                    weight: FontWeight.w300,
                    letterSpacing: -0.41,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Widget SearchHomeBar({HomeController? homeController}) {
  // Adding the header with the logo, search bar, and location

  return Container(
      height: 300.h,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideTransition(
                position: homeController!.slideAnimation,
                child: FadeTransition(
                    opacity:
                        homeController!.fadeInAnimation, // GetX controlled fade
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Open Drawer or any action
                          },
                          child: SvgPicture.asset(
                            'assets/images/home/menu.svg',
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/splash/logo.svg',
                          width: 60.w,
                          height: 52.h,
                        ),
                        SvgPicture.asset(
                          'assets/images/home/notification.svg',
                        ),
                      ],
                    ))),
            SizedBox(height: 26.h),
            FadeTransition(
                opacity: homeController.fadeInAnimation, // GetX controlled fade
                child: SearchBar()),
            SizedBox(height: 25.h),
            FadeTransition(
                opacity: homeController.fadeInAnimation, // GetX controlled fade
                child: Text(
                  'Current Location',
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(
                    color: Colors.white,
                    size: 12.sp.round(),
                    weight: FontWeight.w300,
                    letterSpacing: -0.41,
                  ),
                )),
            SizedBox(height: 10.h),
            FadeTransition(
              opacity: homeController.fadeInAnimation, // GetX controlled fade
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/home/locations.svg',
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Cairo, Egypt',
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(
                      color: Color(0xFFFFFDD2),
                      size: 24.sp.round(),
                      weight: FontWeight.w700,
                      height: 0.09,
                      letterSpacing: -0.41,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
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

Widget gridSocialIcon() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (GetPlatform.isIOS)
        ShowUp(
            delay: 400,
            child: SocialMediaIcon(
              assetPath: 'assets/icons/small_apple.svg',
              onTap: () {
                // Handle Apple login
                authcontroller.appleLogin();
              },
            )),
      if (GetPlatform.isIOS) SizedBox(width: 16.w),
      ShowUp(
          delay: 200,
          child: SocialMediaIcon(
            assetPath: 'assets/icons/small_google.svg',
            onTap: () {
              // Handle Google login
              authcontroller.googleLogin();
            },
          )),
      // SizedBox(width: 16.w),
      // ShowUp(
      //     delay: 400,
      //     child: SocialMediaIcon(
      //       assetPath: 'assets/icons/small_facebook.svg',
      //       onTap: () {
      //         // Handle Facebook login
      //       },
      //     )),
    ],
  );
}

class SocialMediaIcon extends StatefulWidget {
  final String assetPath;
  final int? index;
  final VoidCallback onTap;

  const SocialMediaIcon({
    required this.assetPath,
    required this.onTap,
    this.index,
  });

  @override
  _SocialMediaIconState createState() => _SocialMediaIconState();
}

class _SocialMediaIconState extends State<SocialMediaIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SvgPicture.asset(
          widget.assetPath,
          width: 42.w,
          height: 42.h,
        ),
      ),
    );
  }
}

class SecondMyDefaultButton extends StatefulWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final double? height;
  final bool isloading;
  final double? width;

  const SecondMyDefaultButton({
    Key? key,
    this.btnText,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    required this.isloading,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  SecondMyDefaultButtonState createState() => SecondMyDefaultButtonState();
}

class SecondMyDefaultButtonState extends State<SecondMyDefaultButton> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = widget.isloading!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return widget.isloading!
        ? Center(
            child: LoadingAnimationWidget.flickr(
            leftDotColor: primaryColor,
            rightDotColor: const Color(0xFFFF0084),
            size: 50,
          ))
        : InkWell(
            onTap: () => {
              widget.onPressed(),
            },
            child: Container(
              width: 315,
              height: 48,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Color(0xFF21034F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      widget.localeText
                          ? widget.btnText!.toUpperCase()
                          : widget.btnText!,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: widget.textColor ?? Colors.white,
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
  }
}

class MySecondDefaultButton extends StatefulWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final String? Icon;
  final double? height;
  final bool isloading;
  final double? width;

  const MySecondDefaultButton({
    Key? key,
    this.btnText,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    required this.isloading,
    this.textColor,
    this.height,
    this.width,
    this.Icon,
  }) : super(key: key);

  @override
  MySecondDefaultButtonState createState() => MySecondDefaultButtonState();
}

class MySecondDefaultButtonState extends State<MySecondDefaultButton> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = widget.isloading!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return widget.isloading!
        ? Center(
            child: LoadingAnimationWidget.flickr(
            leftDotColor: primaryColor,
            rightDotColor: const Color(0xFFFF0084),
            size: 50,
          ))
        : InkWell(
            onTap: () => {
              widget.onPressed(),
            },
            child: Container(
              width: 315.w,
              height: 48.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                  color: widget.color ?? Color(0xFF21034F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      widget.localeText
                          ? widget.btnText!.toUpperCase()
                          : widget.btnText!,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: Colors.white,
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
  }
}

Widget MainLoading({double? width, double? height}) {
  return SizedBox(
      width: width ?? 375.w,
      height: height ?? 812.h,
      child: Center(
          child: LoadingAnimationWidget.flickr(
        leftDotColor: primaryColor,
        rightDotColor: const Color(0xFFFF0084),
        size: 50,
      )));
}

Color getColorStatusOrder(status) {
  return status == 'PENDING'
      ? const Color(0xFFCF6112)
      : status == 'Delivered'
          ? const Color(0xFF33C200)
          : const Color(0xFFC40000);
}

Widget orderCard(Order order) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8.r,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Order #${order.id}',
                style: secondaryTextStyle(
                  color: Color(0xFF131416),
                  size: 18.sp.round(),
                  weight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 19.w),
            Text(
              order.date,
              style: primaryTextStyle(
                color: Color(0xFF777E90),
                size: 14.sp.round(),
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Tracking number: ${order.code}',
                style: primaryTextStyle(
                  color: Color(0xFF777E90),
                  size: 14.sp.round(),
                  weight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal: \$${order.subTotal}',
              style: primaryTextStyle(
                color: Color(0xFF777E90),
                size: 14.sp.round(),
                weight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              order.status.toUpperCase(),
              style: primaryTextStyle(
                color: getColorStatusOrder(order.status.toUpperCase()),
                size: 14.sp.round(),
                weight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.5.r),
                border: Border.all(color: Color(0xFF777E90), width: 1.w),
              ),
              child: Center(
                child: Text(
                  'Details',
                  style: primaryTextStyle(
                    color: Colors.black,
                    size: 14.sp.round(),
                    weight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class MyDefaultButton extends StatefulWidget {
  final String? btnText;
  final bool localeText;
  final Function() onPressed;
  final Color? color;
  final Color? textColor;
  final bool isSelected;
  final String? Icon;
  final double? height;
  final bool isloading;
  final double? width;

  const MyDefaultButton({
    Key? key,
    this.btnText,
    required this.onPressed,
    this.color,
    this.isSelected = true,
    this.localeText = false,
    required this.isloading,
    this.textColor,
    this.height,
    this.width,
    this.Icon,
  }) : super(key: key);

  @override
  MyDefaultButtonState createState() => MyDefaultButtonState();
}

class MyDefaultButtonState extends State<MyDefaultButton> {
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = widget.isloading!;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return widget.isloading!
        ? Center(
            child: LoadingAnimationWidget.flickr(
            leftDotColor: primaryColor,
            rightDotColor: const Color(0xFFFF0084),
            size: 50,
          ))
        : InkWell(
            onTap: () => {
              widget.onPressed(),
            },
            child: Container(
              width: 315.w,
              height: widget.height ?? 48.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    widget.Icon ?? 'assets/icons/cart_in_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                      widget.localeText
                          ? widget.btnText!.toUpperCase()
                          : widget.btnText!,
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(
                        color: widget.textColor ?? Color(0xFF21034F),
                        size: 16.sp.round(),
                        weight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          );
  }
}

class CustomTextField extends StatefulWidget {
  final String labelText;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final String? initialValue;
  final bool obscureText;
  final Color? LabelStyle;
  final double? width;
  final String? icon;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? customTextEditingController;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.icon,
    this.LabelStyle,
    this.initialValue,
    this.onSubmitted,
    this.customTextEditingController,
    this.width,
    this.keyboardType = TextInputType.text, // Default to TextInputType.text
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 310.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.customTextEditingController,
            onChanged: widget.onChanged,
            initialValue: widget.initialValue ?? '',
            obscureText: _obscureText,
            onFieldSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            style: primaryTextStyle(
              color: Colors.black,
              size: 14.sp.round(),
              weight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintStyle: primaryTextStyle(
                color: Colors.black,
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              errorStyle: primaryTextStyle(
                color: Colors.red,
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              labelStyle: primaryTextStyle(
                color: widget.LabelStyle ?? const Color(0xFFA6AAC3),
                size: 14.sp.round(),
                weight: FontWeight.w400,
                height: 1,
              ),
              errorText: widget.errorText,
              labelText: widget.labelText,
              prefixIcon: widget.icon != null
                  ? Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        widget.icon!,
                        width: 13.w,
                        height: 13.h,
                      ),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: SvgPicture.asset(
                        _obscureText
                            ? 'assets/icons/eye_closed.svg'
                            : 'assets/icons/eye_open.svg',
                        width: _obscureText ? 20.w : 18.w,
                        height: _obscureText ? 20.h : 18.h,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

Widget DividerSocial() {
  return SizedBox(
    width: 327.w + 16.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 148.w,
          height: 1.h,
          decoration: const BoxDecoration(color: Color(0xFFE3E4E5)),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text('or',
            textAlign: TextAlign.center,
            style: primaryTextStyle(
              color: const Color(0xFF090A0A),
              size: 16.sp.round(),
              weight: FontWeight.w400,
            )),
        SizedBox(
          width: 8.w,
        ),
        Container(
          width: 148.w,
          height: 1.h,
          decoration: const BoxDecoration(color: Color(0xFFE3E4E5)),
        ),
      ],
    ),
  );
}

Widget buttonSocialMedia(
    {txtColor,
    bool? axis,
    required index,
    required text,
    required icon,
    required color,
    required borderColor}) {
  return ShowUp(
      delay: index * 100,
      child: Container(
          width: 327.w,
          height: 48.h,
          decoration: ShapeDecoration(
            color: Color(color),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(borderColor)),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: axis == null || axis == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon,
                      width: 25.w,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      text,
                      style: primaryTextStyle(
                        size: 16.sp.round(),
                        color: Color(txtColor),
                        weight: FontWeight.w500,
                        height: 0.06,
                      ),
                    ),
                    const SizedBox()
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      const SizedBox(),
                      SvgPicture.asset(icon),
                      Text(
                        text,
                        style: primaryTextStyle(
                          size: 16.sp.round(),
                          color: Color(txtColor),
                          weight: FontWeight.w500,
                          height: 0.06,
                        ),
                      ),
                    ])));
}

void buildCustomShowModel(
    {required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsets? padding}) async {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (builder) {
      return Container(
        width: 375.w,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
        child: child,
      );
    },
  );
}

void imagesSourcesShowModel({
  required BuildContext context,
  Function? onCameraPressed,
  Function? onGalleryPressed,
  bool allowMultiple = false,
}) async {
  buildCustomShowModel(
    context: context,
    height: 140.0.h,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Camera //
        Expanded(
          child: TextButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Take a Photo",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            onPressed: onCameraPressed != null
                ? () {
                    onCameraPressed();
                  }
                : null,
          ),
        ),
        Divider(height: 1, color: Colors.grey),
        // Gallery //
        Expanded(
          child: TextButton(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select from Gallery",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            onPressed: onGalleryPressed != null
                ? () {
                    onGalleryPressed();
                  }
                : null,
          ),
        ),
      ],
    ),
  );
}

class ShowUp extends StatefulWidget {
  final Widget? child;
  final int? delay;

  ShowUp({@required this.child, this.delay});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay!), () {
        if (mounted) _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _animController,
    );
  }
}

class SlideToast extends StatefulWidget {
  final Widget toast;

  SlideToast(this.toast);

  @override
  _SlideToastState createState() => _SlideToastState();
}

class _SlideToastState extends State<SlideToast> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetFloat = Tween(begin: Offset(0.0, -0.04), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetFloat,
      child: widget.toast,
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Function()? function;
  final bool? back;

  const CustomAppBar({
    this.title,
    this.actions,
    this.function,
    this.back,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: back ?? true
          ? IconButton(
              icon: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                    "assets/images/forgot_password/Frame 361.svg"),
              ),
              onPressed: () {
                if (function != null) {
                  function!();
                } else {
                  Get.back();
                }
              },
            )
          : const SizedBox(),
      title: Text(title ?? '',
          style: TextStyle(
            color: Color(0xFF1D1F22),
            fontSize: 22.sp,
            fontFamily: GoogleFonts.cormorant().fontFamily,
            fontWeight: FontWeight.w700,
            height: 0,
          )),
      actions: actions ?? [Container()],
      centerTitle: true,
      backgroundColor: const Color(0xffFDFDFD),
    );
  }
}

Widget LoadingWidget(Widget child) {
  return Shimmer.fromColors(
    child: child,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    direction: ShimmerDirection.ttb,
  );
}

String GetMaxChar(String value, int max) {
  return value.toString().length > max
      ? value.toString().substring(0, max) + '..'
      : value.toString();
}

// class CustomNavBar extends StatelessWidget {
//   final NavigationsBarController _tabController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     // HomeController homeController =
//     //     HomeController().initialized ? Get.find() : Get.put(HomeController());
//     return Obx(
//       () {
//         return AnimatedBuilder(
//             animation: homeController.scrollController.value,
//             builder: (BuildContext context, Widget? child) {
//               return AnimatedContainer(
//                 color: Colors.blueGrey,
//                 duration: const Duration(milliseconds: 400),
//                 height: homeController.scrollController.value.hasClients
//                     ? homeController.scrollController.value.position
//                                 .userScrollDirection ==
//                             ScrollDirection.reverse
//                         ? 0
//                         : 95.h
//                     : 95.h,
//                 child: child,
//               );
//             },
//             child: SingleChildScrollView(
//               child: BottomNavigationBar(
//                 type: BottomNavigationBarType.fixed,
//                 backgroundColor: Colors.white,
//                 unselectedItemColor: const Color(0xFFB9B9B9),
//                 selectedItemColor: const Color(0xFF53178C),
//                 showSelectedLabels: false,
//                 showUnselectedLabels: false,
//                 onTap: (index) {
//                   print(
//                       " it have clients ${homeController.scrollController!.value.hasClients}");
//                   _tabController.changeIndex(index);
//                   if (index == 2) {
//                     // تحقق من أنك على علامة التبويب الخاصة بالعربة
//                     // Get.find<CartController>()
//                     //     .fetchCartDetailsFromAPI(); // تحديث بيانات العربة عند النقر على علامة التبويب
//                   }
//                 },
//                 currentIndex: _tabController.selectedIndex.value,
//                 items: [
//                   // Home
//                   _buildBottomNavigationBarItem(0, "Home", "home"),
//                   // Shop
//                   _buildBottomNavigationBarItem(1, "Category", "category"),
//                   // Bag
//                   _buildBottomNavigationBarItem(2, "Cart", "bag"),
//                   // Wishlist
//                   // _buildBottomNavigationBarItem(3, "Wishlist", "wishlist"),
//                   // Profile
//                   _buildBottomNavigationBarItem(3, "Profile", "profile"),
//                 ],
//               ),
//             ));
//       },
//     );
//   }

//   BottomNavigationBarItem _buildBottomNavigationBarItem(
//       int tabIndex, String label, String iconName) {
//     final isSelected = _tabController.selectedIndex.value == tabIndex;
//     return BottomNavigationBarItem(
//       icon: isSelected
//           ? _buildSelectedIcon(tabIndex, iconName, label)
//           : _buildUnselectedIcon(tabIndex, iconName, label),
//       label: label,
//     );
//   }

//   final CartController cartController = Get.put(CartController());

//   Widget _buildSelectedIcon(index, String iconName, String label) {
//     return SizedBox(
//         width: 62.w, // Use .w for width
//         height: 62.h, // Use .h for height
//         child: Stack(children: [
//           Container(
//               height: 62.h, // Use .h for height
//               width: 62.w, // Use .w for width
//               decoration: BoxDecoration(
//                 color: const Color(0xffE8DEF8),
//                 borderRadius: BorderRadius.circular(30.r), // Use .r for radius
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/icons/${iconName}_active.svg",
//                     height: 30.h, // Use .h for height
//                   ),
//                   SizedBox(height: 2.h), // Use .h for height
//                   Text(
//                     label,
//                     style: primaryTextStyle(
//                       weight: FontWeight.w700,
//                       size: 9.sp.round(), // Use .sp for font size
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                 ],
//               )),
//           if (index == 2)
//             Obx(() {
//               return Positioned(
//                 top: -0.h, // Use .h for height
//                 right: 0,
//                 child: cartController.cartItems.isNotEmpty
//                     ? Container(
//                         padding: EdgeInsets.all(4.r), // Use .r for radius
//                         decoration: boxDecorationDefault(
//                             color: primaryColor, shape: BoxShape.circle),
//                         child: FittedBox(
//                           child: Text(
//                             cartController.cartItems.length.toString(),
//                             style: primaryTextStyle(
//                                 size: 8.sp.round(),
//                                 color: Colors.white), // Use .sp for font size
//                           ),
//                         ),
//                       )
//                     : const Offstage(),
//               );
//             }),
//         ]));
//   }

//   Widget _buildUnselectedIcon(index, String iconName, String label) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//             width: 32.w, // Use .w for width
//             height: 32.h, // Use .h for height
//             child: Stack(children: [
//               SvgPicture.asset(
//                 "assets/icons/$iconName.svg",
//                 height: 32.h,
//               ),
//               if (index == 2)
//                 Obx(() {
//                   return Positioned(
//                       top: -5.h, // Use .h for height
//                       right: 0,
//                       child: cartController.cartItems.isNotEmpty
//                           ? Container(
//                               padding: EdgeInsets.all(4.r), // Use .r for radius
//                               decoration: boxDecorationDefault(
//                                   color: primaryColor, shape: BoxShape.circle),
//                               child: FittedBox(
//                                 child: Text(
//                                   cartController.cartItems.length.toString(),
//                                   style: primaryTextStyle(
//                                       size: 8.sp.round(),
//                                       color: Colors
//                                           .white), // Use .sp for font size
//                                 ),
//                               ),
//                             )
//                           : const Offstage());
//                 }),
//             ])),
//         // Use .h for height
//         SizedBox(
//           height: 3.h,
//         ),
//         Container(
//           height: 15.h,
//           child: Text(
//             label,
//             overflow: TextOverflow.ellipsis,
//             style: primaryTextStyle(
//               weight: FontWeight.w700,
//               size: 9.sp.round(), // Use .sp for font size
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

Widget loadingIndicatorWidget() {
  return Center(
      child: LoadingAnimationWidget.flickr(
    leftDotColor: primaryColor,
    rightDotColor: const Color(0xFFFF0084),
    size: 50,
  ));
}

Widget placeHolderWidget() {
  return Lottie.asset("assets/images/placeholder.json");
}

// buildSearchAndFilter(
//     {required BuildContext context,
//     List<ViewProductData>? products,
//     List<Categories>? categories,
//     required bool isSearch,
//     final Function(String)? onSubmitted, // Add this parameter
//     final double height = 65}) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     height: height.h,
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 20.w,
//         ),
//         Flexible(
//           flex: 12,
//           child: SizedBox(
//             child: TextField(
//               readOnly: isSearch ? false : true,
//               onSubmitted: (v) {
//                 if (isSearch) {
//                   onSubmitted!(v);
//                 }
//               },
//               maxLines: 1,
//               onTap: () {
//                 if (isSearch) {
//                   if (products == null) {
//                     HomeController controller = HomeController().initialized
//                         ? Get.find<HomeController>()
//                         : Get.put<HomeController>(HomeController());
//                     products = controller.homeModel.value.product;
//                   }

//                   if (categories == null) {
//                     HomeController controller = HomeController().initialized
//                         ? Get.find<HomeController>()
//                         : Get.put<HomeController>(HomeController());
//                     categories = controller.homeModel.value.categories;
//                   }

//                   Get.to(SearchView(),
//                       arguments: [products, categories],
//                       transition: Transition.fadeIn,
//                       curve: Curves.easeInOut,
//                       duration: Duration(milliseconds: 400));
//                 } else {
//                   if (products == null) {
//                     HomeController controller = HomeController().initialized
//                         ? Get.find<HomeController>()
//                         : Get.put<HomeController>(HomeController());
//                     products = controller.homeModel.value.product;
//                   }

//                   if (categories == null) {
//                     HomeController controller = HomeController().initialized
//                         ? Get.find<HomeController>()
//                         : Get.put<HomeController>(HomeController());
//                     categories = controller.homeModel.value.categories;
//                   }

//                   Get.to(SearchView(),
//                       arguments: [products, categories],
//                       transition: Transition.fadeIn,
//                       curve: Curves.easeInOut,
//                       duration: Duration(milliseconds: 400));
//                 }

//                 // Get.toNamed(
//                 //   Routes.SEARCH,
//                 //   arguments: [products, categories],
//                 // );
//                 // Get.toNamed(()=> Pages., arguments: controller.homeModel.value.product);
//               },
//               style: primaryTextStyle(
//                 color: Colors.black,
//                 size: 14.sp.round(),
//                 weight: FontWeight.w400,
//               ),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 17.h),
//                 //Imp Line

//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey[300]!, width: 2)),

//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(color: Colors.grey[300]!, width: 2)),
//                 hintStyle: primaryTextStyle(
//                   color: Colors.black,
//                   size: 14.sp.round(),
//                   weight: FontWeight.w400,
//                   height: 1,
//                 ),
//                 errorStyle: primaryTextStyle(
//                   color: Colors.red,
//                   size: 14.sp.round(),
//                   weight: FontWeight.w400,
//                   height: 1,
//                 ),
//                 labelStyle: primaryTextStyle(
//                   color: Colors.grey[400],
//                   size: 14.sp.round(),
//                   weight: FontWeight.w400,
//                   height: 1,
//                 ),
//                 labelText: "Search Clothes...",
//                 prefixIcon: IconButton(
//                   icon: Padding(
//                     padding: EdgeInsets.only(left: 10.w),
//                     child: SvgPicture.asset(
//                       'assets/icons/search.svg',
//                       width: 23.w,
//                       height: 23.h,
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
//                 // suffixIcon: IconButton(
//                 //   icon: Padding(
//                 //     padding: EdgeInsets.only(right: 5.w),
//                 //     child: SvgPicture.asset(
//                 //       'assets/icons/camera.svg',
//                 //       width: 23.w,
//                 //       height: 23.h,
//                 //     ),
//                 //   ),
//                 //   onPressed: () {},
//                 // ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 15.w,
//         ),
//         InkWell(
//           onTap: () {
//             showMaterialModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.transparent,
//               expand: false,
//               builder: (context) => BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                   child: buildFilterBottomSheet(
//                       context: context, comingProducts: products)),
//             );
//           },
//           child: Container(
//             child: SvgPicture.asset(
//               "assets/images/home/Filter.svg",
//               height: 50.h,
//               width: 50.w,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: 15.w,
//         )
//       ],
//     ),
//   );
// }

class VideoLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.0,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

class BottomWaveClipperCart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // رسم الخطوط الجانبية والزوايا العلوية المستقيمة
    path.lineTo(0, size.height - 20); // ترك مساحة للانحناء من الأسفل

    // إضافة المنحنى في الجزء السفلي
    var firstControlPoint =
        Offset(size.width * 0.5, size.height + 20); // نقطة التحكم للانحناء
    var firstEndPoint = Offset(size.width, size.height - 20); // نهاية المنحنى

    // رسم المنحنى السفلي
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // رسم الخط السفلي المنحني
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // رسم الجزء العلوي المستقيم
    path.lineTo(0.0, size.height - 50); // تقليل ارتفاع المنحنى

    // التحكم في المنحنى في الأسفل
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);

    // إنشاء منحنى باستخدام النقطة التحكم والنهاية
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // رسم الخط المستقيم إلى الأعلى
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class buildProductCard extends StatefulWidget {
//   buildProductCard(
//       {super.key, required this.product, this.isInWishlist = false});

//   final ViewProductData product;
//   bool isInWishlist;

//   @override
//   State<buildProductCard> createState() => _buildCardProductState();
// }

// class _buildCardProductState extends State<buildProductCard> {
//   HomeController homeController = Get.put<HomeController>(HomeController());

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 5),
//           ],
//         ),
//         child: widget.product.image != null
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //this column is for product image and details
//                 children: [
//                   //this column is for product image and details
//                   Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           print("new product name 22 ${widget.product.name}");
//                           if (Get.isRegistered<ProductController>()) {
//                             print("yes it's registeded");
//                             Get.delete<ProductController>();
//                           }
//                           Get.toNamed(Routes.PRODUCT,
//                               arguments: widget.product,
//                               preventDuplicates: false);
//                         },
//                         child: CachedNetworkImage(
//                           imageUrl: widget.product.image!,
//                           width: 175.w,
//                           height: 210.h,
//                           fit: BoxFit.cover,
//                           placeholder: (ctx, v) {
//                             return placeHolderWidget();
//                           },
//                         ),
//                       ),
//                       Obx(() {
//                         return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: InkWell(
//                               onTap: () {
//                                 homeController.wishlistProductIds
//                                         .contains(widget.product.id!)
//                                     ? homeController
//                                         .removeFromWishlist(widget.product.id!)
//                                     : homeController
//                                         .addToWishlist(widget.product.id!);
//                               },
//                               child: homeController.wishlistProductIds
//                                       .contains(widget.product.id!)
//                                   ? ShowUp(
//                                       delay: 500,
//                                       child: AvatarGlow(
//                                         curve: Curves.fastOutSlowIn,
//                                         glowColor: Colors.purpleAccent,
//                                         repeat: false,
//                                         child: SvgPicture.asset(
//                                           "assets/images/home/wishlisted.svg",
//                                           width: 33.w,
//                                           height: 33.h,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     )
//                                   : ShowUp(
//                                       delay: 500,
//                                       child: SvgPicture.asset(
//                                         "assets/images/home/add_to_wishlist.svg",
//                                         width: 33.w,
//                                         height: 33.h,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                             ));
//                       }),
//                     ],
//                   ),
//                   // SizedBox(
//                   //   height: 3.h,
//                   // ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 7.w),
//                     child: GestureDetector(
//                       onTap: () {
//                         print(
//                             "the sent product model is ${widget.product.sizes}");
//                         Get.toNamed(
//                           Routes.PRODUCT,
//                           arguments: widget.product,
//                         );
//                       },
//                       child: Container(
//                         width: 150.w,
//                         child: Padding(
//                             padding: EdgeInsets.only(left: 5.w),
//                             child: Text(
//                               widget.product.name!,
//                               overflow: TextOverflow.ellipsis,
//                               style: primaryTextStyle(
//                                   weight: FontWeight.w700,
//                                   size: 16.sp.round(),
//                                   color: Colors.black),
//                             )),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   height: 1.h,
//                   // ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 7.w),
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.toNamed(
//                           Routes.PRODUCT,
//                           arguments: widget.product,
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.only(left: 5.w),
//                         width: 150.w,
//                         child: Text(
//                           widget.product.description!,
//                           overflow: TextOverflow.ellipsis,
//                           style: primaryTextStyle(
//                               weight: FontWeight.w300,
//                               size: 14.sp.round(),
//                               color: Color(0xff9B9B9B)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   height: 1.h,
//                   // ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 7.w),
//                     child: GestureDetector(
//                       onTap: () {
//                         Get.toNamed(
//                           Routes.PRODUCT,
//                           arguments: widget.product,
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 5.w),
//                         child: Text(
//                           "\$ ${widget.product.price} ",
//                           style: primaryTextStyle(
//                               weight: FontWeight.w600,
//                               size: 15.sp.round(),
//                               color: const Color(0xff370269)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   height: 6.h,
//                   // ),
//                   widget.isInWishlist
//                       ? GestureDetector(
//                           onTap: () {
//                             //todo
//                             // take Product arguments from here
//                             ViewProductData product = widget.product;

//                             //todo
//                             //Nav To Cart Screen
//                             //Setted to Main Screen for now
//                             Get.toNamed(Routes.MAIN);
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(left: 10.w),
//                             padding: EdgeInsets.only(left: 10.w),
//                             height: 30.h,
//                             width: 125.w,
//                             decoration: BoxDecoration(
//                                 color: Color(0xff21034F),
//                                 borderRadius: BorderRadius.circular(35.sp)),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.shopping_cart_outlined,
//                                   color: Colors.white,
//                                   size: 12.sp,
//                                 ),
//                                 SizedBox(
//                                   width: 4.w,
//                                 ),
//                                 Text(
//                                   "ADD TO CART",
//                                   style: primaryTextStyle(
//                                       weight: FontWeight.w700,
//                                       color: Colors.white,
//                                       size: 9.sp.round()),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       : const SizedBox(),
//                 ],
//               )
//             : placeHolderWidget(),
//       ),
//     );
//   }
// }

buildProductShowAll(getProductsInSection) {
  return GestureDetector(
    onTap: () {
      getProductsInSection();
    },
    child: Container(
      margin: EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: -3, blurRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 175.w,
            height: 190.h,
            child: placeHolderWidget(),
          ),
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Text(
                      "SHOW ALL",
                      overflow: TextOverflow.ellipsis,
                      style: primaryTextStyle(
                          weight: FontWeight.w700,
                          size: 16.sp.round(),
                          color: Colors.grey[500]),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.grey[500])
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 5.w),
            width: 150.w,
            child: Text(
              "",
              overflow: TextOverflow.ellipsis,
              style: primaryTextStyle(
                  weight: FontWeight.w300,
                  size: 14.sp.round(),
                  color: Color(0xff9B9B9B)),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Text(
              " ",
              style: primaryTextStyle(
                  weight: FontWeight.w600,
                  size: 15.sp.round(),
                  color: Color(0xff370269)),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    ),
  );
}

enum FilterTypeEnum {
  Colors,
  Brands,
  Style,
  Season,
  Materials,
  Sizes,
  Price,
  Collection

  // Add more animation states as needed
}

class CustomDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final EdgeInsetsGeometry margin;

  CustomDivider({
    this.thickness = 2.0,
    this.color = Colors.grey,
    this.margin = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        thickness: thickness,
        color: color,
      ),
    );
  }
}

// List<Widget> buildChildren(FilterTypeEnum filterName,
//     CustomSearchController my_search_controller, context) {
//   switch (filterName) {
//     case FilterTypeEnum.Sizes:
//       return [
//         Text(
//           "Size",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 15,
//                 crossAxisSpacing: 10,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: (1 / .8),
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     my_search_controller
//                         .addOrRemoveSize(my_search_controller.sizes[index]);
//                   },
//                   child: Obx(() {
//                     return Container(
//                       padding: EdgeInsets.all(2.w),
//                       width: 70.w,
//                       height: 40.h,
//                       decoration: BoxDecoration(
//                           color: my_search_controller.selectedSizes
//                                   .contains(my_search_controller.sizes[index])
//                               ? Color(0xffE7D3FF)
//                               : Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10.sp)),
//                       child: Center(
//                         child: Text(
//                           overflow: TextOverflow.ellipsis,
//                           my_search_controller.sizes[index],
//                           style: primaryTextStyle(
//                               size: 10.sp.round(), color: Colors.black),
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               },
//               itemCount: my_search_controller.sizes.length,
//             );
//           }),
//           // Add more widgets as needed
//         ),
//       ];

//     case FilterTypeEnum.Colors:
//       return [
//         Text(
//           "Color",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 40,
//                 crossAxisSpacing: 24,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: 0.75,
//               ),
//               itemBuilder: (context, index) {
//                 final Color colorFromHex =
//                     HexColor.fromHex(my_search_controller.colors[index].hex!);

//                 return index != 4
//                     ? GestureDetector(
//                         onTap: () {
//                           my_search_controller.addOrRemoveColor(
//                               my_search_controller.colors[index]);
//                         },
//                         child: Obx(() {
//                           return Container(
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                     color: my_search_controller.selectedColors
//                                             .contains(my_search_controller
//                                                 .colors[index])
//                                         ? Colors.black
//                                         : Colors.grey[300]!,
//                                     width: 4.w),
//                                 color: Colors.grey[200]),
//                             child: Container(
//                               height: 25.h,
//                               width: 25.w,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(colorFromHex.value)),
//                             ),
//                           );
//                         }),
//                       )
//                     : InkWell(
//                         onTap: () {
//                           my_search_controller.changeLength(
//                               my_search_controller.colorFullLength);
//                         },
//                         child: Icon(my_search_controller.colorFullLength.value
//                             ? Icons.keyboard_arrow_up_outlined
//                             : Icons.keyboard_arrow_down_outlined),
//                       );
//               },
//               itemCount: my_search_controller.colorFullLength.value
//                   ? my_search_controller.colors.length
//                   : 5,
//             );
//           }),
//           // Add more widgets as needed
//         )
//       ];
//     case FilterTypeEnum.Brands:
//       return [
//         Text(
//           "Brands",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 40,
//                 crossAxisSpacing: 24,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: 1.05,
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     my_search_controller
//                         .addOrRemoveBrand(my_search_controller.brands[index]);
//                   },
//                   child: Obx(() {
//                     return Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             border: Border.all(
//                                 width: 3.w,
//                                 color: my_search_controller.selectedBrands
//                                         .contains(
//                                             my_search_controller.brands[index])
//                                     ? Color(0xffE7D3FF)
//                                     : Colors.grey[300]!)),
//                         child: CachedNetworkImage(
//                           imageUrl: my_search_controller.brands[index].image!,
//                           fit: BoxFit.cover,
//                         ));
//                   }),
//                 );
//               },
//               itemCount: my_search_controller.brands.length,
//             );
//           }),
//           // Add more widgets as needed
//         )
//       ];

//     case FilterTypeEnum.Style:
//       return [
//         Text(
//           "Styles",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return my_search_controller.styles.isEmpty
//                 ? Center(
//                     child: Text(
//                       "No Styles Yet..",
//                       style: primaryTextStyle(
//                           size: 20.sp.round(), color: Colors.black),
//                     ),
//                   )
//                 : GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 5,
//                       mainAxisSpacing: 15,
//                       crossAxisSpacing: 10,
//                       // width / height: fixed for *all* items
//                       childAspectRatio: (1 / .8),
//                     ),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           my_search_controller.addOrRemoveStyle(
//                               my_search_controller.styles[index]);
//                         },
//                         child: Obx(() {
//                           return Container(
//                             padding: EdgeInsets.all(8.w),
//                             width: 70.w,
//                             height: 40.h,
//                             decoration: BoxDecoration(
//                                 color: my_search_controller.selectedStyles
//                                         .contains(
//                                             my_search_controller.styles[index])
//                                     ? Color(0xffE7D3FF)
//                                     : Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(10.sp)),
//                             child: Center(
//                               child: Text(
//                                 overflow: TextOverflow.ellipsis,
//                                 my_search_controller.styles[index].name!,
//                                 style: primaryTextStyle(
//                                     size: 10.sp.round(),
//                                     color: Colors.black,
//                                     weight: FontWeight.w500),
//                               ),
//                             ),
//                           );
//                         }),
//                       );
//                     },
//                     itemCount: my_search_controller.styles.length,
//                   );
//           }),
//           // Add more widgets as needed
//         )
//       ];

//     case FilterTypeEnum.Season:
//       return [
//         Text(
//           "Season",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 15,
//                 crossAxisSpacing: 10,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: (1 / .8),
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     my_search_controller
//                         .addOrRemoveSeason(my_search_controller.seasons[index]);
//                   },
//                   child: Obx(() {
//                     return Container(
//                       padding: EdgeInsets.all(6.w),
//                       width: 70.w,
//                       height: 40.h,
//                       decoration: BoxDecoration(
//                           color: my_search_controller.selectedSeasons
//                                   .contains(my_search_controller.seasons[index])
//                               ? Color(0xffE7D3FF)
//                               : Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10.sp)),
//                       child: Center(
//                         child: Text(
//                           overflow: TextOverflow.ellipsis,
//                           my_search_controller.seasons[index],
//                           style: primaryTextStyle(
//                               size: 10.sp.round(),
//                               color: Colors.black,
//                               weight: FontWeight.w500),
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               },
//               itemCount: my_search_controller.seasons.length,
//             );
//           }),
//           // Add more widgets as needed
//         ),
//       ];

//     case FilterTypeEnum.Materials:
//       return [
//         Text(
//           "Materials",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 15,
//                 crossAxisSpacing: 10,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: (1 / .8),
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     my_search_controller.addOrRemoveMaterial(
//                         my_search_controller.materials[index]);
//                   },
//                   child: Obx(() {
//                     return Container(
//                       padding: EdgeInsets.all(6.w),
//                       width: 70.w,
//                       height: 40.h,
//                       decoration: BoxDecoration(
//                           color: my_search_controller.selectedMaterials
//                                   .contains(
//                                       my_search_controller.materials[index])
//                               ? Color(0xffE7D3FF)
//                               : Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10.sp)),
//                       child: Center(
//                         child: Text(
//                           overflow: TextOverflow.ellipsis,
//                           my_search_controller.materials[index].name!,
//                           style: primaryTextStyle(
//                               size: 10.sp.round(),
//                               color: Colors.black,
//                               weight: FontWeight.w500),
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               },
//               itemCount: my_search_controller.materials.length,
//             );
//           }),
//           // Add more widgets as needed
//         ),
//       ];

//     case FilterTypeEnum.Price:
//       return [
//         Text(
//           "Price",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             child: Container(
//               height: 130.h,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Obx(() {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               keyboardType: TextInputType.number,
//                               controller:
//                                   my_search_controller.minPriceController.value,
//                               onChanged: (val) {
//                                 String minPriceText = my_search_controller
//                                     .minPriceController.value.text;

//                                 String maxPriceController = my_search_controller
//                                     .maxPriceController.value.text;

//                                 double minDouble =
//                                     double.tryParse(minPriceText) == null
//                                         ? 0
//                                         : double.tryParse(minPriceText)!;

//                                 my_search_controller.setNewValue(RangeValues(
//                                   minDouble,
//                                   double.parse(maxPriceController.toString()),
//                                 ));
//                               },
//                               maxLines: 1,
//                               style: primaryTextStyle(
//                                 color: Colors.black,
//                                 size: 14.sp.round(),
//                                 weight: FontWeight.w400,
//                               ),
//                               decoration: InputDecoration(
//                                 contentPadding:
//                                     EdgeInsets.symmetric(vertical: 17.h),
//                                 //Imp Line

//                                 enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: Colors.grey[300]!, width: 2)),

//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: Colors.grey[300]!, width: 2)),
//                                 hintStyle: primaryTextStyle(
//                                   color: Colors.black,
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 errorStyle: primaryTextStyle(
//                                   color: Colors.red,
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 labelStyle: primaryTextStyle(
//                                   color: Colors.grey[400],
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 labelText: "Min Price..",

//                                 prefixIcon: IconButton(
//                                   icon: Padding(
//                                       padding: EdgeInsets.only(left: 10.w),
//                                       child: Icon(Icons.price_change)),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           Expanded(
//                             child: TextField(
//                               keyboardType: TextInputType.number,
//                               controller:
//                                   my_search_controller.maxPriceController.value,
//                               onChanged: (val) {
//                                 String minPriceText = my_search_controller
//                                     .minPriceController.value.text;

//                                 String maxPriceText = my_search_controller
//                                     .maxPriceController.value.text;

//                                 double maxDouble =
//                                     double.tryParse(maxPriceText) == null
//                                         ? 0
//                                         : double.tryParse(maxPriceText)!;

//                                 my_search_controller.setNewValue(RangeValues(
//                                     double.parse(minPriceText.toString()),
//                                     maxDouble));
//                               },
//                               maxLines: 1,
//                               style: primaryTextStyle(
//                                 color: Colors.black,
//                                 size: 14.sp.round(),
//                                 weight: FontWeight.w400,
//                               ),
//                               decoration: InputDecoration(
//                                 contentPadding:
//                                     EdgeInsets.symmetric(vertical: 17.h),
//                                 //Imp Line

//                                 enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: Colors.grey[300]!, width: 2)),

//                                 focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide(
//                                         color: Colors.grey[300]!, width: 2)),
//                                 hintStyle: primaryTextStyle(
//                                   color: Colors.black,
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 errorStyle: primaryTextStyle(
//                                   color: Colors.red,
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 labelStyle: primaryTextStyle(
//                                   color: Colors.grey[400],
//                                   size: 14.sp.round(),
//                                   weight: FontWeight.w400,
//                                   height: 1,
//                                 ),
//                                 labelText: "Max Price..",
//                                 prefixIcon: IconButton(
//                                   icon: Padding(
//                                       padding: EdgeInsets.only(left: 10.w),
//                                       child: Icon(Icons.price_change)),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//                   ),
//                   Expanded(
//                     child: Obx(() {
//                       return Container(
//                         child: RangeSlider(
//                             inactiveColor: Colors.grey[300],
//                             activeColor: Colors.black,
//                             min: my_search_controller.minPriceApi.value,
//                             max: my_search_controller.maxPriceApi.value,
//                             values: my_search_controller.settedValue.value,
//                             onChanged: (value) {
//                               my_search_controller.setNewValue(value);

//                               print("new value is ${value}");
//                             }),
//                       );
//                     }),
//                   )
//                 ],
//               ),
//             )
//             // Add more widgets as needed
//             ),
//       ];

//     case FilterTypeEnum.Collection:
//       return [
//         Text(
//           "Collections",
//           style: primaryTextStyle(
//               size: 16.sp.round(),
//               color: Colors.black,
//               weight: FontWeight.w500),
//         ),
//         SizedBox(
//           height: 15.h,
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 0.w),
//           child: Obx(() {
//             return GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 40,
//                 crossAxisSpacing: 24,
//                 // width / height: fixed for *all* items
//                 childAspectRatio: 1.05,
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     my_search_controller.addOrRemoveCollection(
//                         my_search_controller.collections[index]);
//                   },
//                   child: Obx(() {
//                     return Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             border: Border.all(
//                                 width: 4.w,
//                                 color: my_search_controller.selectedCollections
//                                         .contains(my_search_controller
//                                             .collections[index])
//                                     ? Colors.black
//                                     : Colors.grey[300]!)),
//                         child: Column(
//                           children: [
//                             Expanded(
//                               flex: 8,
//                               child: CachedNetworkImage(
//                                 imageUrl: my_search_controller
//                                     .collections[index].image!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   overflow: TextOverflow.ellipsis,
//                                   my_search_controller.collections[index].name!,
//                                   style: primaryTextStyle(size: 4.sp.round()),
//                                 ))
//                           ],
//                         ));
//                   }),
//                 );
//               },
//               itemCount: my_search_controller.collections.length,
//             );
//           }),
//           // Add more widgets as needed
//         )
//       ];
//     // Handle other animation states similarly
//     default:
//       return []; // Return an empty list if no match
//   }
// }

// buildFilterBottomSheet(
//     {List<ViewProductData>? comingProducts, required BuildContext context}) {
//   List<ViewProductData> filteredProducts = [];
//   CustomSearchController my_search_controller =
//       CustomSearchController().initialized
//           ? Get.find<CustomSearchController>()
//           : Get.put(CustomSearchController());

//   final DraggableScrollableController sheetController =
//       DraggableScrollableController();

//   final ScrollController scrollController = ScrollController();

//   // print("before setting sized ${comingProduct.sizes}");

//   return Container(
//       height: MediaQuery.of(context).size.height - 50.h,
//       clipBehavior: Clip.hardEdge,
//       decoration: const BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 1.0,
//           ),
//           BoxShadow(color: Colors.white70, offset: Offset(0, -1)),
//           BoxShadow(color: Colors.white70, offset: Offset(0, 1)),
//           BoxShadow(color: Colors.white70, offset: Offset(-1, -1)),
//         ],
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white12,
//           automaticallyImplyLeading: false,
//           title: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child:
//                 Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//               InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: Container(
//                   height: 40.h,
//                   width: 40.w,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4),
//                         spreadRadius: 3,
//                         blurRadius: 5,
//                         offset: Offset(0, 1), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: SvgPicture.asset(
//                       "assets/images/forgot_password/BackBTN.svg"),
//                 ),
//               ),
//               Expanded(
//                 flex: 8,
//                 child: Center(
//                   child: Text("Filters",
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           fontFamily: GoogleFonts.cormorant().fontFamily,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 22.sp)),
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       my_search_controller.clearSelectedFilters();
//                     },
//                     child: Text("Reset",
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontFamily: GoogleFonts.cormorant().fontFamily,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.orange,
//                             fontSize: 18.sp)),
//                   ),
//                 ),
//               ),
//             ]),
//           ),
//         ),
//         body: CustomScrollView(controller: scrollController, slivers: [
//           SliverList.list(
//             children: [
//               Obx(() {
//                 return Container(
//                   height: MediaQuery.of(context).size.height - 200.h,
//                   child: my_search_controller.isFilterLoading.value
//                       ? loadingIndicatorWidget()
//                       : SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 20.h,
//                                   ),

//                                   ///////////////////Price//////////////////////////////
//                                   buildFilterItem(FilterTypeEnum.Price, context,
//                                       my_search_controller),

//                                   ///////////////////Color//////////////////////////////
//                                   buildFilterItem(FilterTypeEnum.Colors,
//                                       context, my_search_controller),
//                                   ///////////////////Brand//////////////////////////////

//                                   buildFilterItem(FilterTypeEnum.Brands,
//                                       context, my_search_controller),
//                                   ///////////////////Styles//////////////////////////////

//                                   buildFilterItem(FilterTypeEnum.Style, context,
//                                       my_search_controller),

//                                   ///////////////////Collections//////////////////////////////
//                                   buildFilterItem(FilterTypeEnum.Collection,
//                                       context, my_search_controller),

//                                   ///////////////////Season//////////////////////////////

//                                   buildFilterItem(FilterTypeEnum.Season,
//                                       context, my_search_controller),
//                                   ///////////////////Materials//////////////////////////////
//                                   buildFilterItem(FilterTypeEnum.Materials,
//                                       context, my_search_controller),

//                                   ///////////////////Sizes//////////////////////////////
//                                   buildFilterItem(FilterTypeEnum.Sizes, context,
//                                       my_search_controller),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                 );
//               }),
//             ],
//           ),
//         ]),
//         bottomNavigationBar: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: ElevatedButton(
//             style: ButtonStyle(
//               minimumSize: WidgetStateProperty.all(
//                   Size(MediaQuery.of(context).size.width - 200.w, 50.h)),
//               backgroundColor: WidgetStateProperty.all(Color(0xff21034F)),
//             ),
//             onPressed: () {
//               // Handle button press
//               int _sizeIndex = 0;
//               int _materialIndex = 0;
//               int _styleIndex = 0;
//               int _colorIndex = 0;
//               int _seasonIndex = 0;
//               int _brandIndex = 0;
//               int _collectionIndex = 0;
//               var payload = {};

//               //handle price
//               payload['min_price'] =
//                   my_search_controller.minPriceController.value.text.toString();
//               payload['max_price'] =
//                   my_search_controller.maxPriceController.value.text.toString();

//               //handle size

//               //handle material
//               for (var material in my_search_controller.selectedMaterials) {
//                 payload['material_ids[${_materialIndex}]'] =
//                     material.id.toString();
//                 _materialIndex++;
//               }

//               //handle styles
//               for (var style in my_search_controller.selectedStyles) {
//                 payload['style_ids[${_styleIndex}]'] = style.id.toString();
//                 _styleIndex++;
//               }

//               //handle colors
//               for (var color in my_search_controller.selectedColors) {
//                 payload['colors[${_colorIndex}]'] = color.name.toString();
//                 _colorIndex++;
//               }

//               //handle seasons
//               for (var season in my_search_controller.selectedSeasons) {
//                 payload['seasons[${_seasonIndex}]'] = season.toString();
//                 _seasonIndex++;
//               }

//               //handle brands
//               for (var brand in my_search_controller.selectedBrands) {
//                 payload['brand_ids[${_brandIndex}]'] = brand.id.toString();
//                 _brandIndex++;
//               }

//               //handle collections
//               for (var collection in my_search_controller.selectedCollections) {
//                 payload['collection_ids[${_collectionIndex}]'] =
//                     collection.id.toString();
//                 _collectionIndex++;
//               }

//               my_search_controller.getProductsInSection(
//                   sectionName: "Filter", payload: payload);

//               _sizeIndex = 0;
//               _materialIndex = 0;
//               _styleIndex = 0;
//               _colorIndex = 0;
//               _seasonIndex = 0;
//               _brandIndex = 0;
//               _collectionIndex = 0;

//               payload = {};
//               my_search_controller.clearSelectedFilters();
//               Get.to(() => const ResultView(),
//                   transition: Transition.fadeIn,
//                   curve: Curves.easeInOut,
//                   duration: const Duration(milliseconds: 400));
//             },
//             child: const Text(
//               'Show Items',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ));
// }

// buildFilterItem(FilterTypeEnum filterName, context,
//     CustomSearchController my_search_controller) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 15.w),
//     child: Container(
//       width: MediaQuery.of(context).size.width,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 5.h,
//             ),
//             ...buildChildren(filterName, my_search_controller, context),
//             SizedBox(
//               height: 5.h,
//             ),
//             CustomDivider(thickness: 0.5, color: Colors.grey),
//           ],
//         ),
//       ),
//     ),
//   );
// }

final AuthController Authcontroller = Get.put(AuthController());

Widget socialMediaPlaceHolder() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ShowUp(
          delay: 200,
          child: SvgPicture.asset(
            LOGO,
            width: 124.w,
            height: 82.h,
            fit: BoxFit.cover,
          )),
      SizedBox(
        height: 32.h,
      ),
      Text(
        'Please log in or sign up to continue shopping',
        textAlign: TextAlign.center,
        style: secondaryTextStyle(
          color: const Color(0xFFCDCFD0),
          size: 16.sp.round(),
          weight: FontWeight.w400,
        ),
      ),
      SizedBox(
        height: 32.h,
      ),
      InkWell(
          onTap: () {
            Authcontroller.googleLogin();
          },
          child: buttonSocialMedia(
              icon: 'assets/icons/google.svg',
              index: 0,
              text: 'Continue with Google',
              color: 0xffFFFFFF,
              txtColor: 0xFF090A0A,
              borderColor: 0xFFE3E4E5)),
      if (GetPlatform.isIOS)
        SizedBox(
          height: 16.h,
        ),
      // buttonSocialMedia(
      //     icon: 'assets/icons/facebook.svg',
      //     index: 1,
      //     text: 'Continue with Facebook',
      //     color: 0xFF0066DA,
      //     txtColor: 0xffFFFFFF,
      //     borderColor: 0xFF0066DA),
      if (GetPlatform.isIOS)
        InkWell(
            onTap: () {
              print('dsadsa');
              Authcontroller.appleLogin();
            },
            child: buttonSocialMedia(
                icon: 'assets/icons/apple.svg',
                index: 2,
                text: 'Continue with Apple',
                color: 0xFF090A0A,
                txtColor: 0xffFFFFFF,
                borderColor: 0xFFE3E4E5)),
      SizedBox(
        height: 35.h,
      ),
      DividerSocial(),
      SizedBox(
        height: 34.h,
      ),
      InkWell(
          onTap: () {
            Authcontroller.socialView.value = false;
            Get.off(LoginView());
          },
          child: buttonSocialMedia(
              icon: 'assets/icons/login.svg',
              index: 3,
              text: 'Sign in with password',
              color: 0xFFD4B0FF,
              txtColor: 0xFF21034F,
              borderColor: 0xFFD4B0FF)),
      SizedBox(
        height: 34.h,
      ),
      ShowUp(
          delay: 500,
          child: InkWell(
            onTap: () {
              Get.off(() => RegisterView());
            },
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Don’t have an account?',
                    style: primaryTextStyle(
                      color: const Color(0xFFCDCFD0),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: primaryTextStyle(
                      color: const Color(0xFF979C9E),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign up',
                    style: primaryTextStyle(
                      color: const Color(0xFFAA61FF),
                      size: 16.sp.round(),
                      weight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )),
    ],
  );
}
