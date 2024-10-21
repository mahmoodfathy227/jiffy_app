import 'dart:convert';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/main.dart';

import '../../home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/api_service.dart';

class WishlistController extends GetxController {
  //TODO: Implement WishlistController

  final count = 0.obs;
  final resultCount = 0.obs;
  final List<Product> resultSearchProducts = <Product>[].obs;
  RxBool isWishlistLoading = false.obs;
  RxBool isAuth = false.obs;

  @override
  void onInit() {
    if (userToken == null) {
      isAuth.value = false;
    } else {
      isAuth.value = true;
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  setInitData(List<int> wishlistProductIds) async {
    List<String> _product_ids = [];
    resultCount.value = wishlistProductIds.length;
    for (var id in wishlistProductIds) {
      _product_ids.addNonNull(id.toString());
    }
    print("the ids are ${_product_ids}");

    // String _product_ids_inString = _product_ids.join(",");
    await getProductsInSection(_product_ids);
  }

  final wishlistProductIds = <int>[].obs;
  bool isProductInWishList(id) {
    return wishlistProductIds.any((element) => id == element);
  }

//////////////////////Wishlist/////////////////////////////////
  getWishlistProducts() async {
    wishlistProductIds.clear();
    print('Wishlist api loading ...');
    if (userToken != null) {
      final response = await apiConsumer.post(
        'wishlist',
        formDataIsEnabled: true,
      );

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');
          for (var id in apiResponse.data!.wishlist!) {
            wishlistProductIds.addNonNull(id);
          }
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.setInitData(wishlistProductIds);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  removeFromWishlist(product_id) async {
    // Get.snackbar('Removing ...', 'Removing From Wishlist',
    //     showProgressIndicator: true,
    //     progressIndicatorBackgroundColor: Colors.white,
    //     backgroundColor: primaryColor,
    //     duration: const Duration(milliseconds: 1200),
    //     icon: Center(
    //         child: LoadingAnimationWidget.flickr(
    //       leftDotColor: Colors.purpleAccent,
    //       rightDotColor: Colors.white,
    //       size: 40.sp,
    //     )),
    //     isDismissible: true);

    if (userToken != null) {
      Get.closeCurrentSnackbar();
      Get.snackbar('Removed', 'Removed from Wishlist',
          // backgroundColor: primaryColor,
          icon: SvgPicture.asset(
            "assets/images/home/add_to_wishlist.svg",
            width: 43.w,
            height: 43.h,
            fit: BoxFit.cover,
          ),
          isDismissible: true);

      print('removing from Wishlist api loading ...');
      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/remove',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.removeWhere((item) => item == product_id);
          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.removeFromGrid(product_id);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    }
  }

  addToWishlist(product_id) async {
    // Get.snackbar('Adding ...', 'Adding To Wishlist',
    //     showProgressIndicator: true,
    //     duration: const Duration(milliseconds: 1200),
    //     progressIndicatorBackgroundColor: Colors.white,
    //     backgroundColor: primaryColor,
    //     icon: Center(
    //         child: LoadingAnimationWidget.flickr(
    //       leftDotColor: Colors.purpleAccent,
    //       rightDotColor: Colors.white,
    //       size: 40.sp,
    //     )),
    //     isDismissible: true);

    if (userToken != null) {
      Get.closeCurrentSnackbar();
      Get.snackbar('Added', 'Added To Wishlist',
          // backgroundColor: primaryColor,
          icon: SvgPicture.asset(
            "assets/images/home/wishlisted.svg",
            width: 43.w,
            height: 43.h,
            fit: BoxFit.cover,
          ),
          isDismissible: true);

      print('removing from Wishlist api loading ...');

      var formData = dio.FormData.fromMap({
        'product_id': product_id,
      });
      final response = await apiConsumer.post('wishlist/add',
          formDataIsEnabled: true, formData: formData);

      try {
        final apiResponse = WishlistData.fromJson(response);
        if (apiResponse.status == 'success') {
          print('Wishlist data successful');

          wishlistProductIds.add(product_id);

          WishlistController wishlistController =
              Get.put<WishlistController>(WishlistController());
          wishlistController.addToGrid(product_id);
        } else {
          handleApiErrorUser(apiResponse.message);
          handleApiError(response.statusCode);
          print('wishlist fetch failed: ${response.statusMessage}');
        }
      } catch (e, stackTrace) {
        print('wishlist fetch failed:  ${e} $stackTrace');

        print(e.toString() + stackTrace.toString());
      }
    } else {
      Get.closeCurrentSnackbar();
      Get.snackbar('System', 'Please Log in First',
          showProgressIndicator: true,
          duration: const Duration(milliseconds: 1200),
          progressIndicatorBackgroundColor: Colors.white,
          // backgroundColor: primaryColor,
          icon: Center(child: Icon(Icons.login)),
          isDismissible: true);
    }
  }

  Future<List<dynamic>> getProductsInSection(List<String> product_ids) async {
    int _index = 0;
    resultSearchProducts.clear();
    isWishlistLoading.value = true;

    print("getting started...");

    final Map<dynamic, dynamic> bodyFields = {};

    product_ids.forEach((id) {
      bodyFields["ids[${_index}]"] = id;
      _index++;
    });

    print("the body is ${bodyFields}");
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://panel.mariannella.com/api/products'),
      headers: headers,
      body: bodyFields,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        for (var product in responseData['data']) {
          resultSearchProducts.add(Product.fromJson(product));
        }
        resultCount.value = resultSearchProducts.length;
        isWishlistLoading.value = false;
        print("your result length ${resultSearchProducts.length}");

        return resultSearchProducts;
      } else {
        print(response.reasonPhrase);
        isWishlistLoading.value = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        return [];
      }
    } catch (e, stackTrace) {
      isWishlistLoading.value = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return [];
    }
  }

  removeFromGrid(id) {
    resultSearchProducts.removeWhere((product) => product.id! == id);
  }

  addToGrid(id) async {
    await getProductWithId(id);
    if (productData != null) {
      resultSearchProducts.add(productData!);
    }
    print("getting grid after added ${resultSearchProducts.length}");
  }

  Product? productData;

  getProductWithId(id) async {
    var headers = {
      'Accept': 'application/json',
      'x-from': 'app',
      'x-lang': 'en',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final response = await http.post(
      Uri.parse('https://panel.mariannella.com/api/products/${id}'),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        productData = Product.fromJson(responseData['data']);

        return productData;
      } else {
        print(response.reasonPhrase);

        print('products fetch failed 1: ${response.reasonPhrase} ');

        return productData;
      }
    } catch (e, stackTrace) {
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());

      return productData;
    }
  }
}
