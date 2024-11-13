import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/nav_bar_controller.dart';

class NavBarView extends GetView<NavBarController> {
  const NavBarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NavBarView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NavBarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
