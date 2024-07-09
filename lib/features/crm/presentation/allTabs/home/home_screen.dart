import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';

import '../../../../../core/services/configrations/general_configrations.dart';
import '../../../../../core/services/routing/navigation_service.dart';
import '../../../../../core/services/routing/routes.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/drop_down_button.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/app_widgets/no_data_view.dart';
import '../../../../../core/utils/app_widgets/search_procedures.dart';
import '../../../../../core/utils/app_widgets/slidable_app_card.dart';
import '../../../../../core/utils/common_widgets/no_connection_widget.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/procedure.dart';
import '../../main_app_bar.dart';
import '../../procedure_information/procedure_information_view_model.dart';
import '../../procedure_place/procedure_place_view_model.dart';
import '../../tab_bar/tab_bar_screen.dart';
import '../settings/settings_view_model.dart';
import 'home_view_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read(homeViewModelProvider);
      viewModel.context = context;
      viewModel.getMain();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes here
     if(GeneralConfigurations().isDebug){
    log("App lifecycle state changed: $state");
     }
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      getCallLogs();
    }
  }

  Future<void> getCallLogs() async {
    // Iterable<CallLogEntry> entries = await CallLog.query(
    //   durationFrom: 0,
    //   durationTo: 100,
    // );

    // Iterate through the call log entries
    // for (var entry in entries) {
    //   log('Call Type: ${entry.callType}');
    //   log('Phone Number: ${entry.number}');
    //   log(
    //       'Call Date: ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)}');
    //   log('Call Duration: ${Duration(milliseconds: entry.duration ?? 0)}');
    //   log('-------------------------');
    // }
  }

  @override
  Widget build(BuildContext context) {
    var procInfoViewModel = context.read(procInfoViewModelProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: mainAppbar(text: "Open daily procedures".localized(),context: context),
        floatingActionButton: SizedBox(
          width: 60.0,
          height: 60.0,
          child: FloatingActionButton(
            backgroundColor: secondaryColor,
            onPressed: () {
              sl<NavigationService>().navigateTo(procedureInformationScreen);
              context.read(procInfoViewModel.procedureObj.state).state = null;
              context.read(procInfoViewModel.isEdit.state).state =
                  ProcInfoStatusTypes.addNew;
            },
            child: const Icon(Icons.add),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              side: BorderSide(color: Colors.white, width: 5),
            ),
            splashColor: primaryColor,
            elevation: 3.0,
          ),
        ),
        body: Consumer(
          builder: (context, ref, _) {
            final homeViewModel = ref.watch(homeViewModelProvider);
          //  final isDark=ref.watch(settingsViewModelProvider).isDark;

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: homeViewModel.refresh,
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

                            textController: homeViewModel.textController,
                            onChanged: homeViewModel.filterList,
                            suffixIcon:
                                (homeViewModel.textController.text.isEmpty)
                                    ? null
                                    : Image.asset(claerIcon),
                            suffixIconAction: () {
                              homeViewModel.clearSearch();
                            },
                          ),
                          showDateDropDownAndResetButton(
                              homeViewModel: homeViewModel),
                          const SizedBox(height: 16),
                          if (ref.watch(connectionProvider) ==
                              ConnectivityResult.none.name) ...[
                          const NoConnectionWidget()
                          ],
                          if (homeViewModel.proceduresList.isEmpty) ...[
                            showNoDataView(context: context, minHeight: 300),
                          ] else ...[
                         context.read(connectionProvider.notifier).state==ConnectivityResult.none.name?Padding(
                           padding: const EdgeInsets.only(top: 100),
                           child: Center(
                            child: Icon(Icons.wifi_off,color: Colors.grey[400],size: 80,),
                           ),
                         ):   listViewContainerBuilder(
                              context: context,
                              minHeight: 300,
                              itemCount:
                                  homeViewModel.filteredProcedures.length,
                              itemBuilder: (BuildContext context, int index) {
                                return slidable(
                                  isDark:context.read(settingsViewModelProvider).isDark,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

goTopProcedurePlaceScreen(
  BuildContext context,
  Procedure obj,
) {
  var procPlaceViewModel = context.read(procedurePlaceViewModelProvider);
  procPlaceViewModel.procedureObj = obj;

  sl<NavigationService>().navigateTo(procedurePlaceScreen);
}

goTopProcedureInformationScreen(
  BuildContext context,
  ProcInfoViewModel procInfoViewModel,
  HomeViewModel homeViewModel,
  int index,
  ProcInfoStatusTypes isEdit, {
  int? action,
}) {
  context.read(procInfoViewModel.procedureObj.state).state =
      homeViewModel.filteredProcedures[index];

  context.read(procInfoViewModel.isEdit.state).state = isEdit;
  procInfoViewModel.eventAction = action;
  sl<NavigationService>().navigateTo(procedureInformationScreen);
}

Widget showEnterdUser({required String? name}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: customTextApp(
        text: name ?? "",
        color: secondaryColor,
      ),
    );

Widget showDateDropDownAndResetButton({
  required HomeViewModel homeViewModel,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: dropDownButton(
              hintText: getToday(),
              items: homeViewModel.eventsCountList,
              selectedItem: homeViewModel.selectedEventCountDate,
              didSelectItem: (value) {
                homeViewModel.setSelectedEventCount(value);
              },
            ),
          ),
          const SizedBox(width: 10),
          todayButton(
            onTap: () {
              homeViewModel.resteDate();
            },
          ),
        ],
      ),
    );

Widget todayButton({
  void Function()? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(16),

          // boxShadow: shadow,
        ),
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Image.asset(
                todayIcon,
                height: 24,
              ),
              const SizedBox(width: 10),
              customTextApp(text: "Today".localized(), color: secondaryColor),
            ],
          ),
        ),
      ),
    );
