class Product {
  final String name;
  final String imageUrl;
  final double weight;
  final double price;
  final double? oldPrice; // For showing the discounted price
  final bool inStock;
  final double? discount; // Percentage of discount

  Product({
    required this.name,
    required this.imageUrl,
    required this.weight,
    required this.price,
    this.oldPrice,
    this.inStock = true,
    this.discount,
  });
}
