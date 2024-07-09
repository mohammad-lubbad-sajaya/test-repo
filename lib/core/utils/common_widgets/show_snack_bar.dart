import 'package:flutter/material.dart';

import '../../services/routing/navigation_service.dart';
import '../../services/service_locator/dependency_injection.dart';
import '../app_widgets/custom_app_text.dart';
import '../theme/app_colors.dart';


showSnackBar(
  String text,
) {
  ScaffoldMessenger.of(sl<NavigationService>().getContext()).showSnackBar(
    SnackBar(
      backgroundColor: secondaryColor.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      content: customTextApp(
        text: text,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

showConnectionSnackBar(
  String text,
  Color color,
  IconData icon
) {
  ScaffoldMessenger.of(sl<NavigationService>().getContext()).showSnackBar(
    SnackBar(
      duration:const Duration(milliseconds:500),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          customTextApp(
            text: text,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),

          Icon(icon,color: Colors.white,)
        ],
      ),
    ),
  );
}

