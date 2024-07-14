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
import '../../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../../../maintenance/presentation/delivery_and_receive/delivery_and_receive._screen.dart';
import '../../../tab_bar/tab_bar_screen.dart';
import '../../all_proc/view_models/all_services_requests_view_model.dart';
import '../../settings/settings_view_model.dart';
import '../home_screen.dart';
import '../home_view_model.dart';

class HomeWidgets {
  List<Widget> getCrmContent(
      {required WidgetRef ref, required BuildContext context}) {
    var homeViewModel = ref.watch(homeViewModelProvider);
    var procInfoViewModel = ref.watch(procInfoViewModelProvider);
    return [
      if (homeViewModel.proceduresList.isEmpty) ...[
        showNoDataView(context: context, minHeight: 300),
      ] else ...[
        context.read(connectionProvider.notifier).state ==
                ConnectivityResult.none.name
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Icon(
                    Icons.wifi_off,
                    color: Colors.grey[400],
                    size: 80,
                  ),
                ),
              )
            : listViewContainerBuilder(
                context: context,
                minHeight: 300,
                itemCount: homeViewModel.filteredProcedures.length,
                itemBuilder: (BuildContext context, int index) {
                  return slidable(
                    isDark: context.read(settingsViewModelProvider).isDark,
                    obj: homeViewModel.filteredProcedures[index],
                    ontap: () {
                      goTopProcedureInformationScreen(
                        context,
                        procInfoViewModel,
                        homeViewModel,
                        index,
                        ProcInfoStatusTypes.show,
                      );
                    },
                    onTimerTap: () {
                      goTopProcedurePlaceScreen(
                        context,
                        homeViewModel.filteredProcedures[index],
                      );
                    },
                    editFunc: (context) {
                      goTopProcedureInformationScreen(
                        context,
                        procInfoViewModel,
                        homeViewModel,
                        index,
                        ProcInfoStatusTypes.editing,
                        action: 0,
                      );
                    },
                    closeFunc: (context) {
                      goTopProcedureInformationScreen(
                        context,
                        procInfoViewModel,
                        homeViewModel,
                        index,
                        ProcInfoStatusTypes.close,
                        action: 2, // cancel
                      );
                    },
                    confirmFunc: (context) {
                      goTopProcedureInformationScreen(
                        context,
                        procInfoViewModel,
                        homeViewModel,
                        index,
                        ProcInfoStatusTypes.close,
                        action: 1, // close
                      );
                    },
                  );
                },
              ),
      ],
    ];
  }

  List<Widget> getMaintenanceContent(
      {required WidgetRef ref, required BuildContext context}) {
    final allServicesModel = ref.watch(allServicesRequestviewModel);
    return [
      const SizedBox(height: 16),
      if (ref.watch(connectionProvider) == ConnectivityResult.none.name) ...[
        const NoConnectionWidget()
      ],
      if (allServicesModel.filteredServicesRequestsList.isEmpty) ...[
        showNoDataView(
          context: context,
          minHeight: 160,
        ),
      ] else ...[
        listViewContainerBuilder(
          context: context,
          minHeight: 160,
          itemCount: allServicesModel.filteredServicesRequestsList
              .where((element) =>
                  element.date.day == DateTime.now().day &&
                  element.date.year == DateTime.now().year)
              .length,
          itemBuilder: (BuildContext context, int index) {
            final _object = allServicesModel.filteredServicesRequestsList
                .where((element) =>
                    element.date.day == DateTime.now().day &&
                    element.date.year == DateTime.now().year)
                .toList()[index];
            return serviceRequestSlidable(
              context: context,
              isDark: context.read(settingsViewModelProvider).isDark,
              obj: _object,
              ontap: () {
                sl<NavigationService>().navigateTo(serviceInfoScreen);
              },
              deliveryAndCollectionFun: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeliveryFormScreen(
                    customerName: _object.clientName,
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
}
