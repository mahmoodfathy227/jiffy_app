import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/home/controllers/model.dart';
import 'package:jiffy/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:jiffy/main.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Observable state for animations
  late AnimationController controller;
  late AnimationController _fadecontroller;
  late AnimationController
      _controllerRotate; // This will stay as an AnimationController
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeInAnimation;
  late Animation<double> rotationAnimation;

  // Rotation angle to be controlled
  var rotationAngleCircule = 0.0.obs;

  // Create an observable to control rotation state
  var isRotatingForward = false.obs;

  // Make PageController observable
  var pageController = PageController(viewportFraction: 0.8).obs;

  // Track the current page index
  var currentPage = 0.obs;

  ScrollController scrollController = ScrollController();

  List<String> categories = [
    'Styling',
    'Makeup',
    'Nails',
    'Skincare',
    'Category 5',
    'Category 6',
    'Category 7',
    'Category 8',
  ];
  final WishlistController wishListController = Get.put(WishlistController());
  final CartController cartController =
      Get.put(CartController()); // Remove this line

  @override
  void onInit() {
    super.onInit();
    fetchHomePageData();
     //Initialize main animation controller
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadecontroller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize rotation animation controller
    _controllerRotate = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Define slide and fade animations
    slideAnimation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadecontroller, curve: Curves.easeIn),
    );

    // Define rotation animation
    rotationAnimation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(parent: _controllerRotate, curve: Curves.easeInOut),
    );

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 800)).then((_) {
      controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 800)).then((_) {
      _fadecontroller.forward();
    });

    // Listen to scroll events and adjust rotation
    pageController.value.addListener(() {
      if (pageController.value.page == 0) {
        isRotatingForward.value = false; // Reverse rotation
      } else {
        isRotatingForward.value = true; // Forward rotation
      }
      rotationAngleCircule.value =
          pageController.value.page! * (3.14159 / 2); // Adjust rotation
    });
    currentPage.value = 0;
    wishListController.getWishlistProducts();
  }

  @override
  void onReady() {
    super.onReady();

    // Handle rotation based on the observable value
    ever(isRotatingForward, (isForward) {
      if (isForward) {
        _controllerRotate.forward();
      } else {
        _controllerRotate.reverse();
      }
    });
    currentPage.value = 0;
  }

  var homePageData = HomePageData(
    categories: [],
    brands: [],
    latestProducts: [],
    featuredProducts: [],
    premiumProducts: [],
  ).obs;

  var isLoading = false.obs;

  Future<void> fetchHomePageData() async {
    isLoading.value = true; // استخدام القيمة المتغيرة لحالة التحميل
    try {
      final response = await apiConsumer.get(
          'homepage'); // تغيير http إلى apiConsumer إذا كنت تستخدم نفس الـ API

      if (response['status'] == 'success') {
        var jsonData = response['data'];
        homePageData.value = HomePageData.fromJson(jsonData);
        cartController.fetchCartDetailsFromAPI();

        print("your length is ${homePageData.value.latestProducts.length}");
      } else {
        print('Failed to load data: ${response['data']}');
      }
    } catch (e) {
      print('Error in the home products getter: $e');
    } finally {
      isLoading.value = false; // تحديث حالة التحميل
    }
  }

  // Handle page changes
  void onPageChanged(int pageIndex) {
    currentPage.value = pageIndex; // Update the current page index
  }

  // Calculate vertical shift for the curved category item effect
  double calculateVerticalShift(int indexList, int length) {
    if (indexList == 0 || indexList == length - 1) {
      return 0.0;
    } else if (indexList == 1 || indexList == length - 2) {
      return 35.0.h;
    } else {
      return 0.0;
    }
  }

  @override
  void onClose() {
    controller.dispose();
    _fadecontroller.dispose();
    _controllerRotate.dispose();
    scrollController.dispose();
    pageController.value.dispose();
    super.onClose();
  }
}
