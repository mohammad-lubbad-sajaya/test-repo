import 'package:flutter/material.dart';

import '../../services/extentions.dart';
import '../common_widgets/custom_app_text_field.dart';
import '../constants/images.dart';
import '../theme/app_colors.dart';


Widget showSearchProcedures({
  dynamic Function(String)? onChanged,
  TextEditingController? textController,
  Color? bgColor,
  bool isDark=false,
  double? horizontalPadding,
  String? hintText,
  Image? suffixIcon,
  FocusNode? focusNode,
  Function()? suffixIconAction,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 20,
        vertical: 10,
      ),
      child: customAppTextField(
        textColor: isDark?backGroundColor:Colors.black,
        borderColor: isDark?Colors.transparent:textFieldBgColor,
        textController: textController,
        bgColor: bgColor ?? textFieldBgColor,
        hintText: hintText ?? "Search Procedures".localized(),
        prefixNewIcon: Image.asset(search),
        onChanged: onChanged,
        suffixIcon: suffixIcon,
        suffixIconAction: suffixIconAction,
        focusNode: focusNode,
      ),
    );
