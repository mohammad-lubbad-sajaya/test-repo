import 'package:flutter/material.dart';

import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/app_widgets/app_card.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../procedure_place_view_model.dart';

customerProcedures({
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
        color:isDark?darkModeBackGround: textFieldBgColor,
        borderRadius:const  BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          sectionTitle(
            isDark: isDark,
            title: "Customer's Procedures".localized(),
          ),
          listViewContainerBuilder(
            context: context,
            vertical: 0,
            minHeight: 300,
            itemCount: viewModel.customerProcedures.length,
            itemBuilder: (BuildContext context, int index) {
              return appCard(
                isDark: context.read(settingsViewModelProvider).isDark,
                obj: viewModel.customerProcedures[index],
                horizontal: 0,
                isTimerIcon: false,
                isSelected: viewModel.customerProcedures[index].eventId ==
                    viewModel.procedureObj?.eventId,
                ontap: () {
                  viewModel.didChangeCustomerProcedure(
                    viewModel.customerProcedures[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
