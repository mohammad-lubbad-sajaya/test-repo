import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/procedure.dart';
import '../../allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../../procedure_information/proceduser_cards/show_proceduser_card.dart';

procedureInfoCard({required Procedure? obj,required bool isDark}) => Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration:  BoxDecoration(
        color:isDark?darkModeBackGround: textFieldBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Column(
        children: [
          sectionTitle(
            isDark: isDark,
            title: "Current Procedure".localized(),
          ),
          ShowProcedureCard(obj: obj,isDark: isDark,),
        ],
      ),
    );
