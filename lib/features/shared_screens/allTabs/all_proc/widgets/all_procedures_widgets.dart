import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/extentions.dart';
import '../../../../../core/services/routing/navigation_service.dart';
import '../../../../../core/services/routing/routes.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/app_widgets/no_data_view.dart';
import '../../../../../core/utils/app_widgets/slidable_app_card.dart';
import '../../../../../core/utils/common_widgets/no_connection_widget.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../../../maintenance/presentation/delivery_and_receive/delivery_and_receive._screen.dart';
import '../../../tab_bar/tab_bar_screen.dart';
import '../../home/home_screen.dart';
import '../../settings/settings_view_model.dart';
import '../view_models/all_proc_view_model.dart';
import '../view_models/all_services_requests_view_model.dart';

class AllProcedurWidgets {
  List<Widget> getCRMContent(
      {required WidgetRef ref,
      required AllProcViewModel allProcViewModel,
      required BuildContext context}) {
    return [
      const SizedBox(height: 16),
      if (ref.watch(connectionProvider) == ConnectivityResult.none.name) ...[
        const NoConnectionWidget()
      ],
      if (allProcViewModel.proceduresList.isEmpty) ...[
        showNoDataView(
          context: context,
          minHeight: 160,
        ),
      ] else ...[
        listViewContainerBuilder(
          context: context,
          minHeight: 160,
          itemCount: allProcViewModel.filteredProcedures.length,
          itemBuilder: (BuildContext context, int index) {
            return slidable(
              isDark: context.read(settingsViewModelProvider).isDark,
              obj: allProcViewModel.filteredProcedures[index],
              ontap: () {
                goTopProcedureInformationScreen(
                  context,
                  allProcViewModel,
                  index,
                  ProcInfoStatusTypes.show,
                );
              },
              onTimerTap: () {
                goTopProcedurePlaceScreen(
                  context,
                  allProcViewModel.filteredProcedures[index],
                );
              },
              editFunc: (context) {
                goTopProcedureInformationScreen(
                  context,
                  allProcViewModel,
                  index,
                  ProcInfoStatusTypes.editing,
                  action: null,
                );
              },
              closeFunc: (context) {
                goTopProcedureInformationScreen(
                  context,
                  allProcViewModel,
                  index,
                  ProcInfoStatusTypes.close,
                  action: 2,
                );
              },
              confirmFunc: (context) {
                goTopProcedureInformationScreen(
                  context,
                  allProcViewModel,
                  index,
                  ProcInfoStatusTypes.close,
                  action: 1,
                );
              },
            );
          },
        ),
      ],
    ];
  }

  List<Widget> getMaintenanceContent(
      {required WidgetRef ref,
      required AllServicesRequestsViewModel allServicesRequestviewModel,
      required BuildContext context}) {
    return [
      // const SizedBox(height: 16),
      if (ref.watch(connectionProvider) == ConnectivityResult.none.name) ...[
        const NoConnectionWidget()
      ],
      if (allServicesRequestviewModel.filteredServicesRequestsList.isEmpty) ...[
        showNoDataView(
          context: context,
          minHeight: 160,
        ),
      ] else ...[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                allServicesRequestviewModel.changeFilterIndex(
                    allServicesRequestviewModel.filterIndex == 0 ? 1 : 0);
              },
              child: SizedBox(
                width: 120,
                child: Card(
                  color: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Center(
                      child: Text(
                        allServicesRequestviewModel
                            .filters[allServicesRequestviewModel.filterIndex],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        listViewContainerBuilder(
          context: context,
          minHeight: 160,
          itemCount:allServicesRequestviewModel.getServicesRequestLength(),
          itemBuilder: (BuildContext context, int index) {
            return serviceRequestSlidable(
              context: context,
              isDark: context.read(settingsViewModelProvider).isDark,
              obj:allServicesRequestviewModel.getServiceRequestObject(index),
              ontap: () {
                sl<NavigationService>().navigateTo(serviceInfoScreen);
              },
              deliveryAndCollectionFun: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeliveryFormScreen(
                    isReceived: index == 1,
                    customerName:allServicesRequestviewModel.getServiceRequestObject(index).clientName ,
                  ),
                ));
              },
              editFunc: (context) {},
            );
          },
        ),
      ]
    ];
  }

  goTopProcedureInformationScreen(
    BuildContext context,
    AllProcViewModel allProcViewModel,
    int index,
    ProcInfoStatusTypes isEdit, {
    int? action,
  }) {
    var procInfoViewModel = context.read(procInfoViewModelProvider);
    procInfoViewModel.eventAction = action;
    context.read(procInfoViewModel.procedureObj.state).state =
        allProcViewModel.filteredProcedures[index];

    context.read(procInfoViewModel.isEdit.state).state = isEdit;

    sl<NavigationService>().navigateTo(procedureInformationScreen);
  }
}
