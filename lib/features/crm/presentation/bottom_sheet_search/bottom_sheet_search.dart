import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';


import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../core/utils/app_widgets/no_data_view.dart';
import '../../../../core/utils/app_widgets/search_procedures.dart';
import '../../../../core/utils/common_widgets/bottom_loader.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/customer_specification.dart';
import '../allTabs/inquiry/filter_inquiry/filter_inquiry_view_model.dart';
import '../allTabs/settings/settings_view_model.dart';
import '../procedure_information/procedure_information_view_model.dart';
import '../tab_bar/tab_bar_view_model.dart';
import 'bottom_sheet_search_view_model.dart';

class BottomSheetSearch extends StatefulWidget {
  const BottomSheetSearch({Key? key}) : super(key: key);

  @override
  State<BottomSheetSearch> createState() => _BottomSheetSearchState();
}

class _BottomSheetSearchState extends State<BottomSheetSearch> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var viewModel = context.read(bottomSheetSearchViewModelProvider);
      viewModel.context = context;
      viewModel.generateParameters();
      viewModel.getCustomerCategories(context);
      viewModel.scrollController.addListener(viewModel.scrollListener);
      //viewModel.textController.addListener(viewModel.searchTextListener);
    });
  }

  @override
  void dispose() {
    //sl<BottomSheetSearchProvider>().textController.clear();
    // sl<BottomSheetSearchProvider>().page = 0;
    // sl<BottomSheetSearchProvider>().items.clear();
    // sl.resetLazySingleton<BottomSheetSearchProvider>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer(
        builder: (context, ref, _) {
          final isDark = ref.watch(settingsViewModelProvider).isDark;

          final viewModel = ref.watch(bottomSheetSearchViewModelProvider);
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 220,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: showSearchProcedures(
                          isDark: isDark,
                          textController: viewModel.textController,
                          hintText: "Customer search".localized(),
                          horizontalPadding: 10,
                          bgColor: isDark ? darkDialogsColor : Colors.white,
                          onChanged: (value) {
                            viewModel.searchTextListener(value);
                          },
                          suffixIcon: (viewModel.textController.text.isEmpty)
                              ? null
                              : Image.asset(
                                  claerIcon,
                                  color: isDark ? backGroundColor : null,
                                ),
                          suffixIconAction: () {
                            viewModel.clearSearch();
                          },
                        ),
                      ),
                      // InkWell(
                      //   focusColor: Colors.transparent,
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   child: CircleAvatar(
                      //     maxRadius: 25,
                      //     backgroundColor: Colors.white,
                      //     child: Image.asset(
                      //       viewModel.isWalkin ? bodyWalkIcon : bodyIcon,
                      //       width: viewModel.isWalkin ? 15 : 10,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     viewModel.isWalkinChangeValue(!viewModel.isWalkin);
                      //     context
                      //         .read(procInfoViewModelProvider)
                      //         .isWalkinChangeValue(viewModel.isWalkin);
                      //     viewModel.getCustomerCategories(context);
                      //   },
                      //),
                      const SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      shrinkWrap: false,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.categoriesList.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: CategoryCell(
                            isDark: isDark,
                            obj: viewModel.categoriesList[index],
                            isSelected: viewModel.categoriesList[index].id ==
                                viewModel.selectedCategory?.id,
                          ),
                          onTap: () {
                            viewModel.changeSelectedCategory(
                              viewModel.categoriesList[index],
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 6);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: viewModel.items.isEmpty
                          ? viewModel.isLoading
                              ? bottomLoader(hasMore: true,isDark: isDark)
                              : showNoDataView(context: context)
                          : Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isDark ? darkCardColor : Colors.white,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: ListView.separated(
                                    controller: viewModel.scrollController,
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: viewModel.items.length + 1,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        color: lineColor,
                                        height: 0.5,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index < viewModel.items.length) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 11,
                                            horizontal: 22,
                                          ),
                                          child: GestureDetector(
                                            child: customTextApp(
                                              color: isDark
                                                  ? backGroundColor
                                                  : Colors.black,
                                              text: isEnglish()
                                                  ? viewModel
                                                          .items[index].nameE ??
                                                      ""
                                                  : viewModel
                                                          .items[index].nameA ??
                                                      "",
                                            ),
                                            onTap: () => {
                                              onSelectItem(
                                                viewModel.items[index],
                                              )
                                            },
                                          ),
                                        );
                                      } else {
                                        return bottomLoader(
                                          isDark: isDark,
                                          hasMore: viewModel.hasMore,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: isEnglish() ? 0 : null,
                                  left: isEnglish() ? null : 0,
                                  child: InkWell(
                                    onTap: () {
                                      viewModel.scrollTo(49);
                                    },
                                    child: SizedBox(
                                      height: 30,
                                      child: pageCountContainer(
                                        isDark: isDark,
                                        text: viewModel.getItemsCount(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  onSelectItem(CustomerSpecification item) {
    Navigator.pop(context);

    final tabBarviewModel = context.read(tabBarViewModelProvider);
    final selectedIndex = context.read(tabBarviewModel.selectedIndex.state);

    if (selectedIndex.state == 2) {
      context.read(filterInquiryViewModelProvider).setSelectedCust(item);
    } else {
      context.read(procInfoViewModelProvider).setSelectedCust(item);
    }
  }
}

Widget pageCountContainer({String? text,bool isDark=false}) => Container(
      decoration: BoxDecoration(
        color:isDark?darkCardColor: textFieldBgColor,
        borderRadius: BorderRadius.only(
          bottomLeft: isEnglish() ? const Radius.circular(10) : Radius.zero,
          bottomRight: isEnglish() ? Radius.zero : const Radius.circular(10),
        ),

        // boxShadow: shadow,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 8,
      ),
      child: Center(
        child: customTextApp(
          fontWeight: FontWeight.normal,
          text: text ?? "",
          color:isDark?backGroundColor: primaryColor,
          size: 12,
        ),
      ),
    );

class CategoryCell extends StatefulWidget {
  const CategoryCell({
    super.key,
    required this.obj,
    required this.isSelected,
    this.isDark=false
  });

  final CustomerSpecification? obj;
  final bool isSelected;
  final bool isDark;

  @override
  State<CategoryCell> createState() => _CategoryCellState();
}

class _CategoryCellState extends State<CategoryCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected ?widget.isDark?secondaryColor: primaryColor.withOpacity(0.2) :widget.isDark?darkDialogsColor: Colors.white,
        borderRadius: BorderRadius.circular(12),

        // boxShadow: shadow,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 16,
      ),
      child: Center(
        child: customTextApp(
          fontWeight: FontWeight.w500,
          text: isEnglish() ? widget.obj?.nameE ?? "" : widget.obj?.nameA ?? "",
          color:widget.isDark?backGroundColor: primaryColor,
        ),
      ),
    );
  }
}
