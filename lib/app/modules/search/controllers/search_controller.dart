import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:jiffy/app/modules/global/model/test_model_response.dart';

import '../../../../main.dart';
import '../../global/model/model_response.dart';
import 'package:flutter/material.dart';
class CustomSearchController extends GetxController {


  RxList<Category> categories = <Category>[].obs;
RxBool isCategoryLoading = false.obs;
  RxBool isProductsLoading = false.obs;
  RxBool isExpanded = false.obs;
   RxList<Product>  filteredProducts = < Product >[] .obs;
  RxString selectedFilter = "".obs;
  RxBool isHighToLowFilter = true.obs;
Rx<TextEditingController> searchController = TextEditingController().obs;
  RxString  selectedCategory = "".obs;
  var bodyRequest;

List<String> filterItems = ["Featured", "Best Selling", "Latest",];
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getCategories();
    getProducts(null);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  getProducts(var inComingbodyRequest) async{
    Map<String, dynamic> combinedMap =
    isHighToLowFilter.value ?  {
     'order_by':'high-low'
    } :
    {
      'order_by':'low-high',
    };
if(inComingbodyRequest != null){

 combinedMap = {}..addAll(inComingbodyRequest);
 if(selectedCategory.value.isNotEmpty){
   combinedMap.addAll({'category_ids[0]':categories.firstWhere((element) => element.name == selectedCategory.value).id.toString()});
 }

}

    try {
      filteredProducts.clear();
      isProductsLoading.value = true;

print("your map body request is ${combinedMap}");
      var result = await apiConsumer.post(
        "products",

        queryParameters: combinedMap

      );

      if (result['data'] != null) {

        filteredProducts.assignAll(List<Product>.from(result['data'].map((x) => Product.fromJson(x))));
      }
      print("your products data are ${filteredProducts.first.name}");
    } on DioError catch (e) {
      print(e.response!.data);
      print("your error products data aaaaaa are error${e.response!.data}");
    } finally {
      isProductsLoading.value = false;
    }
  }
 getCategories() async{

   try {
     isCategoryLoading.value = true;
     var result = await apiConsumer.post(
       "categories",
     );

     if (result['data'] != null) {
       for (var category in result['data']) {
         categories.add(Category.fromJson(category));
       }
       isCategoryLoading.value = false;
     }

   } catch (e, stackTrace) {
     isCategoryLoading.value = true;
     print('$stackTrace product test error${e.toString()}');

     Get.snackbar("Error", "Product Not Found Redirect..");
   }

 }
  selectFilter(filter){
    selectedFilter.value = filter;
  }

  reset(){
    selectedFilter.value = "";
    getProducts(null);
    selectedCategory.value = "";
    isHighToLowFilter.value = true;
    selectedFilter.value = "";
    selectedCategory.value = "";
    searchController.value.clear();

  }

  toggleSelectedCategory(category){
    selectedCategory.value = category;
  }



}
