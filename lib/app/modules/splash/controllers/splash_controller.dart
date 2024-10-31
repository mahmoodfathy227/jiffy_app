import 'package:get/get.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';
import 'package:jiffy/app/modules/global/config/constant.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';
import 'package:jiffy/app/modules/onboarding/views/onboarding_view.dart';
import 'package:flutter/animation.dart';
import 'package:jiffy/app/modules/services/api_service.dart';
import 'package:jiffy/app/routes/app_pages.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController fadeController; // For fade out animation
  late AnimationController scaleController; // For scale animation
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
 

  Future<void> loadUserData() async {
    try {
      await AppConstants.loadUserFromCache();

      if (userToken?.isNotEmpty ?? false) {
  //      await cartController.fetchCartDetailsFromAPI();
        Get.off(() => MainView(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1));
      } else {
     //   await cartController.fetchCartDetailsFromAPI();
        Get.off(() => OnboardingView(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1));
      }
    } catch (e, stackTrace) {
      print("Error loading user data: $e $stackTrace");
      Get.off(() => OnboardingView(),
          transition: Transition.fadeIn, duration: const Duration(seconds: 1));
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize fade controller with 600ms duration (for fade out)
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Fade duration
    );

    // Initialize scale controller with 300ms duration (for scale in)
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Scale duration
    );

    // Fade Out Animation (Opacity) using easeOut to make logo fade out smoothly
    fadeAnimation = Tween<double>(
      begin: 1, // Start zoomed in
      end: 0, // Scale to normal size
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut, // Make the logo fade out
    ));

    // Scale Animation (Zoom In) with easeInOut for smooth zoom effect
    scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut, // Smooth scale in effect
    );

    // Start the scale animation
    scaleController.forward();

    // Once the scale animation completes, start the fade-out animation
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start the fade-out animation after the scale animation completes
        fadeController.forward();
      }
    });

    //Navigate to the next screen after both animations are complete
    loadUserData();
  }

  @override
  void onClose() {
    fadeController.dispose();
    scaleController.dispose();
    super.onClose();
  }

  // Function to restart the animation manually
  void restartAnimation() {
    fadeController.reset();
    scaleController.reset();
    scaleController.forward();
  }
}
