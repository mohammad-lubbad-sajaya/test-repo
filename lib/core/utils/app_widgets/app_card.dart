import 'package:flutter/material.dart';
import 'package:trust_location/trust_location.dart';

import '../../../features/crm/data/models/procedure.dart';
import '../../../features/crm/data/models/service_request.dart';
import '../../../features/crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../../../features/maintenance/presentation/check_and_repair/view_model/check_repair_view_model.dart';
import '../../services/app_translations/app_translations.dart';
import '../../services/extentions.dart';
import '../../services/routing/navigation_service.dart';
import '../../services/routing/routes.dart';
import '../../services/service_locator/dependency_injection.dart';
import '../constants/images.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';
import 'maintenance_contact_buttons_row.dart';

appCard({
  Procedure? obj,
  ServiceRequest? servObj,
  BuildContext? context,
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
                            context
                                .read(checkAndRepairViewModel)
                                .changeBondNumber(servObj.bondNo);
                            sl<NavigationService>().navigateTo(checkAndRepair);
                          },
                          child: Image.asset(
                            context!
                                    .read(checkAndRepairViewModel)
                                    .checkRepairList
                                    .where((element) =>
                                        element.bondNumber == servObj.bondNo)
                                    .isEmpty
                                ? tools
                                : filledTools,
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
                        text: servObj?.date
                                .toStringFormat("hh:mm:ss dd/MM/yyyy") ??
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
                  if (servObj != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: secondaryColor,
                        ),
                        customTextApp(
                          color: isDark ? backGroundColor : Colors.black,
                          text: servObj.address,
                          size: 15,
                          maxLine: null,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        customTextApp(
                          color: isDark ? backGroundColor : Colors.black,
                          text: (context!
                                          .read(procedurePlaceViewModelProvider)
                                          .getDistance(
                                              custlat: 35.930359,
                                              custlong: 31.963158,
                                              currentLat: 35.916667,
                                              currentLong: 31.966667)! /
                                      1000)
                                  .toStringAsFixed(2) +
                              " KM",
                          size: 15,
                          maxLine: null,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],

                  if (servObj != null) ...[],
                  SizedBox(height: servObj != null ? 5 : 10),
                  customTextApp(
                    color: isDark ? backGroundColor : Colors.black,
                    text: servObj?.serviceType ??
                        "${isEnglish() ? obj?.eventTypeNameE ?? "" : obj?.eventTypeNameA} - ${isEnglish() ? obj?.eventNatureNameE ?? "" : obj?.eventNatureNameA}",
                    size: 15,
                    maxLine: null,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: servObj != null ? 5 : 10),
                  if (isTimerIcon == false&&servObj==null) ...[
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
                       
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (servObj != null) ...[
                    const SizedBox(height: 20),
                    MaintenanceContactButtonsRow().contactButtonsRow(
                        email: "dev.f@sajaya.com",
                        phone: "+962785026812",
                        latLongPosition:
                            LatLongPosition("31.963158", "35.930359"))
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
  