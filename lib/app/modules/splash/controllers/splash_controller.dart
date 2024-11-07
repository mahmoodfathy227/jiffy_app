import 'package:get/get.dart';
import 'package:jiffy/app/modules/home/views/home_view.dart';
import 'package:jiffy/app/modules/main/views/main_view.dart';
import 'package:jiffy/app/modules/onboarding/views/onboarding_view.dart';
import 'package:flutter/animation.dart';

import '../../../routes/app_pages.dart';
import '../../global/config/constant.dart';
import '../../services/api_service.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController fadeController; // For fade out animation
  late AnimationController scaleController; // For scale animation
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  var isLoading = true.obs;
  @override
  void onInit() {
    loadUserData();
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
    // Future.delayed(const Duration(seconds: 4), () {
    //   Get.off(() => OnboardingView(),
    //       transition: Transition.fadeIn, duration: const Duration(seconds: 1));
    // });
  }

  @override
  void onClose() {

    // fadeController.dispose();
    // scaleController.dispose();
    super.onClose();
  }

  // Function to restart the animation manually
  void restartAnimation() {
    fadeController.reset();
    scaleController.reset();
    scaleController.forward();
  }


  Future<void> loadUserData() async {
    try {
      await AppConstants.loadUserFromCache();
      if (userToken != null) {
        // If the user token exists, navigate to the main screen.
        print("userToken retrived user data: $userToken");
        // await Future.delayed(const Duration(seconds: 3));
        // Get.offAllNamed(Routes.HOME);
        fadeController.dispose();
        scaleController.dispose();
        Get.off(() =>  MainView());

      } else {
        // If no user token is found, navigate to the onboarding screen.
        // await Future.delayed(const Duration(seconds: 3));
        // fadeController.dispose();
        // scaleController.dispose();
        navigateToOnboarding();
        // Get.off(OnboardingView());
      }
    } catch (e) {
      // Handle any exceptions that may occur during loading
      print("Error loading user data: $e");
      await Future.delayed(const Duration(seconds: 3));
      navigateToOnboarding();

      // Consider navigating to an error screen or showing a retry option
    } finally {
      // Set loading to false when done
      isLoading.value = false;
    }
  }

  void navigateToOnboarding() {
    print("it navigateToOnboarding");
    Get.offNamedUntil(Routes.ONBOARDING, (route) => false);

    //  Get.offAll(() => const OnboardingView());
  }
}
