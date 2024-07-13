import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/extentions.dart';
import '../../../../core/services/local_repo/local_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/app_circular_progress.dart';
import '../../../../core/utils/app_widgets/app_title.dart';
import '../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../core/utils/app_widgets/drop_vertical_down_button.dart';
import '../../../../core/utils/constants/endpoints.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/methods/change_language_state.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../tab_bar/tab_bar_view_model.dart';
import '../home/home_view_model.dart';
import '../inquiry/filter_inquiry/filter_inquiry_view_model.dart';
import 'settings_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var languageState = ChangeLanguageState();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(settingsViewModelProvider).getUserCompanyList();
    });
    languageState.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appTitle(
            text: "Settings".localized(),
            isDark: context.read(settingsViewModelProvider).isDark),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final settingsViewModel = ref.watch(settingsViewModelProvider);
          return Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: settingsViewModel.isDark
                        ? darkModeBackGround
                        : backGroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 21, vertical: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: settingsViewModel.isDark
                                  ? darkCardColor
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (settingsViewModel
                                      .dropDownList.isEmpty) ...[
                                    Center(
                                      child: appCircularProgress(),
                                    ),
                                  ] else ...[
                                    dropDownVerticalButton(
                                      //height: 20,
                                      hintText: "Company".localized(),
                                      isDark: settingsViewModel.isDark,
                                      selectedItem:
                                          settingsViewModel.selectedOption,
                                      didSelectItem: (newValue) {
                                        settingsViewModel
                                            .setSelectedOption(newValue);
                                      },
                                      items: settingsViewModel.dropDownList,
                                    ),
                                  ],
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: "Language".localized(),
                                    subText:
                                        isEnglish() ? 'العربية' : "English",
                                    image: arrow,
                                    imageMatchTextDirection: true,
                                    onTap: () {
                                      final filterViewModel = context
                                          .read(filterInquiryViewModelProvider);
                                      filterViewModel.reset();
                                      languageState.changeLang(
                                        langNumber: isEnglish() ? 1 : 0,
                                      );
                                    },
                                  ),
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: settingsViewModel.isDark
                                        ? "light theme".localized()
                                        : "dark theme".localized(),
                                    imageMatchTextDirection: true,
                                    icon: settingsViewModel.isDark
                                        ? Icons.light_mode
                                        : Icons.dark_mode,
                                    onTap: () {
                                      settingsViewModel.setTheme();
                                      final _tabViewModel =
                                          ref.watch(tabBarViewModelProvider);
                                     _tabViewModel.updateScreen();

                                      setState(() {});
                                    },
                                  ),
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: "distance in meter".localized(),
                                    subText: "",
                                  ),
                                  WheelSlider.number(
                                    interval:
                                        50, // this field is used to show decimal/double values
                                    totalCount: 30,
                                    initValue:
                                        settingsViewModel.distanceinMeter,
                                    unSelectedNumberStyle:  TextStyle(
                                      fontSize: 10.0,
                                      color:  settingsViewModel.isDark
                                          ? backGroundColor
                                          : null,
                                    ),
                                    selectedNumberStyle: TextStyle(
                                      fontSize: 15.0,
                                      color: settingsViewModel.isDark
                                          ? backGroundColor
                                          : null,
                                    ),
                                    currentIndex:
                                        settingsViewModel.distanceinMeter,
                                    onValueChanged: (val) {
                                      settingsViewModel.changeDistance(val);
                                    },
                                    hapticFeedbackType:
                                        HapticFeedbackType.heavyImpact,
                                  ),
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: "remind before".localized(),
                                    subText: "",
                                  ),
                                  NumberPicker(
                                      value: settingsViewModel.remindInMinutes,
                                      minValue: 10,
                                      maxValue: 60,
                                      selectedTextStyle: TextStyle(
                                          color: settingsViewModel.isDark
                                              ? backGroundColor
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey),
                                      onChanged: (value) => settingsViewModel
                                          .changeRemindTime(value)),
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: "Version Number".localized(),
                                    subText: sl<Endpoints>().version,
                                  ),
                                  customRowApp(
                                    isDark: settingsViewModel.isDark,
                                    text: "Logout".localized(),
                                    image: logoutIcon,
                                    imageWidth: 20,
                                    imageMatchTextDirection: true,
                                    hideSeparator: true,
                                    onTap: () {
                                      context.read(homeViewModelProvider).resetProcedures();
                                      sl<LocalRepo>().logout();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
