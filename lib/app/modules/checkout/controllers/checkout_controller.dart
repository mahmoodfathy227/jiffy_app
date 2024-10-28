import 'package:get/get.dart';
import 'package:jiffy/app/modules/address/views/address_view.dart';
import 'package:jiffy/app/modules/checkout/model/address_api_response.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../../../main.dart';
import '../../address/model/address_model.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController

  final count = 0.obs;

  RxBool isAddressLoading = false.obs;
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


}
