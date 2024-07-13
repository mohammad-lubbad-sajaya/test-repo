import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

Widget customAppTextField2({
  TextEditingController? textController,
  String? initialValue,
  required String hintText,
  String? labelText,
  String? errorText,
  Image? prefixNewIcon,
  Image? suffixIcon,
  Color bgColor = textFieldBgColor,
  Color textColor=Colors.black,
  Color placeHolderColor = placeHolderColor,
  Color borderColor = textFieldBorderColor,
  Color fontColor = Colors.white,
  TextAlign textAlign = TextAlign.justify,
  double fontSize = 16,
  double contentHorizontalPadding = 30,
  FocusNode? focusNode,
  bool autofocus = false,
  FontWeight fontWeight = FontWeight.bold,
  bool isDropDown = false,
  bool isEnabled = true,
  bool isExpand = false,
  bool isObscureText = false,
  TextInputType? keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onChanged,
  Function()? suffixIconAction,
  String? Function(String?)? validator,
  int? maxLength,
}) =>
    SizedBox(
      height: 44,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isExpand ? 0 : 6),
        child: TextFormField(
          initialValue: initialValue,
          controller: textController,
          focusNode: focusNode,
          validator: validator,
          autofocus: autofocus,
          enabled: isEnabled,
          obscureText: isObscureText,
          keyboardType: isExpand ? TextInputType.multiline : keyboardType,

          maxLines: isExpand ? 5 : 1,
          //expands: isExpand,
          maxLength: maxLength,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : inputFormatters,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: prefixNewIcon,
            errorText: errorText,
            labelStyle: TextStyle(
              color: const Color(0xFF424242),
              fontSize: fontSize,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: secondaryColor),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: contentHorizontalPadding,
            ),
            floatingLabelStyle: TextStyle(
              color: secondaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(
              color: placeHolderColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            hintText: hintText,
            labelText: labelText ?? hintText,
          ),

          style: TextStyle(
            color:textColor,
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
          textAlign: textAlign,
          onChanged: onChanged,
        ),
      ),
    );
