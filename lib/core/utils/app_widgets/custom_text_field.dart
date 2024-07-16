import "package:flutter/material.dart";

import "../theme/app_colors.dart";

Widget customTextField(String label, void Function(String)? onChanged,
    {int maxLines = 1,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    BuildContext? context,
    Color?bgColor,
    int ?maxLength,
    TextInputType? keyboardType = TextInputType.text,
    TextEditingController? controller,
    bool enabled = true,
    bool isDark=false,
    }) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    decoration: BoxDecoration(
      // color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        onFieldSubmitted: (value) {
          FocusScope.of(context!).unfocus();
          if (nextFocusNode != null && focusNode != null) {
            FocusScope.of(focusNode.context!)
                .requestFocus(nextFocusNode); // Move focus to the next field
          }
        },
        maxLines: maxLines,
        maxLength: maxLength,
        cursorColor: secondaryColor,
        style:  TextStyle(fontSize: 13, color:isDark ? backGroundColor : Colors.black,),
        decoration: InputDecoration(
            labelText: label,
            fillColor:bgColor ,
            labelStyle:  TextStyle(fontSize: 13,color:isDark ? backGroundColor : Colors.black,),
            counterStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor))),
        onChanged: onChanged),
  );
}
