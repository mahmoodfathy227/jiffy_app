import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/theme/app_theme.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/profile/views/update_profile.dart';

import '../../auth/views/register_view.dart';
import '../controllers/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.put(ProfileController());

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return controller.isAuth.value
            ? SingleChildScrollView(
                child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 365.h,
                        child: Stack(
                          children: [
                            CustomAppBar(
                              myFunction: () {},
                              title: "Profile",
                            ),
                            controller.isLoading.value
                                ? LoadingWidget(_buildProfileHeader(context))
                                : Positioned(
                                    bottom: 20.h,
                                    left: 0,
                                    right: 0,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: _buildProfileHeader(context),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 324.w,
                        padding:
                            EdgeInsetsDirectional.symmetric(vertical: 10.h),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                              spreadRadius: -10,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 276.w,
                              child: Text(
                                'Preferences & Support',
                                style: secondaryTextStyle(
                                  color: Color(0xFF20003D),
                                  size: 20.sp.round(),
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _buildMenuItem(
                                'address.svg', 'Address', () {}, 19, 1),
                            _buildMenuItem('order.svg', 'Orders', () {}, 19, 3),
                            _buildMenuItem('rate.svg', 'Rate this app', () {
                              if (GetPlatform.isAndroid) {
                                _launchURL(
                                    'https://play.google.com/store/apps/details?id=maryana.genixs.com.maryana');
                              } else if (GetPlatform.isIOS) {
                                _launchURL(
                                    'https://apps.apple.com/hk/app/mariannella/id6608972125?l=en-GB');
                              }
                            }, 19, 4),
                            _buildMenuItem('terms.svg', 'Terms of Use', () {
                              _launchURL(
                                  'https://mariannella.genixarea.pro/terms.html');
                            }, 19, 5),
                            _buildMenuItem('privacy.svg', 'Privacy Policy', () {
                              _launchURL(
                                  'https://mariannella.genixarea.pro/privacy.html');
                            }, 19, 6),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ShowUp(
                        delay: 200,
                        child: InkWell(
                          onTap: () {
                            _showLogoutConfirmation(context, controller);
                          },
                          child: Container(
                            width: 324.w,
                            height: 52.h,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFFF4141)),
                                borderRadius: BorderRadius.circular(42),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 100,
                                  offset: Offset(0, 4),
                                  spreadRadius: -10,
                                )
                              ],
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    SvgPicture.asset(
                                      'assets/images/profile/logout.svg',
                                      width: 19.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Log out',
                                      style: secondaryTextStyle(
                                        color: const Color(0xFFFF4141),
                                        size: 14.sp.round(),
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ))
            : Center(
                child: socialMediaPlaceHolder(),
              );
      }),
    );
  }

  void _showLogoutConfirmation(
      BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                  padding: EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(color: Colors.black12),
                      shape: BoxShape.circle),
                  child: Icon(Icons.logout_outlined,
                      color: Colors.white, size: 24.sp)),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300.w,
                      child: Text('Are you sure you want to log out?',
                          style: primaryTextStyle(
                              size: 18.sp.round(), weight: FontWeight.w600))),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        controller.Logout();
                        Get.back(); // Use Get.back() instead of Navigator.pop(context)
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('Yes',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 150.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text('No',
                                style: primaryTextStyle(
                                    size: 16.sp.round(),
                                    color: Colors.white,
                                    weight: FontWeight.bold))),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildProfileHeader(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: controller.isLoading.value ? 0 : 1,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        )),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.h), // لضبط المسافة العلوية للصورة
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 16.w),
              height: 169.h,
              width: 324.w,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                    spreadRadius: -10,
                  )
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 70.h), // لإضافة فراغ يعادل نصف حجم الصورة
                  Obx(
                    () => Text(
                      GetMaxChar(
                          '${controller.userModel.value.firstName} ${controller.userModel.value.lastName}',
                          13),
                      style: secondaryTextStyle(
                        color: Color(0xFF4F0099),
                        size: 16,
                        weight: FontWeight.w700,
                        height: 0.09,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Obx(() {
                    return controller.userModel.value.email.isNotEmpty
                        ? Text(
                            GetMaxChar(controller.userModel.value.email, 25),
                            style: secondaryTextStyle(
                              color: Colors.black,
                              size: 12.sp.round(),
                              weight: FontWeight.w300,
                              letterSpacing: -0.12,
                            ),
                          )
                        : SizedBox();
                  }),
                  SizedBox(height: 10.h),

                  ShowUp(
                      delay: 200,
                      child: InkWell(
                          onTap: () {
                            Get.to(() => ProfileUpdate());
                          },
                          child: Container(
                              width: 117.w,
                              height: 34.h,
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(1.00, 0.04),
                                  end: Alignment(-1, -0.04),
                                  colors: [
                                    Color(0xFF6900CC),
                                    Color(0xFF20003D)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/images/profile/edit.png',
                                    width: 16.w,
                                  ),
                                  Text(
                                    'Edit Profile',
                                    style: secondaryTextStyle(
                                      color: Colors.white,
                                      size: 14.sp.round(),
                                      weight: FontWeight.w500,
                                      letterSpacing: -0.41,
                                    ),
                                  ),
                                ],
                              )))),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3F000000), // لون الظل
                      blurRadius: 20, // نصف قطر التمويه للظل
                      offset: Offset(0, 4), // انزياح الظل
                      spreadRadius: 0, // انتشار الظل
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 52.r,
                  backgroundImage: controller.userModel.value.photo == null ||
                          controller.userModel.value.photo!.isEmpty
                      ? const AssetImage(
                          'assets/images/profile/profile_placeholder.png')
                      : null,
                  child: controller.userModel.value.photo == null ||
                          controller.userModel.value.photo!.isEmpty
                      ? null
                      : CachedNetworkImage(
                          imageUrl: controller.userModel.value.photo!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 52.r,
                            backgroundImage: const AssetImage(
                                'assets/images/profile/profile_placeholder.png'),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16.r,
                              ),
                            ),
                          ),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 52.r,
                            backgroundImage: imageProvider,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String icon, String title, VoidCallback onTap, double size, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: ShowUp(
            delay: 50 * index,
            child: SizedBox(
              width: 276.w,
              height: 45.h,
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 0.w,
                    top: 22.5.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/images/profile/$icon',
                            width: size.w, height: size.h, color: Colors.grey),
                        SizedBox(width: 10.w),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: secondaryTextStyle(
                            color: Color(0xFF20003D),
                            size: 14.sp.round(),
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        if (icon != 'privacy.svg')
          Opacity(
            opacity: 0.50,
            child: Container(
              width: 276.w,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
