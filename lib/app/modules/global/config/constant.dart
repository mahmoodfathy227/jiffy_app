import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/global/theme/colors.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../../../builtInPackage/like_button-2.0.5/lib/like_button.dart';
import '../model/test_model_response.dart';
import '../theme/app_theme.dart';
import '../widget/widget.dart';
import 'helpers.dart';

class AppConstants {
  static UserData? userData;

  static hideLoading(context) {
    Navigator.of(context).pop();
  }

  static LatLng latLng = const LatLng(30.033333, 31.233334);

  static showLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsetsDirectional.all(50.0),
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        );
      },
    );
  }

  static String mapStyle = '''
  [
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#fef9e8"
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f2f3f4"
        }
      ]
    },
      {
      "featureType": "poi",
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "poi.business",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "all",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#697579"
        }
      ]
    }
  ]
  ''';

  static loadUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString); // Use jsonDecode
      AppConstants.userData = UserData.fromJson(userDataJson);
      userToken = AppConstants.userData!.token;

      print('User loaded from cache: $userDataJson');
    }
  }

  static String placeHolderImage = "assets/images/placeholder.png";


   static final sampleProduct = Product(
    id: 1,
    name: 'Product 1',
    description: 'This is product 1',
    price: 10.0,
   size: 'XL',
    rating: 4.5,
    outOfStock: false,
    image: 'https://picsum.photos/200/300',
    old_price: 20.0,

  );
}
