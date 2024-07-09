import 'package:flutter/material.dart';

import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';


Widget appTitle({
  required String text,
  required bool isDark
}) =>
    Row(
      children: [
        Image.asset(smallLogo, width: 32),
        const SizedBox(width: 15),
        customTextApp(
          color:isDark?lineColor:Colors.black ,
          text: text,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
