import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/checkout/views/checkout_view.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/home/views/home_view.dart';
import 'package:jiffy/app/modules/main/controllers/tab_controller.dart';
import 'package:jiffy/app/modules/profile/views/profile_view.dart';

class MainView extends StatelessWidget {
  final NavigationsBarController _tabController =
      Get.put(NavigationsBarController());

  final List<Widget> _screens = [
    HomeView(),
    ProfileView(),
   CheckoutView(),
    // const WishlistView(),
    ProfileView(),
    // WishlistView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Obx(() => _screens[_tabController.selectedIndex.value]),
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child:
            CustomNavBar(),
          ),
        ),
      ]),
    );
  }
}
