import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/theme/app_colors.dart';

import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../core/utils/app_widgets/drop_horizontal_down_button.dart';
import '../../../../../core/utils/common_widgets/custom_app_text_field.dart';
import '../../../../../core/utils/common_widgets/show_confirmation_dialog.dart';
import '../../../../../core/utils/constants/images.dart';
import '../../../data/models/procedure.dart';
import '../../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../../bottom_sheet_search/bottom_sheet_search.dart';
import '../../bottom_sheet_search/bottom_sheet_search_view_model.dart';
import '../procedure_information_view_model.dart';


class ShowEditableProcedureCard extends StatefulWidget {
  const ShowEditableProcedureCard({
    super.key,
    required this.obj,
    required this.isDark,
  });

  final Procedure? obj;
  final bool isDark;

  @override
  State<ShowEditableProcedureCard> createState() =>
      _ShowEditableProcedureCardState();
}

class _ShowEditableProcedureCardState extends State<ShowEditableProcedureCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final viewModel = ref.watch(procInfoViewModelProvider);
        final isEdit = ref.watch(viewModel.isEdit.state).state;

        return Container(
          decoration: BoxDecoration(
            color: widget.isDark ? darkCardColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(14)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    viewModel.selectDateTime(context);
                  },
                  child: customRowApp(
                    isDark: widget.isDark,
                    text: "Date and time".localized(),
                    subText: viewModel.selectedDateTime
                        .toStringFormat("hh:mm:ss dd/MM/yyyy"),
                    subTitleTextColor:
                        widget.isDark ? backGroundColor : Colors.black,
                    image: downArrow,
                    imageWidth: 9,
                  ),
                ),
                if (widget.obj?.eventId != null) ...[
                  customRowApp(
                    isDark: widget.isDark,
                    text: "Proc No".localized(),
                    subText: widget.obj?.eventId?.toString(),
                  ),
                ],
                customRowApp(
                  isDark: widget.isDark,
                  text: "User".localized(),
                  subText: widget.obj?.enteredByUser ??
                      sl<LocalUserRepo>().getLoggedUser()?.userName,
                ),
             //   maintenanceDropDown( "Repres".localized(), viewModel.,  viewModel.representativeDropDownList, (p0) { }),
                dropDownHorizontalButton(
                  isDark: widget.isDark,
                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Repres".localized(),
                  selectedItem: viewModel.selectedRepres,
                  items: viewModel.representativeDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedRepres(value);
                  },
                ),
                customRowApp(
                  isDark: widget.isDark,
                  isBold: isEdit == ProcInfoStatusTypes.addNew,
                  text: "Cust".localized(),
                  subText: isEnglish()
                      ? viewModel.selectedCust?.nameE ?? ""
                      : viewModel.selectedCust?.nameA ?? "",
                  image: viewModel.isWalkin ? bodyWalkIcon : bodyIcon,
                  imageWidth: viewModel.isWalkin ? 16 : 11,
                  onImageTap: () {
                    if (isEdit == ProcInfoStatusTypes.addNew) {
                      viewModel.isWalkinChangeValue(!viewModel.isWalkin);
                    }
                  },
                  onTap: () {
                    if (isEdit == ProcInfoStatusTypes.addNew) {
                      final isDark=ref.watch(settingsViewModelProvider).isDark;
                      final bottomSheetViewModel =
                          ref.watch(bottomSheetSearchViewModelProvider);
                      
                      bottomSheetViewModel
                          .isWalkinChangeValue(viewModel.isWalkin);

                      showModalBottomSheet(
                        
                        showDragHandle: true,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        //expand: false,
                        backgroundColor:isDark?darkModeBackGround: textFieldBgColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),

                        builder: (_) => const BottomSheetSearch(),
                      );
                    }
                  },
                ),
                dropDownHorizontalButton(
                  isDark: widget.isDark,
                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Address".localized(),
                  selectedItem: viewModel.selectedAddress,
                  items: viewModel.addressDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedAddress(value);
                  },
                  onTap: () {
                    if ((viewModel.addressDropDownList.length) < 2 &&
                        viewModel.selectedCust == null) {
                      showConfirmationDialog(
                        context: context,
                        title: 'Warning!'.localized(),
                        content: "Please select customer first".localized(),
                        barrierDismissible: false,
                        onAccept: () {
                          Navigator.of(context).pop(false);
                        },
                      );
                    }
                  },
                ),
                if (viewModel.isWalkin) ...[
                  customRowApp(
                    isDark: widget.isDark,
                    isBold: true,
                    isTextField: true,
                    text: "Contact".localized(),
                    subText: viewModel.contacValue ?? "",
                    onChanged: viewModel.contacText,
                  ),
                ] else ...[
                  dropDownHorizontalButton(
                    isDark: widget.isDark,
                    isBold: true,
                    selectedColor: Colors.black,
                    hintText: "Contact".localized(),
                    selectedItem: viewModel.selectedContact,
                    items: viewModel.contactsDropDownList,
                    didSelectItem: (value) {
                      viewModel.setSelectedContact(value);
                    },
                    onTap: () {
                      if ((viewModel.contactsDropDownList.length) < 2 &&
                          viewModel.selectedCust == null) {
                        showConfirmationDialog(
                          context: context,
                          title: 'Warning!'.localized(),
                          content: "Please select customer first".localized(),
                          barrierDismissible: false,
                          onAccept: () {
                            Navigator.of(context).pop(false);
                          },
                        );
                      }
                    },
                  ),
                ],
                dropDownHorizontalButton(
                  isDark: widget.isDark,
                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Type".localized(),
                  selectedItem: viewModel.selectedType,
                  items: viewModel.typesDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedType(value);
                  },
                ),
                dropDownHorizontalButton(
                  isDark: widget.isDark,
                  isBold: true,
                  selectedColor: Colors.black,
                  hintText: "Nature".localized(),
                  selectedItem: viewModel.selectedNature,
                  items: viewModel.natureDropDownList,
                  didSelectItem: (value) {
                    viewModel.setSelectedNature(value);
                  },
                ),
                customRowApp(
                  isDark: widget.isDark,
                  isBold: true,
                  isTextField: true,
                  keyboardType: TextInputType.number,
                  text: "Duration".localized(),
                  subText: viewModel.durationValue,
                  onChanged: viewModel.durationText,
                  maxLength: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextApp(
                      color: widget.isDark ? backGroundColor : Colors.black,
                      text: "Desc".localized(),
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    customAppTextField(
                      bgColor: widget.isDark ? darkDialogsColor : textFieldBgColor,
                      textColor: widget
                      .isDark ?backGroundColor: Colors.black,
                      isExpand: true,
                      textController: TextEditingController(
                        text: viewModel.noteValue,
                      ),
                      contentHorizontalPadding: 12,
                      fontSize: 12,
                      hintText: "".localized(),
                      onChanged: viewModel.noteText,
                      maxLength: 500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
