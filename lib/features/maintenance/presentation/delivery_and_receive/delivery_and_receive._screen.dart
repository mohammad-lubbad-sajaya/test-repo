import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:sajaya_general_app/core/services/extentions.dart';


import '../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../core/utils/app_widgets/custom_text_field.dart';
import '../../../../core/utils/app_widgets/maintenance_dropdown.dart';
import '../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../crm/presentation/allTabs/settings/settings_view_model.dart';
import '../../../crm/presentation/main_app_bar.dart';
import '../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../../crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../../../crm/presentation/procedure_place/widgets/meeting_view.dart';

import 'view_models/delivery_and_receive_view_model.dart';
import 'widgets/sing_widget.dart';

class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen({super.key});

  @override
  _DeliveryFormScreenState createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final _viewModel = context.read(deliveryAndReceiveViewModel);
    _viewModel.initTabController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: mainAppbar(
            context: context,
            isHideLogOut: true,
            text: "Delivery and Receive".localized(),
          ),
          body: Consumer(builder: (context, ref, child) {
            final _viewModel = ref.watch(deliveryAndReceiveViewModel);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      _buildTabBar(_viewModel),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildDatePicker(ref),
                      maintenanceDropDown(
                        'device type'.localized(),
                        _viewModel.selectedEquipmentType,
                        _viewModel.equipments,
                        (String? newValue) {
                          _viewModel.changeSelectedEquipmentType(newValue!);
                        },
                      ),
                      maintenanceDropDown('Supplement'.localized(), _viewModel.selectedAccessory1,
                          _viewModel.accessory, (String? newValue) {
                        _viewModel.changeSelectedAccessory1(newValue!);
                      }),
                      maintenanceDropDown(
                          _viewModel.tabIndex == 0 ? "Receive it".localized() : 'hand it over'.localized(),
                          _viewModel.workerName,
                          _viewModel.workers, (String? newValue) {
                        _viewModel.changeWorkerName(newValue!);
                      }),
                      customTextField('piece'.localized(), (p0) {},
                          focusNode: _viewModel.pieceFocusNode,
                          nextFocusNode: _viewModel.serialNumFocusNode,
                          context: context,
                          controller: _viewModel.pieceTextController),
                      customTextField('serial number'.localized(), (p0) {},
                          focusNode: _viewModel.serialNumFocusNode,
                          nextFocusNode: _viewModel.nameFocusNode,
                          context: context,
                          controller: _viewModel.serialNumTextController),
                      if (_viewModel.tabIndex == 1) ...[
                        customTextField('The recipient'.localized(), (p0) {},
                            focusNode: _viewModel.nameFocusNode,
                            nextFocusNode: _viewModel.notesFocusNode,
                            context: context,
                            controller: _viewModel.nameTextController),
                      ],
                      if (_viewModel.tabIndex == 0) ...[
                        ..._getImageView(),
                        customTextField('Notes '.localized(), (p0) {},
                            maxLines: 3,
                            focusNode: _viewModel.notesFocusNode,
                            context: context,
                            controller: _viewModel.noteTextControllere),
                      ],
                      if (_viewModel.tabIndex == 1) ...[
                        const SizedBox(height: 20),
                        const SignatureScreen(),
                      ],
                      const SizedBox(height: 20),
        
                      //  _buildSubmitButton(),
                      saveAndCancelButtons(
                        context,
                        _viewModel.isLoading,
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSave: () async {
                          final _signeture =
                              await _viewModel.signatureController.toPngBytes();
                          _viewModel.generatePDF(_signeture!, context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabBar(DeliveryAndReceiveViewModel _viewModel) {
    return SizedBox(
      height: 50,
      child: TabBar(
        controller: _viewModel.tabController,
        tabs: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: _viewModel.tabController.index == 0
                ? _getSelectedDecoration()
                : null,
            child: Tab(
              child: Text("Receive".localized(),
                  style: TextStyle(
                    fontSize: 13,
                      color: _viewModel.tabController.index == 0
                          ? Colors.white
                          : Colors.black)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: _viewModel.tabController.index == 1
                ? _getSelectedDecoration()
                : null,
            child: Tab(
              child: Text(
                "Deliver".localized(),
                style: TextStyle(
                  fontSize: 13,
                    color: _viewModel.tabController.index == 1
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
        ],
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: (value) {
          _viewModel.changeTabIndex(value);
        },
      ),
    );
  }

  BoxDecoration _getSelectedDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: secondaryColor);
  }

  Widget _buildDatePicker(WidgetRef ref) {
    final viewModel = ref.watch(procInfoViewModelProvider);
    final isDark = ref.watch(settingsViewModelProvider).isDark;
    return InkWell(
      onTap: () {
        viewModel.selectDateTime(context);
      },
      child: customRowApp(
        fontSize: 13,
        isDark: isDark,
        text: "Date and time".localized(),
        subText:
            viewModel.selectedDateTime.toStringFormat("hh:mm:ss dd/MM/yyyy"),
        subTitleTextColor: isDark ? backGroundColor : Colors.black,
        image: downArrow,
        imageWidth: 9,
      ),
    );
  }

  List<Widget> _getImageView() {
    return [
      const SizedBox(
        height: 10,
      ),
      CircleAvatar(
        radius: 22,
        backgroundColor: secondaryColor,
        child: IconButton(
          icon: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
          onPressed: () {
            // viewModel.captureImageOrViedo(isImage: true);
          },
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      selectedImagesListView(ProcedurePlaceViewModel(), false),
      const SizedBox(
        height: 10,
      ),
    ];
  }
}
