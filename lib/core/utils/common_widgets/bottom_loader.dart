import 'package:flutter/material.dart';
import '../../services/extentions.dart';

import '../app_widgets/custom_app_text.dart';
import '../theme/app_colors.dart';


Widget bottomLoader({required bool hasMore,bool isDark=false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: hasMore
            ?  CircularProgressIndicator(
                color:isDark?secondaryColor: primaryColor,
              )
            : customTextApp(
                text: "no_more_data".localized(),
                size: 14,
                fontWeight: FontWeight.bold,
              ),
      ),
    );
