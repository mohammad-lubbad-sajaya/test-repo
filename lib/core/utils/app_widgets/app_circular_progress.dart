import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Widget appCircularProgress({
  double? width,
  double? height,
  double? strokeWidth,
}) =>
    SizedBox(
      width: width ?? 20,
      height: height ?? 20,
      child: CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: strokeWidth ?? 2.0,
        backgroundColor: secondaryColor,
      ),
    );
