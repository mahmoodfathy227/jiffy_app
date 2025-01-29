import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:jiffy/app/modules/address/views/address_view.dart';
import 'package:jiffy/app/modules/checkout/model/address_api_response.dart';
import 'package:jiffy/app/modules/global/config/constant.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/search/controllers/search_controller.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../../../main.dart';
import '../../address/controllers/address_controller.dart';
import '../../address/model/address_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../global/controller/controller.dart';
import '../../global/model/model_response.dart';
import '../../help/controllers/help_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../product/controllers/product_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../views/completed.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
RxBool isLoading = false.obs;
RxBool isConfirmingOrder = false.obs;

RxString myShippingAddress = "1".obs;
  final count = 0.obs;
RxString subTotal = "0".obs;
RxString shipping ="0".obs;
RxString discount = "0".obs;
RxString total = "0".obs;




  RxBool isAddressLoading = false.obs;
  @override
  void onInit() {

initCheckout();
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

void assignDefaultAddress(address){

  myShippingAddress.value = address;
}
  void initCheckout()  async {
    isLoading.value = true;
    print("tgetting hevhlou");
    try
    {
      final response = await apiConsumer.post(
        'checkout',

      );


      final apiResponse = ApiDataResponse.fromJson(response);
      if (apiResponse.status == 'success') {

        
        subTotal.value =apiResponse.data['sub_total'].toString();
       shipping.value = apiResponse.data['shipping'].toString();
        discount.value = apiResponse.data['discount'].toString();
        total.value = apiResponse.data['total'].toString();
        print("checkout gotten successful ${total.value}");
        isLoading.value = false;
      }
      else {
        handleApiErrorUser(apiResponse.message);
        handleApiError(response.statusCode);
        print("checkout failed the message is ${apiResponse.message}");
        isLoading.value = false;
        // HapticFeedback.vibrate();
      }

    } catch (e, stackTrace) {
      isLoading.value = false;

      print('checkout failed: ${e} ${stackTrace}');
      // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
      // handleApiErrorUser(apiResponse.message);
      // errorMessage.value = e.toString() ?? "Please Check Fields and Try Again";
      // HapticFeedback.vibrate();
    }

  }


void confirmOrder()  async {
  isConfirmingOrder.value = true;
  try
  {
    final response = await apiConsumer.post(
      'checkout/confirm',
formDataIsEnabled: true,
      formData: FormData.fromMap({
        "payment_method_id" : "2",
        "address_id" : myShippingAddress.value.toString(),
      })

    );


    final apiResponse = ApiDataResponse.fromJson(response);
    if (apiResponse.status == 'success') {

      isConfirmingOrder.value = false;
      cartController.clearCart();

      Get.off(() => const Completed(), );

    }
    else {
      handleApiErrorUser(apiResponse.message);
      handleApiError(response.statusCode);
      print("confirm checkout  failed the message is ${apiResponse.message}");
      isConfirmingOrder.value = false;
      // HapticFeedback.vibrate();
    }

  } catch (e, stackTrace) {
    isConfirmingOrder.value = false;

    print('confirm checkout details  failed: ${e}');
    // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
    // handleApiErrorUser(apiResponse.message);
    // errorMessage.value = e.toString() ?? "Please Check Fields and Try Again";
    // HapticFeedback.vibrate();
  }

}
}
