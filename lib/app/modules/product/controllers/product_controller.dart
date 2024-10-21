import 'package:get/get.dart';

class ProductController extends GetxController {
  // قائمة المنتجات
  var products = [].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() {
    // يمكنك هنا جلب البيانات من API أو قاعدة البيانات
    var serverResponse = [
      {"name": "Product 1", "price": 18.20, "inStock": true},
      {"name": "Product 2", "price": 15.00, "inStock": false},
      {"name": "Product 3", "price": 20.00, "inStock": true},
    ];

    products.value = serverResponse;
  }
}
