import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/services/routing/navigation_service.dart';
import '../../../../../core/services/routing/routes.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/app_widgets/custom_text_field.dart';
import '../../../../../core/utils/app_widgets/maintenance_dropdown.dart';
import '../../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../../../crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../view_model/check_repair_view_model.dart';

class AddRepairProcedureView extends StatelessWidget {
  const AddRepairProcedureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _viewModel = ref.watch(checkAndRepairViewModel);
      final isDark = ref.watch(settingsViewModelProvider).isDark;
      return buildAddProcedureView(isDark, ref, context, _viewModel);
    });
  }

  Widget buildAddProcedureView(bool isDark, WidgetRef ref, BuildContext context,
      CheckAndRepairViewModel _viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          customRowApp(
            isDark: isDark,
            text: "bond no".localized(),
            subText: _viewModel.currentBondNumber.toString(),
            subTitleTextColor: Colors.grey,
            imageWidth: 9,
          ),
          _buildDatePicker(ref, context, true),
          maintenanceDropDown(
              isIgnore: _viewModel.isNotEditiable,
              'service type'.localized(),
              _viewModel.selectedServiceType,
              _viewModel.serviceTypes, (String? newValue) {
            _viewModel.changeServiceType(newValue!);
          }),
          maintenanceDropDown(
              isIgnore: _viewModel.isNotEditiable,
              'service location'.localized(),
              _viewModel.selectedServiceLocation,
              _viewModel.serviceLocations, (String? newValue) {
            _viewModel.changeServiceLocation(newValue!);
          }),
          maintenanceDropDown(
              isIgnore: _viewModel.isNotEditiable,
              'case'.localized(),
              _viewModel.selectedCase,
              _viewModel.caseList, (String? newValue) {
            _viewModel.changeCase(newValue!);
          }),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'case'.localized() + " " + "details".localized(),
              (p0) {},
              context: context,
              controller: _viewModel.caseDetailTextCtrl),
          maintenanceDropDown(
              'action'.localized(),
              _viewModel.selectedAction,
              isIgnore: _viewModel.isNotEditiable,
              _viewModel.actionList, (String? newValue) {
            _viewModel.changeAction(newValue!);
          }),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'action'.localized() + " " + "details".localized(),
              (p0) {},
              context: context,
              controller: _viewModel.actionDetailTextCtrl),
          maintenanceDropDown(
              'cause'.localized(),
              _viewModel.selectedCause,
              isIgnore: _viewModel.isNotEditiable,
              _viewModel.causeList, (String? newValue) {
            _viewModel.changeCause(newValue!);
          }),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'cause'.localized() + " " + "details".localized(),
              (p0) {},
              context: context,
              controller: _viewModel.causeDetailTextCtrl),
          maintenanceDropDown(
              'corrupted item'.localized(),
              _viewModel.selectedCorruptedItem,
              isIgnore: _viewModel.isNotEditiable,
              _viewModel.corruptedItemList, (String? newValue) {
            _viewModel.changeCorruptedItem(newValue!);
          }),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'corrupted item'.localized() + " " + "details".localized(),
              (p0) {},
              context: context,
              controller: _viewModel.corruptedItemDetailTextCtrl),
          maintenanceDropDown(
              'alternate item'.localized(),
              _viewModel.selectedAlternateItem,
              isIgnore: _viewModel.isNotEditiable,
              _viewModel.alternateItemList, (String? newValue) {
            _viewModel.changeAlternateItem(newValue!);
          }),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'alternate item'.localized() + " " + "details".localized(),
              (p0) {},
              context: context,
              controller: _viewModel.alternateItemDetailTextCtrl),
          _buildDatePicker(ref, context, _viewModel.isNotEditiable,
              label: "start date".localized()),
          _buildDatePicker(ref, context, _viewModel.isNotEditiable,
              label: "finish date".localized()),
          customTextField(
              enabled: !_viewModel.isNotEditiable,
              'Notes :'.localized(),
              (p0) {},
              maxLines: 3,
              context: context,
              controller: _viewModel.notesTextCtrl),
          const SizedBox(
            height: 20,
          ),
          saveAndCancelButtons(
            context,
            false,
            onCancel: () {
              Navigator.pop(context);
            },
            onSave: () async {
              context
                  .read(procedurePlaceViewModelProvider)
                  .changeIsFromCheckAndRepair(true);
              _viewModel.checkOut();

              sl<NavigationService>().navigateTo(procedurePlaceScreen);
            },
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(WidgetRef ref, BuildContext context, bool isReadOnly,
      {String? label}) {
    final viewModel = ref.watch(checkAndRepairViewModel);
    final isDark = ref.watch(settingsViewModelProvider).isDark;
    final procInfoViewModel = ref.watch(procInfoViewModelProvider);

    return InkWell(
      onTap: () {
        if (isReadOnly) {
          return;
        }
        procInfoViewModel.selectDateTime(context);
      },
      child: customRowApp(
        isDark: isDark,
        text: label ?? "Date and time".localized(),
        subText: isReadOnly
            ? viewModel.bondDate.toStringFormat("hh:mm:ss dd/MM/yyyy")
            : procInfoViewModel.selectedDateTime
                .toStringFormat("hh:mm:ss dd/MM/yyyy"),
        subTitleTextColor: isReadOnly
            ? Colors.grey
            : isDark
                ? backGroundColor
                : Colors.black,
        imageWidth: 9,
        image: isReadOnly ? null : downArrow,
      ),
    );
  }
}
