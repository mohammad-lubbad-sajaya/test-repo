import "package:flutter/material.dart";
import "../../services/extentions.dart";

import "../theme/app_colors.dart";
import "custom_app_text.dart";

Widget buildCheckBoxView(
    {
     required bool value,
  required  bool isDark,
   required void Function() onTap,
    String? title}) {
  return Row(
    children: [
      InkWell(
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: value?secondaryColor:null,
              border: Border.all(color:value? secondaryColor:Colors.black, width: 1.3),
                borderRadius: BorderRadius.circular(4)),
            child: value
                ? const Center(
                    child: Icon(
                      Icons.check,
                      color: backGroundColor,
                      size: 15,
                    ),
                  )
                : Container(),
          ),
          onTap: onTap),
      const SizedBox(width: 10),
      customTextApp(
        color: isDark ? backGroundColor : Colors.black,
        text: title ?? "Remember me".localized(),
        size: 15,
      ),
    ],
  );
}
