import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';

const APP_NAME = 'jiffy';
var defaultPrimaryColor = Color(0xFF4F0099);

const DOMAIN_URL =
    'https://jiffy.genixarea.pro'; // Don't add slash at the end of the url
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';
const LOGO = 'assets/images/logo.svg';
const String cachedRandomQuote = 'CACHED_RANDOM_QUOTE';
const String contentType = 'Content-Type';
const String applicationJson = 'application/json';
const String serverFailure = 'Server Failure';
const String cacheFailure = 'Cache Failure';
const String networkError = 'Network Error';
const String unexpectedError = 'Unexpected Error';
const String unAuthorizedFailure = 'unAuthorizedFailures';

final smallSpacing = 5.w;
final crossAxisSpacing = 5.w;
final mainAxisSpacing = 15.w;
const heightDevidedRatio = 0.81;
final productsSectionHeight = 300.h;

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
