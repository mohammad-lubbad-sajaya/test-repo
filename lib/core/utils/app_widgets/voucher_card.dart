import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../../../features/crm/data/models/vouchers.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget voucherCard({
  Vouchers? obj,
  bool isEdit = false,
  required bool isDark,
  Function()? ontap,
  Function(bool)? onSwitchChanged,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: InkWell(
          onTap: ontap,
          child: Container(
            decoration: BoxDecoration(
                color: isDark ? darkCardColor : Colors.white,
                border: Border.all(
                  width: 1,
                  color: (obj?.isChecked ?? false)
                      ? secondaryColor
                      : textFieldBgColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isEdit) ...[
                        Switch(
                          inactiveTrackColor: Colors.grey[100],
                          activeColor: secondaryColor,
                          value: obj?.isChecked ?? false,
                          onChanged: onSwitchChanged,
                        ),
                      ]
                    ],
                  ),
                  Row(
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: obj?.transTypeName ?? "",
                        size: 15,
                        fontWeight: FontWeight.bold,
                        maxLine: 10,
                      ),
                      customTextApp(
                        text: " :",
                        fontWeight: FontWeight.bold,
                        color: isDark ? backGroundColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "${obj?.transNo}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  //const SizedBox(height: 10),

                  Row(
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "Date".localized(),
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      customTextApp(
                        text: " :",
                        fontWeight: FontWeight.bold,
                        color: isDark ? backGroundColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text:
                            obj?.transDate?.toStringFormat("dd/MM/yyyy") ?? "",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "Status".localized(),
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      customTextApp(
                        text: " :",
                        fontWeight: FontWeight.bold,
                        color: isDark ? backGroundColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: obj?.statusName ?? "",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "User".localized(),
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      customTextApp(
                        text: " :",
                        fontWeight: FontWeight.bold,
                        color: isDark ? backGroundColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "${obj?.enteredByUser}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "Repres".localized(),
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      customTextApp(
                        text: " :",
                        fontWeight: FontWeight.bold,
                        color: isDark ? backGroundColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "${obj?.representiveName}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text: "Notes :".localized(),
                        size: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            customTextApp(
                              color: isDark ? backGroundColor : Colors.black,
                              text: obj?.note ?? "",
                              size: 15,
                              fontWeight: FontWeight.w500,
                              maxLine: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
