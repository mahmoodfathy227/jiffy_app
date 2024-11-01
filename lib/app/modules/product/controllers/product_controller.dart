import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:jiffy/app/modules/global/config/constant.dart';
import 'package:jiffy/app/modules/home/views/home_view.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';


import '../../../../main.dart';
import '../../global/model/model_response.dart';
import '../../global/model/test_model_response.dart';
import '../../services/api_consumer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:carousel_slider/carousel_controller.dart';

class ProductController extends GetxController {
// Rx<Product>? product = Product().obs;
  RxBool isProductLoading = false.obs;
  RxBool isAddToCartActive = false.obs;
  List<Attachments> productImages = [


  ];


  var cartIndex = 1.obs;
  // Rx<int> currentStock = 0.obs;
  List<ProductColor> colorsList = [];
  Rx<int> imageIndex = 0.obs;
  Rx<Product> product = Product(
    id: 0,
    name: "Perfume",
    price: 0.toString(),
    description: "Good Perfume",
    image: "https://www.pngall.com/wp-content/uploads/2016/05/Perfume-Free-Download-PNG.png",
    old_price: 0.toString(),
    rating: 4,
    size: "",
    outOfStock: false,
  ).obs;
  ApiConsumer apiConsumer = sl();
  final count = 0.obs;
  final isShowDescription = true.obs;
  final isShowReviews = false.obs;
  List<String> sizeList = [];
  Rx<String> selectedSize = "".obs;

  Rx<String> selectedColor = "".obs;
  Rx<SizeGuide> productSizeGuide = SizeGuide().obs;
  RxBool isHomeIcon = false.obs;

  @override
  void onInit() {
    super.onInit();

  }

  Rx<String> placeHolderImg = "".obs;
  
  @override
  void onReady() {
    isFirstTimeGettingReviews = true;
    carouselController = CarouselSliderController();
    print('tesadasw5');
    print("product arguments are ${deepLinkproduct}");
    if (isDeepLink) {
      getProduct(deepLinkproduct!.id);
      isDeepLink = false;
    }

    if (Get.arguments != null && Get.arguments is Product) {
      var myProduct = Get.arguments as Product;
      placeHolderImg.value = myProduct.image!;
      print("new product name 2 ${myProduct.name} ");
      getProduct(myProduct.id);

      if (colorsList.isNotEmpty) {
        setColor(colorsList.first.name);
      }
    } else {
      // Handle the case where no valid arguments are passed
      // You can navigate back or show an error message
      if (isDeepLink == false) {
        // Get.back();
        // Get.closeCurrentSnackbar();
        // Get.snackbar('Error', 'No product data available');
        isHomeIcon.value = true;
      }
    }

    super.onReady();
    // product?.value = Get.arguments as Product;
    // print("product module is ${product!.value.image!}");
  }

  @override
  void onClose() {
    super.onClose();
    print('tesadas');
  }

  void increment() => count.value++;

  switchShowDescription() {
    isShowDescription.value = !isShowDescription.value;
    print("desc is ${isShowDescription.value}");
  }

  switchShowReviews() {
    isShowReviews.value = !isShowReviews.value;
    if (isShowReviews.value) {
      getProductReviews();
    }
  }

  List<ReviewsModel> reviews = [
    // ReviewsModel(
    //   id: 1,
    //   customer: "John Doe",
    //   title: "Loved it",
    //   comment: "This is a great product. I really enjoyed using it. I will definitely buy it again.",
    //   rating: 4
    // )
  ];
  bool isFirstTimeGettingReviews = false;
  bool isReviewsLoading = false;

  RxBool isSharing = false.obs;

  startSharing() {
    isSharing.value = true;
  }

  endSharing() {
    isSharing.value = false;
  }

  getProductReviews() async {
    print("start getting review 11");

    if (isFirstTimeGettingReviews == true) {
      print("start getting review 2");
      isReviewsLoading = false;
      print("review value is 1 ${isReviewsLoading}");
      update(['reviews']);
      var result = await apiConsumer.post(
        "products/ratings/${product.value.id!}",
      );

      if (result['status'] == "success") {
        for (var review in result['data']) {
          reviews.addNonNull(ReviewsModel.fromJson(review));
        }
        isFirstTimeGettingReviews = false;
        isReviewsLoading = false;
        update(['reviews']);
      } else {
        update(['reviews']);
      }
    } else {
      print("start getting review 3");
    }
  }

  setSize(customSize) {
    selectedSize.value = customSize;
    for (var size in sizeList) {
      if (size == selectedSize.value) {}
    }
    update();
  }

  setColor(customColor) {
    selectedColor.value = customColor;

    update();
  }

