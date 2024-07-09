import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../../../features/crm/data/models/event_count.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget dropDownButton({
  double? height,
  //double? width,
  String? hintText,
  Color backgroundColor = Colors.white,
  required List<EventCount>? items,
  String? selectedItem,
  double horizontalPadding = 20,
  bool isEnabled = true,
  required Function(String?) didSelectItem,
}) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
      height: height ?? 56,
      //width: width,
      decoration: const BoxDecoration(
        color: textFieldBgColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          enableFeedback: isEnabled,
          isExpanded: true,
          value: selectedItem,
          hint: customTextApp(
            text: hintText?.converStringToDate() ?? "--",
            fontWeight: FontWeight.normal,
            color: Colors.black,
            size: 15,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          style: const TextStyle(
            color: primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          items: items?.map<DropdownMenuItem<String>>((EventCount value) {
            return DropdownMenuItem<String>(
              enabled: isEnabled,
              value: value.eventDate?.converStringToDate(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customTextApp(
                    text: value.eventDate?.converStringToDate() ?? "",
                    fontWeight: FontWeight.normal,
                    color: (value.eventDate?.dateIsPast ?? false)
                        ? Colors.red
                        : Colors.black,
                    size: 15,
                  ),
                  customTextApp(
                    text: "${value.eventCount ?? ""}",
                    fontWeight: FontWeight.normal,
                    color: (value.eventDate?.dateIsPast ?? false)
                        ? Colors.red
                        : Colors.black,
                    size: 15,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: didSelectItem,
        ),
      ),
    );
