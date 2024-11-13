import 'package:get/get.dart';

class NavBarController extends GetxController {
  //TODO: Implement NavBarController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    print('cur index: ${selectedIndex.value}');
  }
}
