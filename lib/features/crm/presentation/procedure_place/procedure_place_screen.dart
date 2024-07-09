import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/foundation.dart';
import '../../../../core/services/extentions.dart';


import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../allTabs/settings/settings_view_model.dart';
import '../tab_bar/tab_bar_view_model.dart';
import 'procedure_place_view_model.dart';
import 'widgets/add_address_view.dart';
import 'widgets/all_customer_address.dart';
import 'widgets/customer_procedures.dart';
import 'widgets/header_address_card.dart';
import 'widgets/meeting_view.dart';
import 'widgets/nearby_customers.dart';
import 'widgets/procedure_info_card.dart';
import 'widgets/tab_buttons.dart';

class ProcedurePlaceScreen extends StatefulWidget {
  const ProcedurePlaceScreen({super.key});

  @override
  State<ProcedurePlaceScreen> createState() => _ProcedurePlaceScreenState();
}

class _ProcedurePlaceScreenState extends State<ProcedurePlaceScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final viewModel = context.read(procedurePlaceViewModelProvider);
        viewModel.context = context;

        viewModel.getMain();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes here
    if (GeneralConfigurations().isDebug) {
      log("App lifecycle state changed: $state");
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final viewModel = ref.watch(procedurePlaceViewModelProvider);
      final tabBarViewModel = ref.watch(tabBarViewModelProvider);
      final isDark = ref.watch(settingsViewModelProvider).isDark;
      return PopScope(
        onPopInvoked: (pop) async {
          if (!viewModel.canDismiss) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text(
            //         'Pop Screen Disabled. You cannot go to previous screen.'),
            //     backgroundColor: Colors.red,
            //   ),
            // );
          }
        },
        child: Scaffold(
          floatingActionButton: tabBarViewModel.isMockedLocation ||
                  tabBarViewModel.isEmulator
              ? const SizedBox()
              : viewModel.selectedTab == 3
                  ? SizedBox(
                      width: 60.0,
                      height: 60.0,
                      child: FloatingActionButton(
                        backgroundColor: secondaryColor.withOpacity(0.9),
                        onPressed: () {
                          viewModel.isEditAdressLocation = true;
                          viewModel.nameA = "";
                          viewModel.nameE = "";
                          viewModel.selectedArea = null;
                          viewModel.didSelectAddAddress(isEdit: false);
                        },
                        child: const Icon(Icons.add),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          side: BorderSide(color: Colors.white, width: 5),
                        ),
                        splashColor: primaryColor,
                        elevation: 3.0,
                      ),
                    )
                  : const SizedBox(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: AppBar(),
          ),
          body: (tabBarViewModel.isMockedLocation || tabBarViewModel.isEmulator)&&kReleaseMode==true
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("location is mocked".localized()),
                  ),
                )
              : PopScope(
                  onPopInvoked: (pop) async {
                    viewModel.reset();
                  },
                  child: Container(
                    
                    color: isDark ? darkModeBackGround : backGroundColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(viewModel.isEditProcedure||viewModel.isFromCheckAndRepair)...[
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon: Icon(Icons.arrow_back_ios,color: isDark?backGroundColor:Colors.black,))
                          ],
                        viewModel.isEditProcedure||viewModel.isFromCheckAndRepair?Container():  tabButtons(viewModel, context,isDark),
                          if (viewModel.selectedTab != 5) ...[
                            const SizedBox(height: 10),
                          ],
                      viewModel.isEditProcedure||viewModel.isFromCheckAndRepair?Container():     InkWell(
                            onTap: () {
                              viewModel.hideTopBox();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Icon(
                                viewModel.isHideTopBox
                                    ? Icons.add_circle
                                    : Icons.remove_circle,
                                color: secondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (!viewModel.isHideTopBox&&!viewModel.isEditProcedure&&!viewModel.isFromCheckAndRepair) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: headerAddressCard(
                                isDark: isDark,
                                viewModel: viewModel,
                                context: context,
                                onTapStartMeeting: () {
                                  viewModel.changeSelectedTab(5);
                                },
                                onTapEditPin: () {
                                  if (viewModel.selectedTab != 5) {
                                    viewModel.isEditAdressLocation = false;
                                    viewModel.didSelectAddAddress(isEdit: true);
                                  }
                                },
                                onTapEditLocation: () {
                                  if (viewModel.selectedTab != 5) {
                                    viewModel.isEditAdressLocation = true;
                                    viewModel.didSelectAddAddress(isEdit: true);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          if (viewModel.selectedTab == 0&&!viewModel.isEditProcedure&&!viewModel.isFromCheckAndRepair) ...[
                            procedureInfoCard(
                                obj: viewModel.procedureObj, isDark: isDark),
                          ] else if (viewModel.selectedTab == 1&&viewModel.selectedCustomerAddress?.locationNorth!=null&&viewModel.selectedCustomerAddress?.locationEast!=null) ...[
                            nearbyCustomers(
                              isDark: isDark,
                              viewModel: viewModel,
                              context: context,
                            ),
                          ] else if (viewModel.selectedTab == 2) ...[
                            customerProcedures(
                              isDark: isDark,
                              context: context,
                              viewModel: viewModel,
                            ),
                          ] else if (viewModel.selectedTab == 3) ...[
                            allCustomerAddress(
                              isDark: isDark,
                              context: context,
                              viewModel: viewModel,
                            ),
                          ] else if (viewModel.selectedTab == 4) ...[
                            addAddressView(
                              isDark: isDark,
                                context: context, viewModel: viewModel),
                          ] else if (viewModel.selectedTab == 5||viewModel.isEditProcedure||viewModel.isFromCheckAndRepair) ...[
                            meetingView(context: context, viewModel: viewModel,isDark: isDark),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
