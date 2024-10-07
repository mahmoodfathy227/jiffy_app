
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

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