import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/nearby_customers.dart';
import '../../../../shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../procedure_place_view_model.dart';

allCustomerAddress({
  required BuildContext context,
  required bool isDark ,
  required ProcedurePlaceViewModel viewModel,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration:  BoxDecoration(
        color:isDark?darkModeBackGround: backGroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          sectionTitle(
            isDark: isDark,
            title: "Customer Address".localized(),
          ),
          listViewContainerBuilder(
            context: context,
            minHeight: 300,
            vertical: 0,
            itemCount: viewModel.allCustomerAddress.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: allCustomerAddressCard(
                  isDark: isDark,
                  viewModel.allCustomerAddress[index],
                  isSelected: viewModel.procedureObj?.addressId ==
                      viewModel.allCustomerAddress[index].addressID,
                ),
                onTap: () {
                  viewModel.didSelectAddress(
                    viewModel.allCustomerAddress[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );

allCustomerAddressCard(
  NearbyCustomers obj, {
  bool isSelected = false,
  bool isDark = false,
}) =>
    Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 20,
          ),
          decoration:  BoxDecoration(
            color:isDark?darkCardColor: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: customTextApp(
                      color: isDark?backGroundColor:Colors.black,
                      text: isEnglish()
                          ? obj.addressNameE ?? ""
                          : obj.addressNameA ?? "",
                      size: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSelected) ...[
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                  ],
                ],
              ),
              customTextApp(
                                      color: isDark?backGroundColor:Colors.black,

                text: "${obj.locationNorth ?? ""} ,${obj.locationEast ?? ""}",
                size: 14,
                fontWeight: FontWeight.bold,
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
                                          color: isDark?backGroundColor:Colors.black,

                    text: ": ${obj.getDistanceFromated()} ${"m".localized()}",
                    fontWeight: FontWeight.bold,
                    size: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
