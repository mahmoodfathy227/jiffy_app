import 'dart:ffi';

import 'package:get/get.dart';
import 'package:jiffy/app/modules/global/model/test_model_response.dart';
import 'package:jiffy/main.dart';

import 'package:get_storage/get_storage.dart';

import 'dart:convert';

import '../../services/api_service.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var step = ''.obs;
  var selectedMethod = ''.obs;
  var loading = true.obs;
  var couponCode = ''.obs;
  RxBool isSharing = false.obs;

  startSharing() {
    isSharing.value = true; 
  }

  endSharing() {
    isSharing.value = false;
  }

  var giftCardCode = ''.obs;
  var discount = Rx<dynamic>(0);
  var subTotal = Rx<dynamic>(0);
  var shipping = Rx<dynamic>(0);
  var total = Rx<dynamic>(0);
  var giftCardValue = Rx<dynamic>(0);
  var couponValue = Rx<dynamic>(0);
  var shippingID = ''.obs;
  var coupon = ''.obs;
  var giftCardID = ''.obs;
  final box = GetStorage();
  RxBool isAuth = false.obs;
  RxBool shareLoading = false.obs;
  bool isProductInCart(Product product) {
    return cartItems.any((element) => element.product.id == product.id);
  }

  void toggleDismissible(int index) {
    print('tesdsadsad');
    cartItems[index].isDismissible = !cartItems[index].isDismissible;
    cartItems.refresh();
  }

  @override
  void onInit() async {
    if (userToken == null) {
      isAuth.value = false;
    } else {
      isAuth.value = true;
      super.onInit();
      selectedMethod.value = "Cash";
      //  addressController.fetchAddresses();

      bool cachedCart = await loadCartItems();
      if (!cachedCart) {
        print('retrived cart from api');
        fetchCartDetailsFromAPI();
      } else {
        //  fetchCartDetailsFromAPI(); // Fetch updated data in the background
      }
      print('Initialized');
    }
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<String> confirmCheckout(String paymentMethodId) async {
    loading.value = true;
    try {
      final response = await apiConsumer.post(
        'checkout/confirm',
        body: {
          'address_id': shippingID.value,
          'shipping_id': '1',
          'payment_method_id': paymentMethodId == "Cash" ? "1" : '2',
        },
      );

      if (response['status'] == 'success') {
        // Handle success response
        print('Checkout confirmed successfully');
        clearCart();
        couponCode.value = '';
        loading.value = false;

        Get.snackbar('Success', 'Checkout confirmed successfully');
        return 'true';
      } else {
        loading.value = false;

        // Handle error response
        print('Failed to confirm checkout: ${response['message']}');
        Get.snackbar(
            'Error', 'Failed to confirm checkout: ${response['message']}');
      }
    } catch (e) {
      print('Error confirming checkout: $e');
      loading.value = false;

      Get.snackbar('Error', 'Failed to confirm checkout');
      return 'false';
    }
    return 'false';
  }

  Future<void> fetchCartDetailsFromAPI() async {
    loading.value = true;
    try {
      final response = await apiConsumer.post('cart/details');

      if (response['status'] == 'success') {
        List<dynamic> items = response['data']['items'];
        total.value = response['data']['total'];
        print(total.value.toString() + 'test total value');

        // Update current cart items from API data
        List<CartItem> apiCartItems =
            items.map((e) => CartItem.fromJson(e)).toList();
        cartItems.assignAll(apiCartItems);

        // Retrieve cached cart items
        List<CartItem> cachedCartItems = getCacheCartDetails();

        // Remove items from cache that are not present in API cart details
        cachedCartItems.removeWhere((cachedItem) => !apiCartItems
            .any((apiItem) => apiItem.product.id == cachedItem.product.id));

        // Update the cache with the remaining items
        saveCartItemsToCache(cachedCartItems);

        cartItems.refresh(); // Ensure the UI is updated

        loading.value = false;
        update();
      } else {
        print('Failed to fetch cart details: ${response['data']}');
        loading.value = false;
        update();
      }
    } catch (e) {
      print('Error fetching cart details: $e');
      loading.value = false;
      update();
    }
  }

  List<CartItem> getCacheCartDetails() {
    List<dynamic> storedItems = box.read<List<dynamic>>('cartItems') ?? [];
    return storedItems.map((e) => CartItem.fromJson(json.decode(e))).toList();
  }

// Save cart items to cache
  void saveCartItemsToCache(List<CartItem> items) {
    List<String> itemsJson = items.map((e) => json.encode(e.toJson())).toList();
    box.write('cartItems', itemsJson);
  }

  Future<void> checkoutApi() async {
    try {
      final response = await apiConsumer.post(
        'checkout',
        // body: {
        //   'shipping_id': shippingID.value,
        // },
      );

      if (response['status'] == 'success') {
        print('Checkout successful');
        clearCart();
        // Handle successful checkout logic here
      } else {
        print('Failed to checkout: ${response['data']}');
      }
    } catch (e) {
      print('Error during checkout: $e');
    }
  }

  Future<void> applyCoupon(String code) async {
    loading.value = true;
    print(code + 'code valid');
    try {
      final response = await apiConsumer
          .post('orders/apply-coupon/$code', body: {'code': code});

      if (response['status'] == 'success') {
        couponCode.value = code;
        await fetchCheckoutDetails(); // استدعاء البيانات المحدّثة
      } else {
        Get.snackbar('Error', '${response['message']}');

        print('Failed to apply coupon: ${response['data']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Coupon Code is invalid');

      print(' code is invalid: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeCoupon() async {
    loading.value = true;
    try {
      final response = await apiConsumer.post(
          'orders/remove-coupon/${couponCode.value}',
          body: {'code': couponCode.value});

      if (response['status'] == 'success') {
        couponCode.value = '';
        await fetchCheckoutDetails(); // استدعاء البيانات المحدّثة
      } else {
        print('Failed to remove coupon: ${response['data']}');
      }
    } catch (e) {
      print('Error removing coupon: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> applyGiftCard(String id) async {
    loading.value = true;
    try {
      final response =
          await apiConsumer.post('checkout/apply-gift-card', body: {
        'gift_card_id': id,
      });

      if (response['status'] == 'success') {
        giftCardCode.value = id;
        await fetchCheckoutDetails(); // Get summery updated
      } else {
        print('Failed to apply gift card: ${response['data']}');
      }
    } catch (e) {
      print('Error applying gift card: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeGiftCard() async {
    loading.value = true;
    try {
      final response =
          await apiConsumer.post('checkout/remove-gift-card', body: {
        'gift_card_id': giftCardID.value,
      });

      if (response['status'] == 'success') {
        giftCardCode.value = '';
        await fetchCheckoutDetails(); // استدعاء البيانات المحدّثة
      } else {
        print('Failed to remove gift card: ${response['data']}');
      }
    } catch (e) {
      print('Error removing gift card: $e');
    } finally {
      loading.value = false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> fetchCheckoutDetails({int shipping_id = 1}) async {
    try {
      final response = await apiConsumer
          .post('checkout', body: {'shipping_id': shipping_id});

      if (response['status'] == 'success') {
        subTotal.value = (response['data']['sub_total'] as num).toDouble();
        shipping.value = (response['data']['shipping'] as num).toDouble();
        discount.value = (response['data']['discount'] as num).toDouble();
        couponValue.value =
            (response['data']['coupon_value'] as num).toDouble();
        giftCardValue.value = (response['data']['giftCard'] as num).toDouble();
        total.value = (response['data']['total'] as num).toDouble();
        couponCode.value = response['data']['coupon'] ?? '';
        update();
      } else {
        print('Failed to fetch checkout details: ${response['data']}');
      }
    } catch (e) {
      print('Error fetching checkout details: $e');
    }
  }

  Future<bool> loadCartItems() async {
    print('times');
    loading.value = true;

    // ignore: await_only_futures
    List<dynamic> storedItems =
        await box.read<List<dynamic>>('cartItems') ?? [];
    if (storedItems.isNotEmpty) {
      try {
        cartItems.assignAll(
            storedItems.map((e) => CartItem.fromJson(json.decode(e))).toList());
        print('cartItems cached retrived');
        loading.value = false;
        update();
        return true;
      } catch (e) {
        print('Error cartItems cached retrived');
        loading.value = false;
        update();
        return false;
      }
    } else {
      print('not found cartItems cached');
      loading.value = false;
      update();
      return false;
    }
  }

  void saveCartItems() {
    List<String> items = cartItems.map((e) => json.encode(e.toJson())).toList();
    try {
      box.write('cartItems', items);
      print("cart items 4 ${cartItems}");
    } catch (e, stackTrace) {
      print(e.toString() + ' test save items cached ' + stackTrace.toString());
      return;
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    var existingItem =
        cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity += quantity;
    } else {
      cartItems.add(CartItem(product: product, quantity: quantity));
    }
    cartItems.refresh(); // Ensure the UI is updated
    print("cart items 2 ${cartItems}");
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.post(
        'cart',
        body: {
          'product_id': product.id,
          'qty': quantity,
        },
      );

      if (response['status'] == 'success') {
        print("product added sussefully");
        print("cart items 3 ${cartItems}");
        cartItems.refresh(); // Ensure the UI is updated
      } else {
        print('Failed to add to cart: ${response['data']}');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> removeItem(CartItem item) async {
    cartItems.remove(item);
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.post(
        'cart/remove',
        body: {'id': item.product.id},
      );

      if (response['status'] == 'success') {
      } else {
        print('Failed to remove item: ${response['data']}');
      }
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    try {
      final response = await apiConsumer.post(
        'cart/update-qty',
        body: {'id': item.product.id, 'qty': quantity},
      );

      if (response['status'] == 'success') {
        item.quantity = quantity;
        cartItems.refresh(); // Ensure the UI is updated
        saveCartItems();
        update();
      } else {
        print('Failed to update quantity: ${response['data']}');
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    saveCartItems();
    update();
    try {
      final response = await apiConsumer.delete('cart');

      if (response['status'] == 'success') {
      } else {
        print('Failed to clear cart: ${response['data']}');
      }
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}

class CartItem {
  final Product product;
  int quantity;

  bool isDismissible;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isDismissible = false,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
