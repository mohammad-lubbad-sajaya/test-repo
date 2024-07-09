import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';


Widget customAppTextField({
  TextEditingController? textController,
  String? initialValue,
  required String hintText,
  String? labelText,
  String? errorText,
  Image? prefixNewIcon,
  Image? suffixIcon,
  Color bgColor = textFieldBgColor,
  Color placeHolderColor = placeHolderColor,
  Color borderColor = textFieldBorderColor,
  Color fontColor = Colors.white,
  Color textColor = Colors.black,
  TextAlign textAlign = TextAlign.justify,
  double fontSize = 16,
  double contentVerticalPadding = 16,
  double contentHorizontalPadding = 30,
  FocusNode? focusNode,
  bool autofocus = false,
  FontWeight fontWeight = FontWeight.bold,
  bool isDropDown = false,
  bool isEnabled = true,
  void Function(String)? onFieldSubmitted,
  bool isExpand = false,
  bool isObscureText = false,
  TextInputType? keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onChanged,
  Function()? suffixIconAction,
  String? Function(String?)? validator,
  int? maxLength,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: isExpand ? 0 : 6),
      child: TextFormField(
        initialValue: initialValue,
        controller: textController,
        focusNode: focusNode,
        onFieldSubmitted:onFieldSubmitted ,
        validator: validator,
        autofocus: autofocus,
        enabled: isEnabled,
        obscureText: isObscureText,
        keyboardType: isExpand ? TextInputType.multiline : keyboardType,
        maxLines: isExpand ? 5 : 1,
        //expands: isExpand,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterStyle:TextStyle(color: textColor) ,
          prefixIcon: prefixNewIcon,
          errorText: errorText,
          suffixIcon: isDropDown
              ? const Icon(Icons.keyboard_arrow_down)
              : (suffixIcon != null)
                  ? InkWell(
                      onTap: suffixIconAction,
                      child: SizedBox(
                        height: 4,
                        width: 4,
                        child: suffixIcon,
                      ),
                    )
                  : null,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondaryColor),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(16.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: contentVerticalPadding,
            horizontal: contentHorizontalPadding,
          ),
          filled: true,
          fillColor: bgColor,
          floatingLabelStyle: TextStyle(
            color: secondaryColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
          
          labelStyle: TextStyle(
            color: placeHolderColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: TextStyle(
            color: placeHolderColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText ?? hintText,
          hintText: hintText,
        ),
        style: TextStyle(
          color:textColor,
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
        ),
        textAlign: textAlign,
        onChanged: onChanged,
      ),
    );
