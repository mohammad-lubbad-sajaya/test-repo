import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../../../features/crm/data/models/procedure.dart';
import '../../../features/crm/data/models/service_request.dart';
import '../../services/app_translations/app_translations.dart';
import '../../services/routing/navigation_service.dart';
import '../../services/routing/routes.dart';
import '../../services/service_locator/dependency_injection.dart';
import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

appCard({
  Procedure? obj,
  ServiceRequest? servObj,
  bool isSelected = false,
  bool isTimerIcon = true,
  double horizontal = 20.0,
  required bool isDark,
  Function()? ontap,
  Function()? onTimerTap,
  Function()? onToolsTap,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: InkWell(
          onTap: ontap,
          child: Container(
            color: isDark ? darkCardColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (servObj != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextApp(
                          //text: "12/09/2022",
                          color: isDark ? backGroundColor : Colors.black,
                          text: servObj.bondNo.toString(),
      
                          size: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        InkWell(
                          onTap: () {
      //TODO:edit when api is here
                            sl<NavigationService>().navigateTo(checkAndRepair);
                          },
                          child: Image.asset(
                            tools,
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTextApp(
                        //text: "12/09/2022",
                        color: isDark ? backGroundColor : Colors.black,
                        text: servObj?.date.toStringFormat("dd/MM/yyyy") ??
                            obj?.eventDate?.toStringFormat("dd/MM/yyyy") ??
                            "",
      
                        size: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      if (isTimerIcon && obj!.isMeeting!) ...[
                        InkWell(
                          onTap: onTimerTap,
                          child: Image.asset(
                            timerIcon,
                            height: 40,
                          ),
                        ),
                      ],
                      if (isSelected) ...[
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        )
                      ],
                    ],
                  ),
                  //const SizedBox(height: 10),
      
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: customTextApp(
                          text: isEnglish()
                              ? servObj?.clientName ?? obj?.custNameE ?? ""
                              : servObj?.clientName ?? obj?.custNameA ?? "",
                          maxLine: null,
                          size: 15,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (obj?.isWalkIn ?? false) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.directions_walk,
                          color: secondaryColor,
                          size: 28,
                        ),
                        const Spacer(),
                      ]
                    ],
                  ),
                  const SizedBox(height: 10),
                  customTextApp(
                    color: isDark ? backGroundColor : Colors.black,
                    text: servObj?.serviceType ??
                        "${isEnglish() ? obj?.eventTypeNameE ?? "" : obj?.eventTypeNameA} - ${isEnglish() ? obj?.eventNatureNameE ?? "" : obj?.eventNatureNameA}",
                    size: 15,
                    maxLine: null,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 10),
                  if (isTimerIcon == false) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customTextApp(
                          color: isDark
                              ? backGroundColor
                              : servObj != null
                                  ? Colors.grey
                                  : Colors.black,
                          text: servObj?.serviceStatus ??
                              "${"Address".localized()}(${obj?.addressId}): ${isEnglish() ? obj?.addressNameE ?? "" : obj?.addressNameA}",
                          size: 15,
                          maxLine: null,
                          fontWeight: FontWeight.w500,
                        ),
                        if(servObj!=null)...[
                          const SizedBox(width: 6,),
                          Container(
                            height: 15,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.green
                            ),
                          )
                        ]

                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  customTextApp(
                    color: isDark ? secondaryColor : primaryColor,
                    maxLine: null,
                    text: obj?.eventDesc ?? "",
                    size: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
