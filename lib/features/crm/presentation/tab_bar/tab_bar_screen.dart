import 'dart:developer';

import 'package:badges/badges.dart' as badge;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';


import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/common_widgets/show_snack_bar.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/methods/shared_methods.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../allTabs/all_proc/all_proc_screen.dart';
import '../allTabs/home/home_screen.dart';
import '../allTabs/inquiry/pre_inquiry_screen/pre_inquiry_screen.dart';
import '../allTabs/settings/settings_screen.dart';
import '../allTabs/settings/settings_view_model.dart';
import '../pre_app/pre_app_view_model.dart';
import 'tab_bar_view_model.dart';

final connectionProvider =
    StateProvider<String>((ref) => ConnectivityResult.wifi.name);

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key,});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with WidgetsBindingObserver {
  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    SharedMethods().checkLocationMocking(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.read<TabBarViewModel>(tabBarViewModelProvider).isMaintenance) {
        _connectionListener();

        context
            .read(settingsViewModelProvider)
            .getCachedDistanceAndRemindMinures();
      }
    });
    items = 
      context.read<TabBarViewModel>(tabBarViewModelProvider).isMaintenance  ? [
           BottomNavigationBarItem(
              icon: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(serviceRequestIcon,color:placeHolderColor )),
              activeIcon: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(serviceRequestIcon, color: secondaryColor,)),
              label: 'service request'.localized(),
            ),
              BottomNavigationBarItem(
              icon: Image.asset(settings),
              activeIcon: Image.asset(settings, color: secondaryColor),
              label: 'Settings'.localized(),
            ),
        ]
        : [
            BottomNavigationBarItem(
              icon: Image.asset(dailyPrec),
              activeIcon: Image.asset(dailyPrec, color: secondaryColor),
              label: 'Daily Proc.'.localized(),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(allPrec),
              activeIcon: Image.asset(allPrec, color: secondaryColor),
              label: 'AllProc'.localized(),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(inquiry),
              activeIcon: Image.asset(inquiry, color: secondaryColor),
              label: 'Inquiry'.localized(),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(settings),
              activeIcon: Image.asset(settings, color: secondaryColor),
              label: 'Settings'.localized(),
            ),
          ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes here
    SharedMethods().checkLocationMocking(context);

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final tabBarViewModel = ref.watch(tabBarViewModelProvider);
          final index = ref.watch(tabBarViewModel.selectedIndex);
          if ((tabBarViewModel.isMockedLocation ||
                  tabBarViewModel.isEmulator) &&
              kReleaseMode) {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text("location is mocked".localized()),
                ));
          } else {
            return _getChild(index);
          }
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final tabBarViewModel = ref.watch(tabBarViewModelProvider);
          final index = ref.watch(tabBarViewModel.selectedIndex);
          final dailyCount = ref.watch(tabBarViewModel.dailyBadgeCount);
          final allProcCount = ref.watch(tabBarViewModel.allProcBadgeCount);

          return BottomNavigationBar(
            enableFeedback: true,
            unselectedItemColor: context.read(settingsViewModelProvider).isDark
                ? backGroundColor
                : null,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedItemColor: secondaryColor,
            backgroundColor: context.read(settingsViewModelProvider).isDark
                ? darkCardColor
                : Colors.white,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: TextStyle(
              color: context.read(settingsViewModelProvider).isDark
                  ? backGroundColor
                  : primaryColor,
              //fontFamily: 'Poppins',
            ),
            selectedLabelStyle: const TextStyle(
              color: secondaryColor,
              //fontFamily: 'Poppins',
            ),
            items: items.map((item) {
              int index = items.indexOf(item);

              tabBarViewModel.changeIndex(index);
              if (index == 0 && dailyCount > 0) {
                return BottomNavigationBarItem(
                  icon: getBadge(item, value: "$dailyCount"),
                  activeIcon:
                      getBadge(item, isActive: true, value: "$dailyCount"),
                  label: item.label,
                );
              } else if (index == 1 && allProcCount > 0) {
                return BottomNavigationBarItem(
                  icon: getBadge(item, value: "$allProcCount"),
                  activeIcon:
                      getBadge(item, isActive: true, value: "$allProcCount"),
                  label: item.label,
                );
              } else {
                return item;
              }
            }).toList(),
            currentIndex: index,
            onTap: (index) {
              ref.read(tabBarViewModel.selectedIndex.state).state = index;
            },
          );
        },
      ),
    );
  }

  void _connectionListener() {
    Connectivity().onConnectivityChanged.listen(
      (result) async {
        if (result.first.name == ConnectivityResult.none.name) {
          showConnectionSnackBar(
              "You Lost Connection", Colors.red, Icons.wifi_off);
        } else {
          if (!mounted) {
            return;
          }
          if (result.first.name != ConnectivityResult.none.name &&
              context.read(connectionProvider.notifier).state ==
                  ConnectivityResult.none.name) {
            showConnectionSnackBar(
                "You Are Connected", Colors.green, Icons.wifi);
            if (GeneralConfigurations().isDebug) {
              log("=====================================================================>>>>>>>");
            }
            context
                .read(preAppViewModelProvider)
                .getMain(isCached: true, context: context);
          }
        }
        context.read(connectionProvider.notifier).state = result.first.name;
      },
    );
  }

  Widget _getChild(int index) {
    switch (index) {
      case 0:
        return context.read<TabBarViewModel>(tabBarViewModelProvider).isMaintenance? const AllProcScreen(): const HomeScreen();
      case 1:
        return context.read<TabBarViewModel>(tabBarViewModelProvider).isMaintenance?const SettingsScreen(): const AllProcScreen();
      case 2:
        return const PreInquiryScreen();
      case 3:
        return const SettingsScreen();
      default:
        return Container();
    }
  }
}

badge.Badge getBadge(
  BottomNavigationBarItem item, {
  bool isActive = false,
  String? value,
}) =>
    badge.Badge(
      badgeStyle: const badge.BadgeStyle(
        shape: badge.BadgeShape.circle,
        badgeColor: primaryColor,
      ),
      position: badge.BadgePosition.topEnd(top: -20, end: -20),
      badgeContent: Container(
        padding: const EdgeInsets.all(1),
        child: customTextApp(
          color: Colors.white,
          text: value ?? "",
          fontWeight: FontWeight.w600,
          size: 11,
        ),
      ),
      child: isActive ? item.activeIcon : item.icon,
    );