  changeImagesList(incomingColor) {
    print("updating..");
    print("old attachmants are ${productImages}");
    print("incoming color ${incomingColor}");
    for (var color in colorsList) {
      if (color.name == incomingColor) {
        print("true");
        productImages.clear();
        for (var image in color.images!) {
          print("images in color ${color.images}");
          productImages.addNonNull(
              Attachments(type: "image", name: "app_show", path: image));
        }
      }
    }

    print("new attachmants are ${productImages}");
  }

  CarouselSliderController? carouselController;
  Rx<int> selectedIndex = 0.obs;

  setSelectedIndex(incomingIndex) {
    selectedIndex.value = incomingIndex;
  }

  setCarouselControllerIndex(incomingIndex) {
    if (carouselController != null) {
      print("carousel controller is not null");
      print("incoming index ${incomingIndex}");
      carouselController?.jumpToPage(incomingIndex);
    }
  }

  getProduct(id) async {
    productImages.clear();
    colorsList.clear();
    sizeList.clear();
    productSizeGuide.value = SizeGuide();
    // isProductLoading.value = true;
    isProductLoading.value = false;

    try {
      final response = await apiConsumer.post(
        'products/$id',
      );

      product.value = Product.fromJson(response['data']);

     print("you attachments are ${product.value.attachments!}");

     for(var attachment in product.value.attachments!){
       if(attachment['name'] == "app_show"){
         productImages.addNonNull(Attachments(type: "image", name: "app_show", path: attachment['path']));
       } else {

       }

     }
      print("you attachments are 22 ${product.value.attachments!}");
      isProductLoading.value = false;

      setSelectedIndex(selectedIndex.value);
      changeImagesList(selectedColor.value);
      print("your product data is ${product.value}");
isAddToCartActive.value = false;

    } catch (e, stackTrace) {
      print(stackTrace.toString() + ' product test error' + '${e.toString()}');
      isProductLoading.value = false;
      product.value = AppConstants.sampleProduct;
      Get.snackbar("Error", "Product Not Found Redirect..");
      Get.off(() => MainView());
    }
  }

  changeIndex() {
    int checkIndex = imageIndex.value + 1;
    if (checkIndex < productImages.length) {
      imageIndex.value = checkIndex;
    }

    print("cur index is ${imageIndex.value}");
  }

  minusIndex() {
    int checkIndex = imageIndex.value - 1;
    if (checkIndex >= 0) {
      imageIndex.value = checkIndex;
    }

    print("cur index is ${imageIndex.value}");
  }

  setIndex() {
    imageIndex.value = 0;
  }

  changeAddToCartStatus() {

    isAddToCartActive.value = !isAddToCartActive.value;
    print("my produt id is ${product.value.id} ");
    cartController.addToCart(product.value,
        quantity: 1);

    cartIndex.value = cartController.cartItems.indexWhere( (element) => element.product.id == product.value.id);

  }

  List<Product> relatedProducts = <Product>[];
  bool isRelatedProductsLoading = false;
  List<Product> finalRelatedProducts = <Product>[];

  void getRelatedProducts(int? id) async {
    relatedProducts.clear();
    isRelatedProductsLoading = true;
    update(['related-products']);
    print("should called once...");

    print("your coming cat id is ${id}");
    var formData = dio.FormData.fromMap(
        {'per_page': '4', 'category_ids[0]': id.toString()});
    var response = await apiConsumer.post("products",
        formDataIsEnabled: true, formData: formData);

    try {
      if (response['data'] != null) {
        for (var product in response['data']) {
          print("rach pro is ${product}");
          relatedProducts.add(Product.fromJson(product));
        }

        if (relatedProducts.isNotEmpty) {
          for (var myProduct in relatedProducts) {
            print("rounding....");
            if (myProduct.id != product.value.id) {
              print("firts id 1 ${myProduct.id}");
              print("firts id 2 ${product.value.id}");
              print("is it result ${myProduct.id == product.value.id}");
              finalRelatedProducts.add(myProduct);
            }
          }

          update(['related-products']);
        } else {
          print("sorry it's empty");
        }

        isRelatedProductsLoading = false;
        print("should called once... 2 ${response['data']} ");
        print("products related are ${relatedProducts}");
        update(['related-products']);
      } else {
        print(response.reasonPhrase);
        isRelatedProductsLoading = false;
        print('products fetch failed 1: ${response.reasonPhrase} ');

        update(['related-products']);
      }
    } catch (e, stackTrace) {
      isRelatedProductsLoading = false;
      print('products fetch failed 2:  ${e} $stackTrace');

      print(e.toString() + stackTrace.toString());
      update(['related-products']);
    }
  }
}
