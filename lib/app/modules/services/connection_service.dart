

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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
    return TickerMode(
      enabled: isTicker,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.signal_wifi_connected_no_internet_4, color: primaryColor, size: 55,),
              const SizedBox(
                height: 20,
              ),
              Text(
                'No Internet Connection',
                style: primaryTextStyle(size: 20, weight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? CircularProgressIndicator(
                backgroundColor: primaryColor,
              )
                  : ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      isLoading = true;
                      setState(() {});
                    }

                    Future.delayed(const Duration(seconds: 1), () async {
                      await Connectivity()
                          .checkConnectivity()
                          .then((value) async {
                        if (value.first == ConnectivityResult.none) {
                          if (mounted) {
                            isLoading = false;
                            setState(() {});
                          }
                        } else {
                          await Get.closeCurrentSnackbar();
                          Get.to(MainView());
                        }
                      });
                    });
                  },
                  child: Text(
                    'Retry',
                    style: primaryTextStyle(),
                  )),
            ]),
          ),
        ),
      ),
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
