import 'package:flutter/material.dart';

import '../../../features/crm/data/models/drop_down_obj.dart';
import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget dropDownVerticalButton({
  double? height,
  double? width,
  String? hintText,
  bool isDark = false,
  Color backgroundColor = Colors.white,
  required List<DropdownObj>? items,
  String? selectedItem,
  double horizontalPadding = 0,
  bool isEnabled = true,
  Color? separatorColor,
  bool hideSeparator = false,
  required Function(String?) didSelectItem,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextApp(
          text: hintText ?? "-",
          size: 16,
          color: isDark ? backgroundColor : Colors.black,
          fontWeight: FontWeight.normal,
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          height: height ?? 30,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              enableFeedback: isEnabled,
              isExpanded: true,
              value: selectedItem ?? items?[0].id.toString(),
              hint: customTextApp(
                text: hintText ?? "--",
                size: 14,
                fontWeight: FontWeight.normal,
                color: subTitleColor,
              ),
              elevation: 4,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              icon: Image.asset(
                color: isDark ? backgroundColor : Colors.black,
                downArrow,
                width: 9,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: subTitleColor,
              ),
              items: items?.map<DropdownMenuItem<String>>((DropdownObj value) {
                return DropdownMenuItem<String>(
                  enabled: isEnabled,
                  value: "${value.id}",
                  child: customTextApp(
                    text: value.name ?? "",
                    size: 14,
                    fontWeight: FontWeight.normal,
                    color: subTitleColor,

                    //selectedItem == value.id
                    //  ? primaryColor
                    // : textFiledBackgroundColor,
                  ),
                );
              }).toList(),
              onChanged: didSelectItem,
            ),
          ),
        ),
        if (hideSeparator == false) ...[
          const SizedBox(height: 4),
          Container(
            height: 0.5,
            color: separatorColor ?? lineColor,
          ),
        ],
      ],
    );
