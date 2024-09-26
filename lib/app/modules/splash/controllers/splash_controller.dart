import 'package:get/get.dart';
import 'package:jiffy/app/modules/onboarding/views/onboarding_view.dart';
import 'package:flutter/animation.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize animation controller with 2 seconds duration
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 800), // Longer duration for better visibility
    );

    // Fade Animation (Opacity)
    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    // Scale Animation (Zoom In)
    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    // Start the animation after a small delay to ensure everything is ready
    animationController.forward();

    // Navigate to the next screen after 5 seconds (adjusted from 10s)
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(() => OnboardingView(),
          transition: Transition.fadeIn, duration: const Duration(seconds: 1));
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  // Function to restart the animation manually
  void restartAnimation() {
    animationController.reset();
    animationController.forward();
  }
}
