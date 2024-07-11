import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/nearby_customers.dart';
import '../../../../shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../procedure_place_view_model.dart';

nearbyCustomers({
  required BuildContext context,
  required bool isDark,
  required ProcedurePlaceViewModel viewModel,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration:  BoxDecoration(
        color:isDark? darkModeBackGround:textFieldBgColor,
        borderRadius:const  BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          sectionTitle(
            isDark: isDark,
            title: "Nearby Customers".localized(),
          ),
          listViewContainerBuilder(
            context: context,
            vertical: 0,
            minHeight: 300,
            itemCount: viewModel.nearbyCustomers.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: nearbyCustomersCard(viewModel.nearbyCustomers[index],isDark),
                onTap: () {
                  viewModel.didSelectCustomer(viewModel.nearbyCustomers[index]);
                },
              );
            },
          ),
        ],
      ),
    );

nearbyCustomersCard(
  NearbyCustomers obj,
  bool isDark
) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
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
              customTextApp(
                color: isDark?backGroundColor:Colors.black,
                text: isEnglish() ? obj.custNameE ?? "" : obj.custNameA ?? "",
                size: 14,
                fontWeight: FontWeight.bold,
              ),
              Row(
                children: [
                  customTextApp(
                    text: "Stored addresses".localized(),
                    color: placeHolderColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  customTextApp(
                                    color: isDark?backGroundColor:Colors.black,

                    text: ": ${obj.addressCount}",
                    size: 14,
                  ),
                  if (obj.walkInId!=0) ...[
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
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
