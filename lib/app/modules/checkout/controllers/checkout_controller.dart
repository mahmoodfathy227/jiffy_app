import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:jiffy/app/modules/address/views/address_view.dart';
import 'package:jiffy/app/modules/checkout/model/address_api_response.dart';
import 'package:jiffy/app/modules/global/config/constant.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/app/modules/services/api_service.dart';

import '../../../../main.dart';
import '../../address/model/address_model.dart';
import '../../global/model/model_response.dart';
import '../views/completed.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController
RxBool isLoading = false.obs;
RxBool isConfirmingOrder = false.obs;

RxString myShippingAddress = "1".obs;
  final count = 0.obs;
  RxInt subTotal = 0.obs;
RxInt shipping = 0.obs;
RxInt discount = 0.obs;
RxInt total = 0.obs;



var cartProducts = <CartProduct>[


].obs;
  RxBool isAddressLoading = false.obs;
  @override
  void onInit() {
    getCartDetails();
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
    try
    {
      final response = await apiConsumer.post(
        'checkout',

      );


      final apiResponse = ApiDataResponse.fromJson(response);
      if (apiResponse.status == 'success') {
        print("checkout gotten successful");
        
        subTotal.value =apiResponse.data['sub_total'];
       shipping.value = apiResponse.data['shipping'];
        discount.value = apiResponse.data['discount'];
        total.value = apiResponse.data['total'];

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

      print('checkout failed: ${e}');
      // final apiResponse = ApiResponse.fromJson(jsonDecode(e.toString()));
      // handleApiErrorUser(apiResponse.message);
      // errorMessage.value = e.toString() ?? "Please Check Fields and Try Again";
      // HapticFeedback.vibrate();
    }

  }
void getCartDetails()  async {
  isLoading.value = true;
  try
  {
    final response = await apiConsumer.post(
      'cart/details',

    );

    isLoading.value = true;
    final apiResponse = ApiDataResponse.fromJson(response);
    if (apiResponse.status == 'success') {
      print("cart details gotten successful");
for(var product in apiResponse.data['items']){
  print("your product is ${product['product_id']}");
  cartProducts.add(CartProduct.fromJson(product));
}
print("your cart items are ${cartProducts.first.product?.image}");
      isLoading.value = false;

    }
    else {
      handleApiErrorUser(apiResponse.message);
      handleApiError(response.statusCode);
      print("cart details  failed the message is ${apiResponse.message}");
      isLoading.value = false;
      // HapticFeedback.vibrate();
    }

  } catch (e, stackTrace) {
    isLoading.value = false;

    print('cart details  failed: ${e}');
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
      print("confirm checkout gotten successful");
      isConfirmingOrder.value = false;
      Get.offAll(() => const Completed());

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
