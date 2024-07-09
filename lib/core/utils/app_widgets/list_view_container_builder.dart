import 'package:flutter/material.dart';
import '../../services/extentions.dart';
import '../theme/app_colors.dart';

import '../../../features/crm/presentation/allTabs/settings/settings_view_model.dart';


Widget listViewContainerBuilder({
  required BuildContext context,
  double vertical = 15,
  int? minHeight,
  int? itemCount,
  required Widget? Function(BuildContext, int) itemBuilder,
}) =>
    Container(
      decoration:  BoxDecoration(
        color:context.read(settingsViewModelProvider).isDark?darkModeBackGround: backGroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - (minHeight ?? 300),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vertical),
        child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        ),
      ),
    );
