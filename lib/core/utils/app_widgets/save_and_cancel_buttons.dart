import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../common_widgets/custom_raised_button.dart';
import '../theme/app_colors.dart';
import 'custom_app_text.dart';

saveAndCancelButtons(
  BuildContext context,
  bool isLoading, {
  Function()? onSave,
  Function()? onCancel,
}) =>
    Row(
      children: [
        Expanded(
          child: CustomRaisedButton(
            onTap: onSave,
            child: isLoading
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: secondaryColor,
                      ),
                      const SizedBox(width: 5),
                      customTextApp(
                        text: 'Save'.localized(),
                        color: secondaryColor,
                        size: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: CustomRaisedButton(
            colors: const [secondaryColor, secondaryColor],
            onTap: onCancel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                customTextApp(
                  text: 'Cancel'.localized(),
                  color: Colors.white,
                  size: 14,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
