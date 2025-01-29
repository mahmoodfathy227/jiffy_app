import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/model/model_response.dart';
import 'package:jiffy/app/modules/home/controllers/model.dart';
import 'package:jiffy/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:jiffy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class HomeController extends GetxController with SingleGetTickerProviderMixin {
  // Observable state for animations


   Animation<Offset>? slideAnimation;
   Animation<double>? fadeInAnimation;
   Animation<double>? rotationAnimation;

  // Rotation angle to be controlled
  var rotationAngleCircule = 77.0.obs;

  // Create an observable to control rotation state
  var isRotatingForward = false.obs;

  // Make PageController observable
  var pageController = PageController(viewportFraction: 0.8).obs;

  // Track the current page index
  var currentPage = 0.obs;

  ScrollController scrollController = ScrollController();

  var categories = <Categories>[

  ].obs;

  late AnimationController rotatingUpperBarController;
  RxBool isRotating = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchHomePageData();
    getCategories();
    getCurrentLocation();
    scrollController.addListener(_onScroll);
    rotatingUpperBarController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    //  //Initialize main animation controller
    // controller = AnimationController(
    //   duration: const Duration(milliseconds: 1000),
    //   vsync: this,
    // );
    // _fadecontroller = AnimationController(
    //   duration: const Duration(milliseconds: 700),
    //   vsync: this,
    // );
    //
    // // Initialize rotation animation controller
    // _controllerRotate = AnimationController(
    //   duration: const Duration(milliseconds: 200),
    //   vsync: this,
    // );
    //
    // // Define slide and fade animations
    // slideAnimation =
    //     Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
    //   CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    // );
    //
    // fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
    //   CurvedAnimation(parent: _fadecontroller, curve: Curves.easeIn),
    // );
    //
    // // Define rotation animation
    // rotationAnimation = Tween<double>(begin: 0, end: 360).animate(
    //   CurvedAnimation(parent: _controllerRotate, curve: Curves.easeInOut),
    // );
    //
    // // Start animation after a delay
    // Future.delayed(const Duration(milliseconds: 500)).then((_) {
    //   controller.forward();
    // });
    // Future.delayed(const Duration(milliseconds: 500)).then((_) {
    //   _fadecontroller.forward();
    // });
    //
    // // Listen to scroll events and adjust rotation
    // pageController.value.addListener(() {
    //   if (pageController.value.page == 0) {
    //     isRotatingForward.value = false; // Reverse rotation
    //   } else {
    //     isRotatingForward.value = true; // Forward rotation
    //   }
    //   rotationAngleCircule.value =
    //       pageController.value.page! * (3.14159 / 2); // Adjust rotation
    // });
    currentPage.value = 0;
    // wishListController.getWishlistProducts();
  }

  @override
  void onReady() {
    super.onReady();

    // Handle rotation based on the observable value
    // ever(isRotatingForward, (isForward) {
    //   if (isForward) {
    //     _controllerRotate.forward();
    //   } else {
    //     _controllerRotate.reverse();
    //   }
    // });
    currentPage.value = 0;
  }

  var homePageData = HomePageData(
    categories: [],
    brands: [],
    latestProducts: [],
    featuredProducts: [],
    premiumProducts: [],
    banners: [],
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


    scrollController.dispose();
    pageController.value.dispose();
    super.onClose();
  }

  double _previousScrollOffset = 0.0;
  void _onScroll() {
    double currentScrollOffset = scrollController.offset;

    if (currentScrollOffset > _previousScrollOffset) {
      print('Scrolling down!');
    } else if (currentScrollOffset < _previousScrollOffset) {
      print('Scrolling up!');
    }

    _previousScrollOffset = currentScrollOffset;

    // Check if scrolled more than 100 pixels
    if (currentScrollOffset > 100) {
      print('Scrolled more than 100 pixels');
    }
  }

  void toggleRotation() {
    isRotating.value = !isRotating.value;
    if (isRotating.value) {
      rotatingUpperBarController.forward();
      // rotatingUpperBarController.repeat(reverse: true, period: Duration(seconds: 1));
    } else {
      rotatingUpperBarController.stop();
    }

  }

  RxBool isCategoriesLoading = false.obs;
  getCategories() async{
categories.clear();
isCategoriesLoading.value = true; // استخدام القيمة المتغيرة لحالة التحميل
    try {
      final response = await apiConsumer.post(
          'categories'); // تغيير http إلى apiConsumer إذا كنت تستخدم نفس الـ API

      if (response['status'] == 'success') {
        var jsonData = response['data'];
        for(var cat in jsonData){
          categories.add(Categories.fromJson(cat));
        }


        print("your length is categries ${categories.length}");
        isCategoriesLoading.value = false;
      } else {

        isCategoriesLoading.value = false;
      }
    } catch (e) {
      print('Error in the home products getter categries : $e');
      isCategoriesLoading.value = false;
    } finally {
      isCategoriesLoading.value = false;
    }

  }


  RxString state = ''.obs;
   RxString city = ''.obs;
   RxString country = ''.obs;
   RxString address = ''.obs;
   RxBool isLocationLoading = false.obs;
   void getCurrentLocation() async{
     isLocationLoading.value = true;
      // ask permission to  location
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        // Get.snackbar("Location", "Location services are disabled", colorText: Colors.white);
        isLocationLoading.value = false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          isLocationLoading.value = false;
        }
        isLocationLoading.value = false;
      }

try{
  Position position = await Geolocator.getCurrentPosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  var first = placemarks.first;
  state.value = first.administrativeArea!.substring(0, 8) + '..';
  city.value = first.locality!.length >= 8 ? '${first.locality!.substring(0, 8)}..' :first.locality! ;
  country.value = first.country!;
  isLocationLoading.value = false;
  print("Your state is ${state.value} and city is ${city.value}");
}catch(e){
        print("location error ${e.toString()}");
        Get.snackbar('Location', e.toString(), colorText: Colors.white);
        isLocationLoading.value = false;
}

  }
}
