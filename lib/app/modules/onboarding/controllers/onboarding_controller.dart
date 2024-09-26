import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController
    with SingleGetTickerProviderMixin {
  // Observable variables for page tracking
  var currentPage = 0.obs;
  var previousPage = 0.obs;

  // Controllers for the animations
  PageController pageController = PageController();
  AnimationController? scaleController;
  AnimationController? fadeController;
  AnimationController? rotationController;
  AnimationController? textController;
  AnimationController? scaleWelcomeController;
  AnimationController? fadeWelcomeController;
  AnimationController? slideUpController; // Controller for sliding up animation
  Animation<Offset>? slideUpAnimation; // Sliding up animation for the container
  // Animations
  Animation<double>? scaleWelcomeAnimation;
  Animation<double>? fadeWelcomeAnimation;
  Animation<double>? backgroundScaleAnimation;
  Animation<double>? backgroundFadeAnimation;
  Animation<double>? imageRotationAnimation;
  Animation<double>? imageFadeAnimation;
  Animation<Offset>? titleSlideAnimation;
  Animation<Offset>? descSlideAnimation;
  Animation<double>? textFadeAnimation;

  @override
  void onInit() {
    super.onInit();

    // Start the initial animations
    // Initialize all animation controllers
    initializeControllers();

    // Define the animation properties
    defineAnimations();

    // Start the animations for the first page
    Future.delayed(const Duration(milliseconds: 200), () {
      // Small delay to ensure everything is loaded
      startInitialAnimations();
    });
  }

  // Initializes all the animation controllers
  void initializeControllers() {
    scaleWelcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeWelcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  // Defines all the animations based on the initialized controllers
  void defineAnimations() {
    // Welcome screen animations (Logo scale and fade)
    // Initialize the slide-up animation controller
    slideUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650), // Duration for slide-up
    );

    // Define the slide-up animation (starts from off-screen and moves up)
    slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start off-screen
      end: Offset.zero, // End at its normal position
    ).animate(CurvedAnimation(
      parent: slideUpController!,
      curve: Curves.easeInOut,
    ));
    scaleWelcomeAnimation = Tween<double>(
      begin: 9, // Start zoomed in
      end: 1.0, // Scale to normal size
    ).animate(CurvedAnimation(
      parent: scaleWelcomeController!,
      curve: Curves.linear,
    ));

    fadeWelcomeAnimation = Tween<double>(
      begin: 0.0, // Start fully transparent
      end: 1.0, // Fade in
    ).animate(CurvedAnimation(
      parent: fadeWelcomeController!,
      curve: Curves.easeInOut,
    ));

    // Background and Image animations
    backgroundScaleAnimation = Tween<double>(
      begin: 1.0, // Start at normal size
      end: 1.1, // Slight zoom
    ).animate(CurvedAnimation(
      parent: scaleController!,
      curve: Curves.easeInOut,
    ));

    backgroundFadeAnimation = Tween<double>(
      begin: 0.5, // Start partially visible
      end: 0.0, // Fade out
    ).animate(CurvedAnimation(
      parent: fadeController!,
      curve: Curves.easeInOut,
    ));

    imageRotationAnimation = Tween<double>(
      begin: -0.05, // Slight counterclockwise rotation
      end: 0.05, // Rotate back and forth
    ).animate(CurvedAnimation(
      parent: rotationController!,
      curve: Curves.easeInOut,
    ));

    imageFadeAnimation = Tween<double>(
      begin: 0.0, // Start invisible
      end: 1.0, // Fade in
    ).animate(CurvedAnimation(
      parent: fadeController!,
      curve: Curves.easeInOut,
    ));

    // Text animations (Title and description)
    titleSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Slide in from below
      end: Offset(0, 0), // End at normal position
    ).animate(CurvedAnimation(
      parent: textController!,
      curve: Curves.easeInOut,
    ));

    descSlideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // Slide in from below
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: textController!,
      curve: Interval(0.1, 1.0, curve: Curves.easeInOut),
    ));

    textFadeAnimation = Tween<double>(
      begin: 0.0, // Start invisible
      end: 1.0, // Fade in
    ).animate(CurvedAnimation(
      parent: textController!,
      curve: Curves.easeInOut,
    ));
  }

  // Starts the initial animations when the first page is loaded
// Starts the initial animations when the first page is loaded
  void startInitialAnimations() {
    scaleController?.forward();
    fadeController?.forward();
    rotationController?.forward();
    textController?.forward();
  }

  // Restarts the onboarding process by resetting and starting animations
  void restartOnboarding() {
    // Reset the current page
    currentPage.value = 0;
    previousPage.value = -1;

    // Reset page controller
    pageController.jumpToPage(0);

    // Reset and forward all animations
    resetAndForwardAllAnimations();
  }

  // Handles the transition to the next page with synchronized animations
  void nextPage() {
    if (currentPage < 2) {
      previousPage.value = currentPage.value;

      // Navigate to the next page and reset/forward animations
      pageController
          .nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .then((_) {
        //   resetAndForwardAllAnimations();
      });
    } else {
      // Handle final page animations for the welcome screen
      slideUpController!.reset();
      scaleWelcomeController!.reset();
      fadeWelcomeController!.reset();
      scaleWelcomeController!.forward();

      fadeWelcomeController!.forward();
      slideUpController!.forward(); // Trigger the slide-up animation

      currentPage.value = 3; // Set to welcome page
    }
  }

  // Resets and starts all animations for the current page
  void resetAndForwardAllAnimations() {
    scaleController!.reset();
    fadeController!.reset();
    rotationController!.reset();
    textController!.reset();

    scaleController!.forward();
    fadeController!.forward();
    rotationController!.forward();
    textController!.forward();
  }

  // Handles the page change event to trigger animations on page transition
  void onPageChanged(int index) {
    previousPage.value = currentPage.value;
    currentPage.value = index;

    // Reset and start the animations for the new page
    resetAndForwardAllAnimations();
  }

  // Skips to the last onboarding page
  void skip() {
    currentPage.value = 2;
    pageController.jumpToPage(2);
  }

  // Dispose of the animation controllers when the screen is closed
  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }

  // Disposes all animation controllers to free resources
  void disposeControllers() {
    scaleController?.dispose();
    fadeController?.dispose();
    slideUpController?.dispose();

    rotationController?.dispose();
    textController?.dispose();
    scaleWelcomeController?.dispose();
    fadeWelcomeController?.dispose();
  }
}
