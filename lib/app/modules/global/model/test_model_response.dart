import 'model_response.dart';

class ProductColor {
  int? id;
  String? name;
  String? hex;
  List<String>? images;

  ProductColor({this.id, this.name, this.hex});

  ProductColor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    hex = json['hex'];
    images =
        json['images'] == null ? [] : List<String>.from(json['images'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hex'] = this.hex;
    data['images'] = this.images;

    return data;
  }
}

class CustomHomeModel {
  String? status;
  String? message;
  HomeData? data;

  CustomHomeModel({this.status, this.message, this.data});

  CustomHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class TestData {
  List<Null>? setting;
  int? totalPoints;
  List<Categories>? categories;
  List<Brands>? brands;
  List<Banners>? banners;
  List<ViewProductData>? product;

  TestData(
      {this.setting,
      this.totalPoints,
      this.categories,
      this.brands,
      this.banners,
      this.product});

  TestData.fromJson(Map<String, dynamic> json) {
    if (json['setting'] != null) {
      setting = <Null>[];
      json['setting'].forEach((v) {
        // setting!.add(new Null.fromJson(v));
      });
    }
    totalPoints = json['total_points'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = <ViewProductData>[];
      json['product'].forEach((v) {
        product!.add(ViewProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.setting != null) {
      // data['setting'] = this.setting!.map((v) => v!.toJson()).toList();
    }
    data['total_points'] = this.totalPoints;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String? image;

  Banners({this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}

class Product {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final dynamic price;
  final dynamic old_price;
  final dynamic size;
  final dynamic outOfStock;
  final dynamic rating;
  final dynamic d_limit;
  final dynamic sd_limit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.old_price,
    required this.size,
    required this.outOfStock,
    required this.rating,
    required this.d_limit,
    required this.sd_limit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] != null ? json['price'] : json['sd_price'],
      size: json['size'] != null ? json['size'] : null,
      old_price:
          json['old_price'] != null ? json['old_price'] : json['d_price'],
      outOfStock: json['out_of_stock'] ?? 0,
      rating: json['rating'] ?? 0.0,
      d_limit: json['d_limit'] ?? 0,
      sd_limit: json['sd_limit'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'old_price': old_price,
      'size': size,
      'out_of_stock': outOfStock,
      'rating': rating,
      'sd_limit': sd_limit,
      'd_limit': d_limit,
    };
  }
}

class ViewProduct {
  String? status;
  String? message;
  ViewProductData? data;

  ViewProduct({this.status, this.message, this.data});

  ViewProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ViewProductData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ColorData {
  int? id;
  String? name;
  String? hex;

  ColorData({this.id, this.name, this.hex});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      id: json['id'],
      name: json['name'],
      hex: json['hex'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['hex'] = this.hex;
    return data;
  }
}

class ViewProductData {
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic image;
  final dynamic price;
  final dynamic old_price;
  final dynamic size;
  final dynamic outOfStock;
  final dynamic rating;
  final dynamic ratings_count;
  final dynamic rating_percentages;
  ViewProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.old_price,
    required this.size,
    required this.outOfStock,
    required this.rating,
    this.ratings_count,
    this.rating_percentages,
  });

  factory ViewProductData.fromJson(Map<String, dynamic> json) {
    return ViewProductData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      rating: json['rating'],
      price: json['price'],
      old_price: json['old_price'] ?? null,
      size: json['size'],
      outOfStock: json['out_of_stock'] ?? null,
      ratings_count: json['ratings_count'] ?? null,
      rating_percentages: json['rating_percentages'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['old_price'] = this.old_price;
    data['size'] = this.size;
    data['out_of_stock'] = this.outOfStock;
    data['rating'] = this.rating;
    data['ratings_count'] = this.ratings_count;
    data['rating_percentages'] = this.rating_percentages;

    return data;
  }
}

class Unit {
  int? id;
  String? name;

  Unit({this.id, this.name});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

// class Category {
//   int? id;
//   String? name;
//   String? slug;
//   String? image;
//
//   Category({this.id, this.name, this.slug, this.image});
//
//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     slug = json['slug'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['slug'] = this.slug;
//     data['image'] = this.image;
//     return data;
//   }
// }

class Attachments {
  String? type;
  String? name;
  String? path;

  Attachments({this.type, this.name, this.path});

  Attachments.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}

class Setting {
  final String homeVideo;

  Setting({
    required this.homeVideo,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      homeVideo: json['home_video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home_video': homeVideo,
    };
  }
}

class HomeData {
  List<Setting>? setting;
  int? totalPoints;
  List<Categories>? categories;
  List<Brands>? brands;
  List<Banners>? banners;
  List<ViewProductData>? product;

  HomeData({
    this.setting,
    this.totalPoints,
    this.categories,
    this.brands,
    this.banners,
    this.product,
  });

  // Factory constructor for creating a new HomeData instance from JSON
  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      setting: json['setting'] != null
          ? (json['setting'] as List).map((i) => Setting.fromJson(i)).toList()
          : null,
      totalPoints: json['total_points'],
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((i) => Categories.fromJson(i))
              .toList()
          : null,
      brands: json['brands'] != null
          ? (json['brands'] as List).map((i) => Brands.fromJson(i)).toList()
          : null,
      banners: json['banners'] != null
          ? (json['banners'] as List).map((i) => Banners.fromJson(i)).toList()
          : null,
      product: json['product'] != null
          ? (json['product'] as List)
              .map((i) => ViewProductData.fromJson(i))
              .toList()
          : null,
    );
  }

  // Method to convert HomeData instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'setting': setting?.map((i) => i.toJson()).toList(),
      'total_points': totalPoints,
      'categories': categories?.map((i) => i.toJson()).toList(),
      'brands': brands?.map((i) => i.toJson()).toList(),
      'banners': banners?.map((i) => i.toJson()).toList(),
      'product': product?.map((i) => i.toJson()).toList(),
    };
  }
}
