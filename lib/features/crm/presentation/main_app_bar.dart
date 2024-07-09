import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/extentions.dart';
import '../../../core/utils/app_widgets/app_title.dart';
import '../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../core/utils/theme/app_colors.dart';

import '../../../core/services/app_translations/app_translations.dart';
import '../../../core/services/local_repo/local_repository.dart';
import '../../../core/services/service_locator/dependency_injection.dart';
import '../../../core/utils/constants/images.dart';
import '../data/models/entered_users.dart';
import 'allTabs/all_proc/view_models/all_proc_view_model.dart';
import 'allTabs/home/home_view_model.dart';
import 'allTabs/settings/settings_view_model.dart';
import 'tab_bar/tab_bar_view_model.dart';


mainAppbar({
  String? text,
  BuildContext ?context,
  bool isHideLogOut=false
}) =>
    AppBar(
      backgroundColor: context!.read(settingsViewModelProvider).isDark?darkModeBackGround:Colors.white,
      title: appTitle(text: text ?? "",isDark:context.read(settingsViewModelProvider).isDark ),
      actions:isHideLogOut?[]: [
        Consumer(
          builder: (context, ref, child) {
            final homeViewModel = ref.watch(homeViewModelProvider);
            final allProcViewModel = ref.watch(allProcModelProvider);
            homeViewModel.context = context;
            if (homeViewModel.isAdmin ?? false) {
              return PopupMenuButton<String>(
                enableFeedback: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 12,
                color: Colors.white,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.5,
                ),
                onSelected: (value) {
                  homeViewModel.setSelectedEnteredUser(value);
                  reloadHomeData(context, allProcViewModel, homeViewModel);
                },
                itemBuilder: (BuildContext context) {
                  return homeViewModel.enteredUsersList.map((EnteredUsers obj) {
                    return PopupMenuItem<String>(
                      value: obj.enteredByUser,
                      child: customTextApp(
                          text: isEnglish()
                              ? obj.userNameE ?? ""
                              : obj.userNameA ?? "",
                          fontWeight:
                              homeViewModel.isUserIDSelected(obj.enteredByUser)
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                    );
                  }).toList();
                },
                icon: Image.asset(profile),
              );
            } else {
              return Container();
            }
          },
        ),
        Transform.scale(
          scaleX: -1,
          child: IconButton(
            icon: Image.asset(
              logout,
              matchTextDirection: true,
            ),
            onPressed: () {
                                                    context.read(homeViewModelProvider).resetProcedures();

              sl<LocalRepo>().logout();
            },
          ),
        )
      ],
    );

reloadHomeData(BuildContext context, AllProcViewModel allProcViewModel,
    HomeViewModel homeViewModel) {
  final tabBarviewModel = context.read(tabBarViewModelProvider);
  final selectedIndex = context.read(tabBarviewModel.selectedIndex.state);
  if (selectedIndex.state == 1) {
    allProcViewModel.getMain();
  } else {
    homeViewModel.resteDate();
  }
}
