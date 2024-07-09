import 'package:flutter/material.dart';

import '../../../features/crm/data/models/drop_down_obj.dart';
import '../../services/app_translations/app_translations.dart';
import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget dropDownHorizontalButton({
  double? height,
  double? width,
  String? hintText,
  bool isDark=false,
  Color backgroundColor = Colors.white,
  required List<DropdownObj>? items,
  String? selectedItem,
  double horizontalPadding = 0,
  bool isEnabled = true,
  bool isBold = false,
  Color? selectedColor,
  Color? separatorColor,
  bool hideSeparator = false,
  required Function(String?) didSelectItem,
  void Function()? onTap,
}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customTextApp(
              text: hintText ?? "-",
              size: 16,
              color: isDark?backgroundColor:Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 6),
                height: height ?? 31,
                // width: width,
                decoration: BoxDecoration(
                  color:isDark?darkDialogsColor: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: isDark?darkCardColor:null,
                    enableFeedback: isEnabled,
                    isExpanded: true,
                    value: selectedItem,
                 
                    elevation: 4,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    icon: Image.asset(
                      color: isDark?backGroundColor:Colors.black,
                      downArrow,
                      width: 9,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: selectedColor ?? subTitleColor,
                    ),
                    items: items
                        ?.map<DropdownMenuItem<String>>((DropdownObj value) {
                      return DropdownMenuItem<String>(
                        enabled: isEnabled,
                        value: value.id,
                        child: Row(
                          children: [
                            //const Spacer(),
                            Expanded(
                              child: customTextApp(
                                align: isEnglish()
                                    ? TextAlign.right
                                    : TextAlign.left,
                                maxLine: 3,
                                text: value.name ?? "",
                                size: 14,
                                fontWeight: FontWeight.normal,
                                color:isDark?backGroundColor: selectedColor ?? subTitleColor,

                                //selectedItem == value.id
                                //  ? primaryColor
                                // : textFiledBackgroundColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: didSelectItem,

                    onTap: onTap,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (hideSeparator == false) ...[
          const SizedBox(height: 8),
          Container(
            height: 0.5,
            color: separatorColor ?? lineColor,
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
