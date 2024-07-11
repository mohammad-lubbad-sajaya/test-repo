import "package:flutter/material.dart";

import "../theme/app_colors.dart";

Widget customTextField(
    String label, void Function(String)? onChanged,
    {int maxLines = 1, FocusNode? focusNode,FocusNode? nextFocusNode,BuildContext ?context,TextEditingController ?controller,bool enabled=true}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    decoration: BoxDecoration(
     // color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      enabled:enabled ,
      controller: controller,
      focusNode:focusNode,
      onFieldSubmitted: (value) {
        FocusScope.of(context!).unfocus();
          if (nextFocusNode != null&&focusNode!=null) {
          FocusScope.of(focusNode.context!).requestFocus(nextFocusNode); // Move focus to the next field
        }
      },
      
        maxLines: maxLines,
        cursorColor: secondaryColor,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13),
          //labelStyle:  const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)) ,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder:  const OutlineInputBorder(borderSide: BorderSide(color: secondaryColor))
        ),
        onChanged: onChanged),
  );
}
