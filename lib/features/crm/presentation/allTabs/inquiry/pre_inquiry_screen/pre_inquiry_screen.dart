import 'package:flutter/material.dart';
import '../../../../../../core/services/extentions.dart';

import '../../../../../../core/services/routing/navigation_service.dart';
import '../../../../../../core/services/routing/routes.dart';
import '../../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../../core/utils/app_widgets/app_title.dart';
import '../../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../../settings/settings_view_model.dart';
import '../filter_inquiry/filter_inquiry_view_model.dart';
import '../inquiry_view_model.dart';

class PreInquiryScreen extends StatefulWidget {
  const PreInquiryScreen({super.key});

  @override
  State<PreInquiryScreen> createState() => _PreInquiryScreenState();
}

class _PreInquiryScreenState extends State<PreInquiryScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read(inquiryViewModelProvider);
    final filterviewModel = context.read(filterInquiryViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: appTitle(
            text: "Inquiry".localized(),
            isDark: context.read(settingsViewModelProvider).isDark),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
                label: "All Opened Procedures".localized(),
                onTap: () {
                  filterviewModel.reset();

                  //set selected period null to show all opened procedures
                  viewModel.changeIsGeneral(false);

                  context
                      .read(filterInquiryViewModelProvider)
                      .setSelectedPeriod(null);
                  viewModel.changeTitle("All Opened Procedures".localized());
                  sl<NavigationService>().navigateTo(inquiryScreen);
                }),
            _buildButton(
                label: "Open daily procedures".localized(),
                onTap: () {
                  filterviewModel.reset();

                  viewModel.changeIsGeneral(false);
                  viewModel.changeTitle("Open daily procedures".localized());

                  context
                      .read(filterInquiryViewModelProvider)
                      .setSelectedPeriod("2");
                  sl<NavigationService>().navigateTo(inquiryScreen);
                }),
            _buildButton(
                label: "late opened procedures".localized(),
                onTap: () {
                  filterviewModel.reset();
                  viewModel.changeTitle("late opened procedures".localized());
                  viewModel.changeIsGeneral(false);

                  context
                      .read(filterInquiryViewModelProvider)
                      .setSelectedPeriod("7");
                  sl<NavigationService>().navigateTo(inquiryScreen);
                }),
            _buildButton(
                label: "general inquiry".localized(),
                onTap: () {
                  viewModel.changeTitle("general inquiry".localized());

                  //set selected period null to show all opened procedures
                  context
                      .read(filterInquiryViewModelProvider)
                      .setSelectedPeriod(null);
                  viewModel.changeIsGeneral(true);

                  sl<NavigationService>().navigateTo(inquiryScreen);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({String label = "", void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 58,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
              color: context.read(settingsViewModelProvider).isDark
                  ? backGroundColor
                  : primaryColor,
              width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
            child: customTextApp(
                text: label,
                color: context.read(settingsViewModelProvider).isDark
                    ? backGroundColor
                    : primaryColor)),
      ),
    );
  }
}
