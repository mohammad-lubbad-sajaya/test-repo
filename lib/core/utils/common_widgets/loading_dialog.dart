import 'package:flutter/material.dart';

import '../../../features/shared_screens/allTabs/settings/settings_view_model.dart';
import '../../services/extentions.dart';
import '../app_widgets/app_circular_progress.dart';
import '../app_widgets/custom_app_text.dart';
import '../theme/app_colors.dart';


class LoadingAlertDialog {
  static late OverlayEntry _overlayEntry;

  static void show(
    BuildContext context, {
    String? title,
  }) {
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color.fromRGBO(255, 243, 243, 0.298),
              ),
            ),
            Center(
              child: AlertDialog(
                backgroundColor: context.read(settingsViewModelProvider).isDark
                    ? darkCardColor
                    : null,
                title: customTextApp(
                  color: context.read(settingsViewModelProvider).isDark
                      ? Colors.white
                      : Colors.black,
                  text: 'Loading'.localized(),
                  fontWeight: FontWeight.bold,
                  size: 20,
                ),
                content: Row(
                  children: <Widget>[
                    appCircularProgress(
                      width: 40,
                      height: 40,
                      strokeWidth: 4,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: customTextApp(
                        color: context.read(settingsViewModelProvider).isDark
                            ? Colors.white
                            : Colors.black,
                        text: title ?? 'Please wait...'.localized(),
                        maxLine: 2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_overlayEntry);
  }

  static void dismiss() {
    _overlayEntry.remove();
  }
}
