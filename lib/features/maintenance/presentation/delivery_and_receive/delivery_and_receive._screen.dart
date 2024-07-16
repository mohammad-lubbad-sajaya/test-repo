import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/methods/convert_to_dropdownobj_list.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';

import '../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../core/utils/app_widgets/custom_text_field.dart';
import '../../../../core/utils/app_widgets/drop_horizontal_down_button.dart';
import '../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../../../crm/presentation/main_app_bar.dart';
import '../../../crm/presentation/procedure_information/procedure_information_view_model.dart';
import '../../../crm/presentation/procedure_place/procedure_place_view_model.dart';
import '../../../crm/presentation/procedure_place/widgets/meeting_view.dart';

import 'view_models/delivery_and_receive_view_model.dart';

class DeliveryFormScreen extends StatefulWidget {
  const DeliveryFormScreen(
      {super.key, this.isReceived = false, required this.customerName});
  final bool isReceived;
  final String customerName;

  @override
  _DeliveryFormScreenState createState() => _DeliveryFormScreenState();
}

class _DeliveryFormScreenState extends State<DeliveryFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _viewModel = context.read(deliveryAndReceiveViewModel);
      await _viewModel.initTabController(this, widget.isReceived ? 1 : 0);
      _viewModel.setCustomerName(widget.customerName);
      if (widget.isReceived) {
        _viewModel.changeSelectedEquipmentType(_viewModel.equipments.first);
        _viewModel.changeSelectedAccessory1(_viewModel.accessory.first);
        _viewModel.changeWorkerName(_viewModel.workers.first);
        _viewModel.pieceTextController.text = "keyboared";
        _viewModel.noteTextControllere.text = "no notes for now";
        _viewModel.serialNumTextController.text = "55-78444-45455";
      }
    });

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
            return _viewModel.tabController == null
                ? Container()
                : SingleChildScrollView(
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
                            _buildDatePicker(
                                ref,
                                (widget.isReceived &&
                                    _viewModel.tabIndex == 0)),
                            dropDownHorizontalButton(
                              isIgnore:
                                  widget.isReceived && _viewModel.tabIndex == 0,
                              hintText: 'device type'.localized(),
                              selectedItem: _viewModel.selectedEquipmentType,
                              items:
                                  convertToDropdownObj(_viewModel.equipments),
                              didSelectItem: (String? newValue) {
                                _viewModel
                                    .changeSelectedEquipmentType(newValue!);
                              },
                            ),
                            dropDownHorizontalButton(
                                isIgnore: widget.isReceived &&
                                    _viewModel.tabIndex == 0,
                                hintText: 'Supplement'.localized(),
                                selectedItem: _viewModel.selectedAccessory1,
                                items:
                                    convertToDropdownObj(_viewModel.accessory),
                                didSelectItem: (String? newValue) {
                                  _viewModel
                                      .changeSelectedAccessory1(newValue!);
                                }),
                            dropDownHorizontalButton(
                                isIgnore: widget.isReceived &&
                                    _viewModel.tabIndex == 0,
                                hintText: _viewModel.tabIndex == 0
                                    ? "Receive it".localized()
                                    : 'hand it over'.localized(),
                                selectedItem: _viewModel.workerName,
                                items: convertToDropdownObj(_viewModel.workers),
                                didSelectItem: (String? newValue) {
                                  _viewModel.changeWorkerName(newValue!);
                                }),
                            customTextField('piece'.localized(), (p0) {},
                                focusNode: _viewModel.pieceFocusNode,
                                nextFocusNode: _viewModel.serialNumFocusNode,
                                context: context,
                                enabled: !(widget.isReceived &&
                                    _viewModel.tabIndex == 0),
                                controller: _viewModel.pieceTextController),
                            customTextField(
                                'serial number'.localized(), (p0) {},
                                focusNode: _viewModel.serialNumFocusNode,
                                nextFocusNode: _viewModel.nameFocusNode,
                                enabled: !(widget.isReceived &&
                                    _viewModel.tabIndex == 0),
                                context: context,
                                controller: _viewModel.serialNumTextController),
                            if (_viewModel.tabIndex == 1) ...[
                              customTextField(
                                  'The recipient'.localized(), (p0) {},
                                  focusNode: _viewModel.nameFocusNode,
                                  nextFocusNode: _viewModel.notesFocusNode,
                                  enabled: !(widget.isReceived &&
                                      _viewModel.tabIndex == 0),
                                  context: context,
                                  controller: _viewModel.nameTextController),
                            ],
                            ..._getImageView(),
                            if (_viewModel.tabIndex == 0) ...[
                              customTextField('Notes'.localized(), (p0) {},
                                  maxLines: 3,
                                  focusNode: _viewModel.notesFocusNode,
                                  enabled: !(widget.isReceived &&
                                      _viewModel.tabIndex == 0),
                                  context: context,
                                  controller: _viewModel.noteTextControllere),
                            ],

                            const SizedBox(height: 20),

                            //  _buildSubmitButton(),
                            if (!(widget.isReceived &&
                                _viewModel.tabIndex == 0))
                              saveAndCancelButtons(
                                context,
                                _viewModel.isLoading,
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onSave: () async {
                                  if (_viewModel.tabIndex == 0) {
                                    Navigator.pop(context);
                                  } else {
                                    sl<NavigationService>()
                                        .navigateTo(signatureScreen);
                                  }
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
            decoration: _viewModel.tabController!.index == 0
                ? _getSelectedDecoration()
                : null,
            child: Tab(
              child: Text("Receive".localized(),
                  style: TextStyle(
                      fontSize: 13,
                      color: _viewModel.tabController!.index == 0
                          ? Colors.white
                          : Colors.black)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: _viewModel.tabController!.index == 1
                ? _getSelectedDecoration()
                : null,
            child: Tab(
              child: Text(
                "Deliver".localized(),
                style: TextStyle(
                    fontSize: 13,
                    color: _viewModel.tabController!.index == 1
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

  Widget _buildDatePicker(WidgetRef ref, bool isReadOnly) {
    final viewModel = ref.watch(procInfoViewModelProvider);
    final isDark = ref.watch(settingsViewModelProvider).isDark;
    return InkWell(
      onTap: () {
        if (isReadOnly) {
          return;
        }
        viewModel.selectDateTime(context);
      },
      child: customRowApp(
        fontSize: 13,
        isDark: isDark,
        text: "Date and time".localized(),
        subText:
            viewModel.selectedDateTime.toStringFormat("hh:mm:ss dd/MM/yyyy"),
        subTitleTextColor: isDark
            ? backGroundColor
            : isReadOnly
                ? Colors.grey
                : Colors.black,
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
