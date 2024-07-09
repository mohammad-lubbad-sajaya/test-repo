import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../allTabs/settings/settings_view_model.dart';
import '../procedure_place_view_model.dart';


headerAddressCard({
  required ProcedurePlaceViewModel viewModel,
  required BuildContext context,
  required bool isDark,
  void Function()? onTapStartMeeting,
  void Function()? onTapEditPin,
  void Function()? onTapEditLocation,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkCardColor : textFieldBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextApp(
                      color: isDark ? backGroundColor : Colors.black,
                      text: isEnglish()
                          ? viewModel.procedureObj?.custNameE ?? ""
                          : viewModel.procedureObj?.custNameA ?? "",
                      fontWeight: FontWeight.bold,
                      maxLine: 3,
                      size: 14,
                    ),
                    customTextApp(
                      text: isEnglish()
                          ? viewModel.selectedCustomerAddress?.addressNameE ??
                              ""
                          : viewModel.selectedCustomerAddress?.addressNameA ??
                              "",
                      color: placeHolderColor,
                      maxLine: 3,
                      size: 14,
                    ),
                    customTextApp(
                      color: isDark ? backGroundColor : Colors.black,
                      text:
                          "${viewModel.selectedCustomerAddress?.locationNorth ?? ""}, ${viewModel.selectedCustomerAddress?.locationEast ?? ""}",
                      size: 14,
                    ),
                  ],
                ),
              ),
              if (viewModel.selectedTab != 5) ...[
                const Spacer(),
                InkWell(
                  child: Image.asset(
                    color: isDark?backGroundColor:null,
                    pinIcon,
                    width: 10,
                  ),
                  onTap: onTapEditPin,
                )
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            color: const Color(0xFFAFB1BE),
            height: 0.5,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      customTextApp(
                        text: "Search Radius".localized(),
                        color: placeHolderColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text:
                            "${context.read(settingsViewModelProvider).distanceinMeter}${"m".localized()}",
                        fontWeight: FontWeight.bold,
                        size: 15,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      customTextApp(
                        text: "Distance".localized(),
                        color: placeHolderColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      customTextApp(
                        color: isDark ? backGroundColor : Colors.black,
                        text:
                            "${viewModel.getDistanceFromated()} ${"m".localized()}",
                        fontWeight: FontWeight.bold,
                        size: 14,
                      ),
                    ],
                  ),
                  customTextApp(
                    color: isDark ? backGroundColor : Colors.black,
                    text:
                        "${viewModel.currentLocation?.latitude ?? ""}, ${viewModel.currentLocation?.longitude ?? ""}",
                    size: 14,
                  ),
                ],
              ),
              if (viewModel.selectedTab != 5) ...[
                const Spacer(),
                InkWell(
                  child: Image.asset(
                    color: isDark?backGroundColor:null,
                    locationIcon,
                    width: 16,
                  ),
                  onTap: onTapEditLocation,
                )
              ],
            ],
          ),
          if (viewModel.selectedTab != 5) ...[
            const SizedBox(height: 4),
            if ((viewModel.getDistance() ?? 0) <
                context.read(settingsViewModelProvider).distanceinMeter) ...[
              startMeetingButton(
                onTap: onTapStartMeeting,
              ),
            ] else ...[
              wrongCustomerLocation(),
            ],
          ],
        ],
      ),
    );

wrongCustomerLocation() => Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.15),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            warningIcon,
            width: 14,
          ),
          const SizedBox(width: 7),
          customTextApp(
            text: "Wrong Customer Location".localized(),
            color: secondaryColor,
            size: 13,
          )
        ],
      ),
    );

Widget startMeetingButton({
  void Function()? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),

          // boxShadow: shadow,
        ),
        height: 54,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                watchIcon,
                height: 16,
              ),
              const SizedBox(width: 10),
              customTextApp(
                text: "Start Meeting".localized(),
                color: secondaryColor,
                fontWeight: FontWeight.w500,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
