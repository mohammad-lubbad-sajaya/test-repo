import 'package:flutter/material.dart';
import '../../services/app_translations/app_translations.dart';

import '../../../features/crm/data/models/drop_down_obj.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';


dropDownHorizontalButton({
  double? height,
  double? width,
  String? hintText,
  required bool isDark ,
  bool isIgnore = false,
  Color backgroundColor = Colors.white,
  required List<DropdownObj>? items,
  String? selectedItem,
  double horizontalPadding = 0,
  bool isEnabled = true,
  bool isBold = false,
  Color? selectedColor,
  Color? separatorColor,
  bool hideSeparator = true,
  required Function(String?) didSelectItem,
  void Function()? onTap,
}) {
  return Container(
    height: 50,
    //width: ,
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    decoration: BoxDecoration(
      color: isDark ? darkDialogsColor : Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: IgnorePointer(
      ignoring: isIgnore,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration.collapsed(hintText: ''),
          value: selectedItem,
          dropdownColor: isDark ? darkDialogsColor : Colors.grey[200],
          iconEnabledColor: isIgnore ? Colors.grey : null,
          hint: Text(
            hintText ?? "",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? backGroundColor : selectedColor ?? subTitleColor,
            ),
          ),
          items: items?.map((DropdownObj item) {
            return DropdownMenuItem<String>(
              value: item.id,
              child: SizedBox(
                width: 280,
                child: Align(
                  alignment: isEnglish()
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: customTextApp(
                    align: isEnglish() ? TextAlign.right : TextAlign.left,
                    maxLine: 3,
                    text: item.name ?? "",
                    size: 14,
                    fontWeight: FontWeight.normal,
                    color: isDark
                        ? backGroundColor
                        : selectedColor ?? subTitleColor,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: didSelectItem,
          onTap: onTap,
        ),
      ),
    ),
  );
}
