import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_widgets/floating_action_button.dart';
import '../../../../core/services/extentions.dart';

import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/search_procedures.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../crm/presentation/main_app_bar.dart';
import '../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../tab_bar/tab_bar_view_model.dart';
import '../home/home_screen.dart';
import '../home/home_view_model.dart';
import 'view_models/all_proc_view_model.dart';
import 'view_models/all_services_requests_view_model.dart';
import 'widgets/all_procedures_widgets.dart';

class AllProcScreen extends StatefulWidget {
  const AllProcScreen({super.key});

  @override
  State<AllProcScreen> createState() => _AllProcScreenState();
}

class _AllProcScreenState extends State<AllProcScreen> {
  bool _isMaintenance = false;
  AllServicesRequestsViewModel? viewModel;
  @override
  void initState() {
    super.initState();
    _isMaintenance =
        context.read<TabBarViewModel>(tabBarViewModelProvider).isMaintenance;
    if (!_isMaintenance) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final viewModel = context.read(allProcModelProvider);
        viewModel.context = context;
        viewModel.getMain();
      });
    } else {
      viewModel = context.read(allServicesRequestviewModel);
      viewModel?.context = context;
      viewModel?.initServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    var procInfoViewModel = context.read(procInfoViewModelProvider);

    return Consumer(
      builder: (context, ref, _) {
        final homeViewModel = ref.watch(homeViewModelProvider);
        final allProcViewModel = ref.watch(allProcModelProvider);
        allProcViewModel.context = context;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: mainAppbar(
                text: _isMaintenance
                    ? "service request".localized()
                    : "All Opened Procedures".localized(),
                context: context),
            floatingActionButton: _isMaintenance
                ? Container()
                : floatingActionButton(
                    onPressed: () {
                      sl<NavigationService>()
                          .navigateTo(procedureInformationScreen);
                      context.read(procInfoViewModel.procedureObj.state).state =
                          null;
                      context.read(procInfoViewModel.isEdit.state).state =
                          ProcInfoStatusTypes.addNew;
                    },
                  ),
            body: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: allProcViewModel.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: ScrollController(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!homeViewModel.isUserIDSelected(
                              homeViewModel.selectedEnteredUser)) ...[
                            showEnterdUser(
                              name: homeViewModel.getSelectedEnteredUserName(),
                            ),
                          ],
                          showSearchProcedures(
                            onChanged: _isMaintenance
                                ? viewModel?.filterList
                                : allProcViewModel.filterList,
                            textController: _isMaintenance
                                ? viewModel?.textController
                                : allProcViewModel.textController,
                            suffixIcon:
                                (allProcViewModel.textController.text.isEmpty)
                                    ? null
                                    : Image.asset(claerIcon),
                            suffixIconAction: () {
                              _isMaintenance
                                  ? viewModel?.clearSearch()
                                  : allProcViewModel.clearSearch();
                            },
                          ),
                          if (_isMaintenance)
                            ...AllProcedurWidgets().getMaintenanceContent(
                                allServicesRequestviewModel:
                                    ref.watch(allServicesRequestviewModel),
                                context: context,
                                ref: ref)
                          else
                            ...AllProcedurWidgets().getCRMContent(
                                allProcViewModel: allProcViewModel,
                                context: context,
                                ref: ref),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
