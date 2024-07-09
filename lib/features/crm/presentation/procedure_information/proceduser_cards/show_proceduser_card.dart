import 'package:flutter/material.dart';
import '../../../../../core/services/extentions.dart';


import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/procedure.dart';

class ShowProcedureCard extends StatelessWidget {
  const ShowProcedureCard({
    super.key,
    required this.obj,
    required this.isDark,
  });

  final Procedure? obj;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCardColor : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            customRowApp(
              isDark: isDark,
              text: "Date and time".localized(),
              subText: obj?.eventDate?.toStringFormat("hh:mm:ss dd/MM/yyyy"),
            ),
            if (obj?.eventId != null) ...[
              customRowApp(
                isDark: isDark,
                text: "Proc No".localized(),
                subText: obj?.eventId?.toString(),
              ),
            ],
            customRowApp(
              isDark: isDark,
              text: "User".localized(),
              subText: obj?.enteredByUser,
            ),
            customRowApp(
              isDark: isDark,
              text: "Repres".localized(),
              subText:
                  isEnglish() ? obj?.representiveNameE : obj?.representiveNameA,
            ),
            customRowApp(
              isDark: isDark,
              text: "Cust".localized(),
              subText: isEnglish() ? obj?.custNameE : obj?.custNameA,
              image: (obj?.isWalkIn ?? false) ? bodyWalkIcon : bodyIcon,
              imageWidth: 16,
            ),
            customRowApp(
              isDark: isDark,
              text: "Address".localized(),
              subText: isEnglish() ? obj?.addressNameE : obj?.addressNameA,
            ),
            customRowApp(
              isDark: isDark,
              text: "Contact".localized(),
              subText: obj?.contactPerson,
            ),
            customRowApp(
              isDark: isDark,
              text: "Type".localized(),
              subText: isEnglish() ? obj?.eventTypeNameE : obj?.eventTypeNameA,
            ),
            customRowApp(
              isDark: isDark,
              text: "Nature".localized(),
              subText:
                  isEnglish() ? obj?.eventNatureNameE : obj?.eventNatureNameA,
            ),
            customRowApp(
              isDark: isDark,
              text: "Duration".localized(),
              subText: obj?.eventDuration?.toInt().toString(),
            ),
            customRowApp(
              isDark: isDark,
              text: "Desc".localized(),
              subText: obj?.eventDesc,
              hideSeparator: true,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }
}
