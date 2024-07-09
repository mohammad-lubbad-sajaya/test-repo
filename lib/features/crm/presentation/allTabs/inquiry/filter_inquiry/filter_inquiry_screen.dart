import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../../../core/services/extentions.dart';

import '../../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../../core/utils/app_widgets/custom_row_app.dart';
import '../../../../../../core/utils/app_widgets/drop_horizontal_down_button.dart';
import '../../../../../../core/utils/constants/images.dart';
import '../../../../../../core/utils/theme/app_colors.dart';
import '../../../../data/models/drop_down_obj.dart';
import '../../../bottom_sheet_search/bottom_sheet_search.dart';
import '../../../bottom_sheet_search/bottom_sheet_search_view_model.dart';
import '../../settings/settings_view_model.dart';
import '../inquiry_view_model.dart';
import 'filter_inquiry_view_model.dart';

class FilterInquiry extends StatefulWidget {
  const FilterInquiry({super.key});

  @override
  State<FilterInquiry> createState() => _FilterInquiryState();
}

class _FilterInquiryState extends State<FilterInquiry> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final viewModel = context.read(filterInquiryViewModelProvider);

        viewModel.context = context;
        //viewModel.restPeriod();
        //viewModel.reset();
        // viewModel.resetCustomerFilters();
        // viewModel.selectedDateTime = obj?.eventDate ?? DateTime.now();
        viewModel.getMain();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextApp(
            text: "Filter Settings".localized(),
            fontWeight: FontWeight.w500,
            color: context.read(settingsViewModelProvider).isDark
                ? backGroundColor
                : Colors.black),
        actions: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final viewModel = ref.watch(filterInquiryViewModelProvider);
              return IconButton(
                icon: Image.asset(
                  restButton,
                ),
                onPressed: () {
                  viewModel.reset();
                  viewModel.getMain();
                },
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final viewModel = ref.watch(filterInquiryViewModelProvider);
          final isDark = ref.watch(settingsViewModelProvider).isDark;
          // final obj = ref.watch(viewModel.procedureObj);
          // final isEdit = ref.watch(viewModel.isEdit);

          return PopScope(
            onPopInvoked: (pop) async {
              final inquiryVM = ref.watch(inquiryViewModelProvider);
              inquiryVM.params = viewModel.getParams();
              inquiryVM.context = context;
              inquiryVM.refresh();
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
                                isDark ? darkModeBackGround : textFieldBgColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32),
                            ),
                          ),
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 110,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                sectionTitle(
                                  title: "User".localized(),
                                  isDark: isDark,
                                ),
                                bodySection(
                                  isDark: isDark,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        dropDownHorizontalButton(
                                          isDark: isDark,
                                          selectedColor: Colors.black,
                                          backgroundColor: isDark
                                              ? Colors.grey
                                              : Colors.white,
                                          hideSeparator: true,
                                          hintText: "User".localized(),
                                          selectedItem: viewModel
                                              .selectedEnteredUser
                                              ?.toLowerCase(),
                                          items: viewModel
                                              .enteredUsersDropDownList,
                                          didSelectItem: (value) {
                                            viewModel.setSelectedUser(value);
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        dropDownHorizontalButton(
                                          isDark: isDark,
                                          backgroundColor: isDark
                                              ? Colors.grey
                                              : Colors.white,
                                          selectedColor: Colors.black,
                                          hintText: "Repres".localized(),
                                          selectedItem: viewModel.selectedRepres
                                              ?.toLowerCase(),
                                          items: viewModel
                                              .representativeDropDownList,
                                          didSelectItem: (value) {
                                            viewModel.setSelectedRepres(value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                sectionTitle(
                                    title: "Dates".localized(), isDark: isDark),
                                bodySection(
                                  isDark: isDark,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        dropDownHorizontalButton(
                                          isDark: isDark,
                                          //isBold: true,
                                          backgroundColor: isDark
                                              ? Colors.grey
                                              : Colors.white,
                                          selectedColor: Colors.black,
                                          hintText: "Period".localized(),
                                          selectedItem:
                                              viewModel.selectedPeriod,
                                          items: viewModel.periodList,
                                          didSelectItem: (value) {
                                            viewModel.setSelectedPeriod(value);
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            viewModel.selectFromDate(context);
                                          },
                                          child: customRowApp(
                                            isDark: isDark,
                                            text: "From".localized(),
                                            subText: viewModel.selectedFromDate
                                                .toStringFormat("dd/MM/yyyy"),
                                            subTitleTextColor: isDark
                                                ? backGroundColor
                                                : Colors.black,
                                            image: downArrow,
                                            imageWidth: 9,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            viewModel.selectToDate(context);
                                          },
                                          child: customRowApp(
                                            isDark: isDark,
                                            text: "To".localized(),
                                            subText: viewModel.selectedToDate
                                                .toStringFormat("dd/MM/yyyy"),
                                            subTitleTextColor: isDark
                                                ? backGroundColor
                                                : Colors.black,
                                            image: downArrow,
                                            imageWidth: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                sectionTitle(
                                    title: "Procedures".localized(),
                                    isDark: isDark),
                                bodySection(
                                  isDark: isDark,
                                  children: [
                                    switchBox(
                                      isDark: isDark,
                                      image: openIcon,
                                      imageWidth: 25,
                                      title: "Open".localized(),
                                      value: viewModel.isOpen,
                                      onChanged: (value) {
                                        viewModel.changeIsOpenValue(value);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    switchBox(
                                      isDark: isDark,
                                      image: closedIcon,
                                      imageWidth: 20,
                                      title: "Closed".localized(),
                                      value: viewModel.isClosed,
                                      onChanged: (value) {
                                        viewModel.changeIsClosedValue(value);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    switchBox(
                                      isDark: isDark,
                                      image: canceledIcon,
                                      imageWidth: 20,
                                      title: "Canceled".localized(),
                                      value: viewModel.isCanceled,
                                      onChanged: (value) {
                                        viewModel.changeIsCanceledValue(value);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    switchBox(
                                      isDark: isDark,
                                      image: scheduledIcon,
                                      imageWidth: 23,
                                      title: "Scheduled".localized(),
                                      value: viewModel.isScheduled,
                                      onChanged: (value) {
                                        viewModel.changeIsScheduledValue(value);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    multiSelectBox(
                                      isDark: isDark,
                                      items: viewModel.allTypesList,
                                      initialValue: viewModel.typesList,
                                      title: "Type".localized(),
                                      onConfirm: (values) {
                                        viewModel.setSelectedTypeList(values);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    multiSelectBox(
                                      isDark: isDark,
                                      items: viewModel.allNatureList,
                                      initialValue: viewModel.natureList,
                                      title: "Nature".localized(),
                                      onConfirm: (values) {
                                        viewModel.setSelectedNaturList(values);
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                sectionTitle(
                                  title: "Customers".localized(),
                                  isDark: isDark,
                                ),
                                bodySection(
                                  isDark: isDark,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        openSearchCustomerBottomSheet(
                                            ref, false);
                                        viewModel.isOrdinary = true;
                                        viewModel.isWalkin = false;
                                      },
                                      child: switchBox(
                                        isDark: isDark,
                                        image: bodyIcon,
                                        imageWidth: 10,
                                        title: "Ordinary".localized(),
                                        value: viewModel.isOrdinary,
                                        onChanged: (value) {
                                          viewModel
                                              .changeIsOrdinaryValue(value);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {
                                        openSearchCustomerBottomSheet(
                                            ref, true);
                                        viewModel.isOrdinary = false;
                                        viewModel.isWalkin = true;
                                      },
                                      child: switchBox(
                                        isDark: isDark,
                                        image: bodyWalkIcon,
                                        imageWidth: 14,
                                        title: "Walkin".localized(),
                                        value: viewModel.isWalkin,
                                        onChanged: (value) {
                                          viewModel.changeIsWalkinValue(value);
                                        },
                                      ),
                                    ),
                                    customRowApp(
                                      isDark: isDark,
                                      text: "${"Cust".localized()} :",
                                      subText: isEnglish()
                                          ? viewModel.selectedCust?.nameE ?? ""
                                          : viewModel.selectedCust?.nameA ?? "",
                                    ),
                                  ],
                                ),
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
    );
  }

  openSearchCustomerBottomSheet(WidgetRef ref, bool isWalkin) {
    final bottomSheetViewModel = ref.watch(bottomSheetSearchViewModelProvider);
    final isDark = ref.watch(settingsViewModelProvider).isDark;
    bottomSheetViewModel.isWalkinChangeValue(isWalkin);

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      //expand: false,
      backgroundColor: isDark ? darkCardColor : textFieldBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (_) => const BottomSheetSearch(),
    );
  }
}

sectionTitle({
  String title = "",
  bool isDark = false,
}) =>
    Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? darkSectionNameClr : primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: customTextApp(
                color: Colors.white,
                text: title,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );

bodySection({List<Widget> children = const <Widget>[], bool isDark = false}) =>
    Container(
      decoration: BoxDecoration(
        color: isDark ? darkCardColor : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );

switchBox({
  String title = "",
  String image = "",
  bool isDark = false,
  double? imageWidth,
  required bool value,
  required void Function(bool)? onChanged,
}) =>
    Row(
      children: [
        Image.asset(
          image,
          width: imageWidth,
        ),
        const SizedBox(width: 10),
        customTextApp(
            text: title, color: isDark ? backGroundColor : Colors.black),
        const Spacer(),
        Switch(
          inactiveTrackColor: Colors.grey[100],
          activeColor: secondaryColor,
          onChanged: onChanged,
          value: value,
        ),
      ],
    );

multiSelectBox({
  required String title,
  required bool isDark,
  required List<DropdownObj> items,
  required List<Object?> initialValue,
  required Function(List<Object?>) onConfirm,
}) =>
    Container(
      decoration: BoxDecoration(
        color: isDark ? darkCardColor : textFieldBgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: MultiSelectBottomSheetField(
        confirmText: Text("OK".localized()),
        cancelText: Text("Cancel".localized()),
        searchHint: "Search".localized(),
        items: items
            .map((e) => MultiSelectItem<DropdownObj>(e, e.name ?? ""))
            .toList(),
        initialValue: initialValue,
        initialChildSize: 0.4,
        listType: MultiSelectListType.LIST,
        searchable: true,
        searchHintStyle:
            TextStyle(color: isDark ? backGroundColor : Colors.black),
        searchTextStyle:
            TextStyle(color: isDark ? backGroundColor : Colors.black),
        closeSearchIcon: Icon(
          Icons.close,
          color: isDark ? backGroundColor : Colors.black,
        ),
        searchIcon: Icon(
          Icons.search,
          color: isDark ? backGroundColor : Colors.black,
        ),
        backgroundColor: isDark ? darkCardColor : textFieldBgColor,
        unselectedColor: secondaryColor.withOpacity(0.6),
        selectedColor: secondaryColor.withOpacity(0.9),
        barrierColor: primaryColor.withOpacity(0.1),
        buttonText: Text(
          title,
          style: TextStyle(
            color: isDark ? backGroundColor : Colors.black,
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        title: customTextApp(
          text: title,
          color: isDark ? backGroundColor : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        itemsTextStyle: TextStyle(
          color: isDark ? backGroundColor : Colors.black,
          fontSize: 14,
        ),
        selectedItemsTextStyle: TextStyle(
          color: isDark ? backGroundColor : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        buttonIcon: Icon(
          Icons.expand_more,
          color: isDark ? backGroundColor : Colors.black,
          size: 20,
        ),
        onConfirm: onConfirm,
        chipDisplay: MultiSelectChipDisplay(
          scroll: true,
          chipColor: secondaryColor.withOpacity(0.1),
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          onTap: (value) {},
        ),
      ),
    );
