import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajaya_general_app/core/utils/app_widgets/check_repairs_proc_card.dart';
import 'package:sajaya_general_app/features/maintenance/presentation/check_and_repair/view_model/check_repair_view_model.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/utils/app_widgets/check_box.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../core/utils/common_widgets/error_dialog.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../crm/presentation/main_app_bar.dart';
import '../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../delivery_and_receive/view_models/delivery_and_receive_view_model.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key, this.isCheckAndRepair = false})
      : super(key: key);
  final bool isCheckAndRepair;
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust duration as needed
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSwitch() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _animationController.forward(); // Play forward animation
      } else {
        _animationController.reverse(); // Play reverse animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppbar(
        context: context,
        isHideLogOut: true,
        text: "signature screen".localized(),
      ),
      body: Consumer(builder: (context, ref, child) {
        final _viewModel = ref.watch(deliveryAndReceiveViewModel);
        final _isDark = ref.watch(settingsViewModelProvider).isDark;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isCheckAndRepair) ...[
                  _getCheckRepairData(),
                ],
                if (!widget.isCheckAndRepair) ...[
                  _getDeliverReport(_viewModel),
                ],
                const SizedBox(
                  height: 20,
                ),
                Signature(
                  controller: _viewModel.signatureController,
                  height: 40.h,
                  width: 100.w,
                  backgroundColor: Colors.grey[400]!,
                ),
                const SizedBox(
                  height: 30,
                ),
                buildCheckBoxView(
                    isDark: _isDark,
                    value: _viewModel.isChecked,
                    onTap: () => _viewModel.onCheck(!_viewModel.isChecked),
                    title: "skip".localized()),
                const SizedBox(
                  height: 10,
                ),
                saveAndCancelButtons(
                    context,
                    secondButtonName: "clear".localized(),
                    _viewModel.isLoading, onCancel: () {
                  _viewModel.signatureController.clear();
                }, onSave: () async {
                  if (_viewModel.signatureController.isEmpty &&
                      !_viewModel.isChecked) {
                    showErrorDialog(message: "sign empty".localized());
                  } else {
                    final _signeture =
                        await _viewModel.signatureController.toPngBytes();
                    await _viewModel.generatePDF(_signeture, context);
                  }
                }),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _getCheckRepairData() {
    final _isDark = context.read(settingsViewModelProvider).isDark;
    final _model = context.read(checkAndRepairViewModel);
    if (_model.selectedAction == null &&
        _model.actionDetailTextCtrl.text.isEmpty &&
        _model.selectedAlternateItem == null) {
      return Container();
    }
    return buildCheckRepairProcedureCard(
      null,
      _isDark,
      childrenList: [
        customTextApp(
          color: secondaryColor,
          size: 22,
          fontWeight: FontWeight.bold,
          text: "report".localized(),
        ),
        if (_model.selectedAction != null) ...[
          customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "action".localized() +
                "  : " +
                _model.selectedAction.toString(),
          ),
        ],
        if (_model.actionDetailTextCtrl.text.isNotEmpty) ...[
          customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: 'action'.localized() +
                " " +
                "details".localized() +
                "  : " +
                _model.actionDetailTextCtrl.text,
          ),
        ],
        if (_model.selectedAlternateItem != null) ...[
          customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "alternate item".localized() +
                "  : " +
                _model.selectedAlternateItem.toString(),
          ),
        ],
      ],
    );
  }

  _getDeliverReport(DeliveryAndReceiveViewModel viewModel) {
    final _isDark = context.read(settingsViewModelProvider).isDark;
    if (viewModel.nameTextController.text.isEmpty &&
        viewModel.nameTextController.text.isEmpty &&
        viewModel.serialNumTextController.text.isEmpty &&
        viewModel.selectedEquipmentType == null &&
        viewModel.selectedAccessory1 == null) {
      return Container();
    }
    return buildCheckRepairProcedureCard(null, _isDark, childrenList: [
      customTextApp(
        color: secondaryColor,
        size: 22,
        fontWeight: FontWeight.bold,
        text: "report".localized(),
      ),
      if (viewModel.nameTextController.text.isNotEmpty) ...[
        customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "Customer".localized() + " : " + viewModel.customerName),
      ],
      if (viewModel.nameTextController.text.isNotEmpty) ...[
        customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "Receive it".localized() +
                " : " +
                viewModel.nameTextController.text),
      ],
      if (viewModel.serialNumTextController.text.isNotEmpty) ...[
        customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "serial num".localized() +
                " : " +
                viewModel.serialNumTextController.text),
      ],
      if (viewModel.selectedEquipmentType != null) ...[
        customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "device type".localized() +
                " : " +
                viewModel.selectedEquipmentType!),
      ],
      if (viewModel.selectedAccessory1 != null) ...[
        customTextApp(
            color: _isDark ? backGroundColor : Colors.black,
            size: 15,
            fontWeight: FontWeight.w500,
            text: "Supplement".localized() +
                " : " +
                viewModel.selectedAccessory1!),
      ],
    ]);
  }
}
