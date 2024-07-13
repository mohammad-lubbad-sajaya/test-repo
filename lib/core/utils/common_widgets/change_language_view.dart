import 'package:flutter/material.dart';

import '../../../features/shared_screens/allTabs/settings/settings_view_model.dart';
import '../../services/app_translations/app_translations.dart';
import '../../services/extentions.dart';
import '../app_widgets/custom_app_text.dart';
import '../constants/images.dart';
import '../methods/change_language_state.dart';
import '../theme/app_colors.dart';


class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  var languageState = ChangeLanguageState();

  @override
  void initState() {
    super.initState();
    languageState.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              languageState.changeLang(langNumber: isEnglish() ? 1 : 0);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  customTextApp(
                    color: context.read(settingsViewModelProvider).isDark?backGroundColor:Colors.black,
                    text: isEnglish() ? 'ع' : "En",
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    language,
                    height: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
