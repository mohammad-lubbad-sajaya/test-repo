import 'package:flutter/material.dart';

import '../../services/app_translations/app_translations.dart';
import '../common_widgets/custom_app_text_field_2.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget customRowApp({
  required String text,
  bool isBold = false,
  bool isDark = false,
  String? subText,
  double fontSize=16,
  IconData? icon,
  String? image,
  double? imageWidth,
  bool? imageMatchTextDirection,
  Color? subTitleTextColor,
  Color? separatorColor,
  bool hideSeparator = false,
  bool isTextField = false,
  bool isReadOnly=false,
  int flex = 2,
  TextInputType? keyboardType = TextInputType.text,
  final VoidCallback? onTap,
  final VoidCallback? onImageTap,
  Function(String)? onChanged,
  int? maxLength,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(vertical: isTextField ? 0 : 8),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: customTextApp(
                    color: isDark ? backGroundColor :isReadOnly?Colors.grey: Colors.black,
                    text: text,
                    maxLine: null,
                    size: fontSize,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 5),
                if (isTextField) ...[
                  Expanded(
                    flex: flex,
                    child: customAppTextField2(
                      keyboardType: keyboardType,
                      textColor: isDark?backGroundColor:Colors.black,
                      textController:
                          TextEditingController(text: subText ?? ""),
                      contentHorizontalPadding: 12,
                      fontSize: 12,
                      
                      hintText: "",
                      onChanged: onChanged,
                      maxLength: maxLength,
                    ),
                  )
                ] else ...[
                  Expanded(
                    flex: flex,
                    child: Row(
                      children: [
                        icon != null ? const Spacer() : Container(),
                        icon != null
                            ? Icon(
                                icon,
                                color: isDark ? backGroundColor : Colors.black,
                              )
                            : Expanded(
                                child: customTextApp(
                                  text: subText ?? "",
                                  size: fontSize,
                                  maxLine: null,
                                  align: isEnglish()
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  fontWeight: FontWeight.normal,
                                  color:isDark?backGroundColor: subTitleTextColor ?? subTitleColor,
                                ),
                              ),
                        if (image != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: onImageTap,
                            child: Image.asset(
                              image,
                              color: isDark ? backGroundColor : null,
                              width: imageWidth ?? 5,
                              matchTextDirection:
                                  imageMatchTextDirection ?? false,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hideSeparator == false) ...[
            SizedBox(height: isTextField ? 4 : 12),
            Container(
              height: 0.5,
              color: separatorColor ?? lineColor,
            ),
          ],
        ],
      ),
    );
