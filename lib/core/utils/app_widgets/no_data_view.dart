import 'package:flutter/material.dart';
import '../../services/extentions.dart';
import '../theme/app_colors.dart';

import '../../../features/shared_screens/allTabs/settings/settings_view_model.dart';
import 'custom_app_text.dart';

Widget showNoDataView({
  required BuildContext context,
  int? minHeight,
}) =>
    Center(
      child: Container(
        decoration:  BoxDecoration(
          color:context.read(settingsViewModelProvider).isDark?darkCardColor: textFieldBgColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - (minHeight ?? 300),
        ),
        //height: double.infinity, // Expand the container vertically
        child: Center(
          child: customTextApp(
            text: "No Data".localized(),
            fontWeight: FontWeight.bold,
            size: 24,
            color:context.read(settingsViewModelProvider).isDark?backGroundColor: Colors.black,
          ),
        ),
      ),
    );
