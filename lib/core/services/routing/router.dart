import 'package:flutter/material.dart';

import '../../../features/shared_screens/pre_app/pre_app_screen.dart';
import '../../../features/crm/presentation/procedure_information/procedure_information_screen.dart';
import '../../../features/crm/presentation/procedure_information/vouchers/vouchers_screen.dart';
import '../../../features/crm/presentation/procedure_place/procedure_place_screen.dart';
import '../../../features/maintenance/presentation/check_and_repair/check_and_repair_screen.dart';
import '../../../features/maintenance/presentation/shared_views/signature_screen.dart';
import '../../../features/maintenance/presentation/service_details/service_info_screen.dart';
import '../../../features/shared_screens/allTabs/all_proc/all_proc_screen.dart';
import '../../../features/shared_screens/allTabs/home/home_screen.dart';
import '../../../features/shared_screens/allTabs/inquiry/filter_inquiry/filter_inquiry_screen.dart';
import '../../../features/shared_screens/allTabs/inquiry/inquiry_screen.dart';
import '../../../features/shared_screens/allTabs/settings/settings_screen.dart';
import '../../../features/shared_screens/auth/login/login_screen.dart';
import '../../../features/shared_screens/auth/signup/signup_screen.dart';
import '../../../features/shared_screens/tab_bar/tab_bar_screen.dart';
import 'routes.dart';
/*
  class provides a central location for defining and generating routes in a Flutter application.
  It maps route names to their corresponding widget builders using a switch statement and returns appropriate MaterialPageRoute objects for navigation.
 */

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case preAppScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: preAppScreen),
          builder: (_) => const PreAppScreen(),
        );
        
      case loginScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: loginScreen),
          builder: (_) => const LoginScreen(),
        );

      case signupScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: signupScreen),
          builder: (_) => const SignupScreen(),
        );

      case tabBarScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: tabBarScreen),
          builder: (_) => const TabBarScreen(),
        );

      case homeScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: homeScreen),
          builder: (_) => const HomeScreen(),
        );

      case allProcScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: allProcScreen),
          builder: (_) => const AllProcScreen(),
        );

      case procedureInformationScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: procedureInformationScreen),
          builder: (_) => const ProcedureInformationScreen(),
        );

      case vouchersScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: vouchersScreen),
          builder: (_) => const VouchersScreen(),
        );

      case filterInquiryScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: filterInquiryScreen),
          builder: (_) => const FilterInquiry(),
        );

      case procedurePlaceScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: procedurePlaceScreen),
          builder: (_) => const ProcedurePlaceScreen(),
        );

      case settingsScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: settingsScreen),
          builder: (_) => const SettingsScreen(),
        );
case inquiryScreen:
return  MaterialPageRoute(
          settings: const RouteSettings(name: inquiryScreen),
          builder: (_) => const InquiryScreen(),
        );
        case checkAndRepair:return  MaterialPageRoute(
          settings: const RouteSettings(name: inquiryScreen),
          builder: (_) => const CheckAndRepairScreen(),
        );
         case serviceInfoScreen:return  MaterialPageRoute(
          settings: const RouteSettings(name: serviceInfoScreen),
          builder: (_) => const ServiceInfoScreen(),
        );
           case signatureScreen:return  MaterialPageRoute(
          settings: const RouteSettings(name: signatureScreen),
          builder: (_) => const SignatureScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
