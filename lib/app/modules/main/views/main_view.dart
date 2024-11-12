import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jiffy/app/modules/cart/views/cart_view.dart';
import 'package:jiffy/app/modules/global/widget/widget.dart';
import 'package:jiffy/app/modules/home/views/home_view.dart';
import 'package:jiffy/app/modules/main/controllers/tab_controller.dart';
import 'package:jiffy/app/modules/profile/views/profile_view.dart';
import 'package:jiffy/app/modules/wishlist/view/wishlist_view.dart';

import '../../../../main.dart';

class MainView extends StatelessWidget {


  final List<Widget> _screens = [
    HomeView(),
    WishlistView(),
    CartPage(),
    ProfileView(),
    // WishlistView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Obx(() {
          print("Your current screen is ${tabController.selectedIndex.value}");
          return _screens[tabController.selectedIndex.value];
        } ),
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: CustomNavBar(),
          ),
        ),
      ]),
    );
  }
}
