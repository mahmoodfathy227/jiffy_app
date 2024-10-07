
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../theme/app_theme.dart';
final kDefaultPadding = 16.0.w;
TextStyle errorTextStyle = secondaryTextStyle(color: Colors.red,
    size: 12.sp.round(),
    weight: FontWeight.w300

);

BoxShadow customBoxShadow = BoxShadow(
  color: Colors.black.withOpacity(0.1),
  spreadRadius: 2,
  blurRadius: 7,
  offset: const Offset(0, 3), // changes position of shadow
);

Future<bool> onLikeButtonTapped(bool isLiked, dynamic product) async {
  try {
    // Check if the product is in the wishlist
    if (wishListController.isProductInWishList(product.id)) {
      // Remove from wishlist
      wishListController.wishlistProductIds
          .removeWhere((item) => item == product.id);
      wishListController.removeFromWishlist(product.id!);
    } else {
      // Add to wishlist
      wishListController.wishlistProductIds!.value.add(product.id);
      wishListController.addToWishlist(product.id);
    }
    return false;
    // Return the updated liked state (toggle)
  } catch (e) {
    return false;


  }
}