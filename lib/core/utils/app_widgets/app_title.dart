import 'package:flutter/material.dart';

import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';


Widget appTitle({
  required String text,
  required bool isDark,
  void Function()? onTap
}) =>
    Row(
      children: [
        InkWell(
          onTap:onTap,
          child: Image.asset(smallLogo, width: 32)),
        const SizedBox(width: 15),
        customTextApp(
          color:isDark?lineColor:Colors.black ,
          text: text,
          size: 18,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
