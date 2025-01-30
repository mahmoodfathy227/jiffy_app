

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';

import '../global/theme/app_theme.dart';
import '../../routes/app_pages.dart';
import '../main/views/main_view.dart';
Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile) ) {
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  }
  return false;
}


class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  bool isLoading = false;
  bool isTicker = true;

  @override
  void initState() {
    networkChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset("assets/images/no_internet/rounded_eclipce.svg"),
              SvgPicture.asset("assets/images/no_internet/plug.svg"),

            ],
          ),
          const Spacer(),
          SvgPicture.asset("assets/images/no_internet/Whoops! No Internet Connection found. Check your connection or try again.svg"),
          const Spacer(),
          SvgPicture.asset("assets/images/no_internet/try_again.svg"),
          const Spacer(),
        ],
      )),
    );
  }

  Future<void> networkChecker() async {
    await Connectivity().checkConnectivity().then((value) async {
      if (value.first == ConnectivityResult.none) {
      } else {
        isTicker = false;
        await Get.closeCurrentSnackbar();
      }
    });
  }



}
