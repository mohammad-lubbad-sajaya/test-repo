import 'package:flutter/material.dart';

import '../../../features/crm/data/models/procedure.dart';
import '../../services/extentions.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

Widget inquireCard({
  Procedure? obj,
  Function()? ontap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: InkWell(
          onTap: ontap,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        color: placeHolderColor,
                        text: "Date".localized(),
                        size: 15,
                      ),
                      //const SizedBox(height: 10),
                      customTextApp(
                        text:
                            obj?.eventDate?.toStringFormat("dd/MM/yyyy") ?? "",
                        size: 15,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        text: "Procedure Name".localized(),
                        size: 15,
                        color: placeHolderColor,
                      ),
                      customTextApp(
                        text: "${obj?.custId}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        maxLine: 10,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        text: "User".localized(),
                        size: 15,
                        color: placeHolderColor,
                      ),
                      customTextApp(
                        text: "${obj?.enteredByUser}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        maxLine: 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        text: "customer".localized(),
                        size: 15,
                        color: placeHolderColor,
                      ),
                      customTextApp(
                        text: "${obj?.custNameA}",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        maxLine: 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        text: "Notes :".localized(),
                        size: 15,
                        color: placeHolderColor,
                      ),
                      const SizedBox(width: 10),
                      customTextApp(
                        text: obj?.eventDesc ?? "",
                        size: 15,
                        fontWeight: FontWeight.w500,
                        maxLine: 15,
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
