import 'package:get/get.dart';
import 'package:jiffy/app/modules/cart/controllers/cart_controller.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    print("splash binding started...");
 
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
