import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';


import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/check_user.dart';
import '../../../shared_screens/allTabs/all_proc/view_models/all_proc_view_model.dart';
import '../../../shared_screens/allTabs/home/home_view_model.dart';
import '../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../procedure_place/procedure_place_view_model.dart';
import '../../../shared_screens/tab_bar/tab_bar_view_model.dart';

import 'procedure_information_view_model.dart';
import 'proceduser_cards/show_close_proceduser_card.dart';
import 'proceduser_cards/show_editable_proceduser_card.dart';
import 'proceduser_cards/show_proceduser_card.dart';
import 'vouchers/vouchers_view_model.dart';

class ProcedureInformationScreen extends StatefulWidget {
  const ProcedureInformationScreen({super.key});

  @override
  State<ProcedureInformationScreen> createState() =>
      _ProcedureInformationScreenState();
}

class _ProcedureInformationScreenState
    extends State<ProcedureInformationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final viewModel = context.read(procInfoViewModelProvider);
        final obj = context.read(viewModel.procedureObj.state).state;
        final isEdit = context.read(viewModel.isEdit.state).state;

        viewModel.context = context;

        viewModel.resetCustomerFilters();
        viewModel.selectedDateTime = obj?.eventDate ?? DateTime.now();
        viewModel.durationValue = obj?.eventDuration?.toInt().toString() ??
            viewModel.selectedNaturObj?.option1.toString() ??
            "60";

        viewModel.contacValue = obj?.contactPerson;
        viewModel.noteValue = obj?.eventDesc;

        if (isEdit != ProcInfoStatusTypes.show) {
          viewModel.generateParameters();

          CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
          viewModel.getMain().then((value) => {
                if (isEdit != ProcInfoStatusTypes.addNew)
                  {
                    viewModel.showData(),
                  }
                else
                  {
                    viewModel.setSelectedRepresByUserName(user?.userName),
                  }
              });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final viewModel = ref.watch(procInfoViewModelProvider);
              final isEdit = context.read(viewModel.isEdit.state).state;
              return customTextApp(
                color: context.read(settingsViewModelProvider).isDark
                    ? backGroundColor
                    : Colors.black,
                text: viewModel.getTitleText(isEdit),
                fontWeight: FontWeight.w500,
              );
            },
          ),
          actions: [
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return IconButton(
                icon: Image.asset(
                  file,
                ),
                onPressed: () {
                  goToVoucherScreen(ref);
                },
              );
            }),
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final viewModel = ref.watch(procInfoViewModelProvider);

              final isEdit = ref.watch(viewModel.isEdit);

              return isEdit == ProcInfoStatusTypes.show ||
                      isEdit == ProcInfoStatusTypes.close ||isEdit == ProcInfoStatusTypes.addNew||
                      viewModel.isCloseEdit
                  ? Container()
                  : IconButton(
                      icon: const Icon(
                        Icons.upload_file,
                        size: 20,
                      ),
                      onPressed: () {
                        final _proc=ref.read(viewModel.procedureObj);
                        context.read(procedurePlaceViewModelProvider).changeIsEditProc(true);
                        context.read(procedurePlaceViewModelProvider).didChangeCustomerProcedure(_proc);
                           sl<NavigationService>().navigateTo(procedurePlaceScreen);

                      },
                    );
            }),
          ],
        ),
        body: Consumer(
          builder: (context, ref, _) {
            final viewModel = ref.watch(procInfoViewModelProvider);
            final obj = ref.watch(viewModel.procedureObj);
            final isEdit = ref.watch(viewModel.isEdit);
            final isDark = ref.watch(settingsViewModelProvider).isDark;

            return PopScope(
              onPopInvoked: (pop) async {
                viewModel.reset();
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: ScrollController(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  isDark ? darkModeBackGround : backGroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                            ),
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 110,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  if (isEdit == ProcInfoStatusTypes.show) ...[
                                    ShowProcedureCard(
                                      obj: obj,
                                      isDark: isDark,
                                    ),
                                  ] else ...[
                                    if (isEdit ==
                                        ProcInfoStatusTypes.close) ...[
                                      addNewCheckBox(
                                        isDark: isDark,
                                        value: viewModel.isCloseEdit,
                                        onChanged: (value) {
                                          viewModel.changeIsCloseEdit(value);
                                        },
                                      ),
                                      if (viewModel.isCloseEdit) ...[
                                        ShowCloseProcedureCard(
                                          obj: obj,
                                          isDark: isDark,
                                        ),
                                      ] else ...[
                                        ShowProcedureCard(
                                          obj: obj,
                                          isDark: isDark,
                                        ),
                                      ],
                                    ] else ...[
                                      ShowEditableProcedureCard(
                                        obj: obj,
                                        isDark: isDark,
                                      ),
                                    ],
                                    const SizedBox(height: 16.0),
                                    saveAndCancelButtons(
                                      context,
                                      viewModel.isLoading,
                                      onSave: () {
                                        saveButton(ref, isEdit, viewModel);
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(height: 32.0),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  goToVoucherScreen(WidgetRef ref) {
    final viewModel = context.read(procInfoViewModelProvider);
    final vouchersViewModel = ref.watch(vouchersViewModelProvider);

    vouchersViewModel.context = context;

    vouchersViewModel.procedureObj =
        context.read(viewModel.procedureObj.state).state;
    var isEdit = context.read(viewModel.isEdit.state).state;
    vouchersViewModel.isEdit = isEdit;

    // if (isEdit != ProcInfoStatusTypes.show) {
    //   if (isEdit == ProcInfoStatusTypes.addNew) {
    //     if (viewModel.checkAddEnteredData() == false) {
    //       //showErrorDialog(message: "entered data is not complete".localized());
    //       return;
    //     }
    //   }
    //   showConfirmationDialog(
    //     context: sl<NavigationService>().getContext(),
    //     title: 'Warning!'.localized(),
    //     content:
    //         "The procedure will be saved, do you want to continue".localized(),
    //     onAccept: () {
    //       saveButton(
    //         ref,
    //         isEdit,
    //         viewModel,
    //         isShowLoading: false,
    //       ).then((value) => {
    //             sl<NavigationService>().navigateTo(vouchersScreen),
    //           });
    //     },
    //   );
    // } else {
    sl<NavigationService>().navigateTo(vouchersScreen);
    //  }
  }

  Future saveButton(
    WidgetRef ref,
    ProcInfoStatusTypes isEdit,
    ProcInfoViewModel viewModel, {
    bool isShowLoading = true,
  }) async {
    if (isEdit == ProcInfoStatusTypes.addNew) {
      await viewModel.addnew().then(
            (id) => {
              if (id != null)
                {
                  refreshMainView(ref, isShowLoading: isShowLoading),
                  viewModel.reset(),
                }
            },
          );
    } else if (isEdit == ProcInfoStatusTypes.editing) {
      await viewModel
          .editEvent(
              object: context.read(viewModel.procedureObj.notifier).state)
          .then(
            (id) => {
              if (id != null)
                {
                  refreshMainView(ref, isShowLoading: isShowLoading),
                  viewModel.reset(),
                }
            },
          );
    } else if (isEdit == ProcInfoStatusTypes.close) {
      await viewModel
          .duplicateEvent(
              object: context.read(viewModel.procedureObj.notifier).state)
          .then(
            (id) => {
              if (id != null)
                {
                  refreshMainView(ref, isShowLoading: isShowLoading),
                  viewModel.reset(),
                }
            },
          );
    }
  }

  refreshMainView(
    WidgetRef ref, {
    bool isShowLoading = true,
  }) {
    final tabBarviewModel = context.read(tabBarViewModelProvider);
    final selectedIndex = context.read(tabBarviewModel.selectedIndex.state);

    final homeViewModel = ref.watch(homeViewModelProvider);
    final allProcViewModel = ref.watch(allProcModelProvider);

    if (selectedIndex.state == 1) {
      allProcViewModel.getMain(isShowLoading: isShowLoading);
      homeViewModel.getMain(isShowLoading: false);
    } else {
      homeViewModel.getMain(isShowLoading: isShowLoading);
    }
  }
}

addNewCheckBox({
  required bool? value,
  required bool isDark,
  required void Function(bool?)? onChanged,
  double horizontal = 20.0,
}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal),
      child: Row(
        children: [
          customTextApp(
              text: "Add new procedure".localized(),
              color: isDark ? backGroundColor : Colors.black),
          Checkbox(
            side: BorderSide(color: isDark ? backGroundColor : Colors.black),
            activeColor: secondaryColor,
            checkColor: Colors.white,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
