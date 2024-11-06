import 'dart:convert';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';

import 'package:jiffy/main.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../auth/views/login_view.dart';
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
      // getWishlistProducts();
      // print('init wish');
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // getWishlistProducts();
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
  Rx<bool> isProductInWishList(id) {
    return wishlistProductIds.any((element) => id == element).obs;
  }

//////////////////////Wishlist/////////////////////////////////
  getWishlistProducts() async {
    wishlistProductIds.clear();
    resultSearchProducts.clear();
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
            print(id.toString() + 'tesasdsa');
          }
          // WishlistController wishlistController =
          //     Get.put<WishlistController>(WishlistController());
          // wishlistController.
          setInitData(wishlistProductIds);
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


    if (userToken != null) {
      // Get.closeCurrentSnackbar();
      // Get.snackbar('Removed', 'Removed from Wishlist',
      //     // backgroundColor: primaryColor,
      //     icon: SvgPicture.asset(
      //       "assets/images/home/add_to_wishlist.svg",
      //       width: 43.w,
      //       height: 43.h,
      //       fit: BoxFit.cover,
      //     ),
      //     isDismissible: true);

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
    } else {
      Get.to(() => LoginView());
    }
  }

  addToWishlist(product_id) async {

    if (userToken != null) {
      // Get.closeCurrentSnackbar();
      // Get.snackbar('Added', 'Added To Wishlist',
      //     // backgroundColor: primaryColor,
      //
      //     isDismissible: true);

      print('removing from Wishlist api loading ....');

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
      Get.to(() => LoginView());
    }
  }

  Future<List<dynamic>> getProductsInSection(List<String> product_ids) async {
    int _index = 0;
    resultSearchProducts.clear();
    isWishlistLoading.value = true;

    print("getting started...");

    final Map<dynamic, dynamic> bodyFields = {};

    if(product_ids.isEmpty){
      isWishlistLoading.value = false;
      return [];
    }
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
      Uri.parse('https://jiffy.abadr.work/api/products'),
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
