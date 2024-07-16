import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';

import '../../services/extentions.dart';
import '../../services/routing/navigation_service.dart';
import '../../services/service_locator/dependency_injection.dart';
import '../app_widgets/custom_app_text.dart';
import '../theme/app_colors.dart';


showErrorDialog({
  String title = "Error!",
  required String message,
  VoidCallback? onOkTap,
  RouteSettings? routeSettings,
}) {
  showDialog(
    context: sl<NavigationService>().getContext(),
    routeSettings: routeSettings,
    builder: (_) {
      return PlatformCheck.isIOS
          ? CupertinoAlertDialog(
              title: customTextApp(text: title.localized()),
              content: customTextApp(text: message),
              actions: [
                TextButton(
                  onPressed: onOkTap ??
                      () => sl<NavigationService>().navigateToPrevious(),
                  child: customTextApp(
                    text: 'ok'.localized(),
                    color: secondaryColor,
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title.localized()),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: onOkTap ??
                      () => sl<NavigationService>().navigateToPrevious(),
                  child: customTextApp(
                    text: 'ok'.localized(),
                    color: secondaryColor,
                  ),
                ),
              ],
            );
    },
  );
}
