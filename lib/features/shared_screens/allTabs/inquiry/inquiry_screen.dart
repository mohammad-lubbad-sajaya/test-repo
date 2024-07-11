

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/routing/navigation_service.dart';
import '../../../../core/services/routing/routes.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/app_widgets/app_title.dart';
import '../../../../core/utils/app_widgets/no_data_view.dart';
import '../../../../core/utils/common_widgets/no_connection_widget.dart';
import '../../../../core/utils/constants/images.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../tab_bar/tab_bar_screen.dart';
import '../settings/settings_view_model.dart';
import 'inquiry_view_model.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read(inquiryViewModelProvider);

      viewModel.reset();
      viewModel.context = context;

      if (viewModel.params.isEmpty) {
        viewModel.getParams();

      } else {
        viewModel.getInquirys();
      }
      viewModel.scrollController.addListener(viewModel.scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    var inquiryProvider = context.read(inquiryViewModelProvider);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: appTitle(text: inquiryProvider.title,isDark: context.read(settingsViewModelProvider).isDark),
        actions: !inquiryProvider.isGeneral
            ? [
               Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final viewModel = ref.watch(inquiryViewModelProvider);
                    return IconButton(
                      icon: Image.asset(
                        reloadIcon,
                      ),
                      onPressed: () {
                        // viewModel.getParams(isReset: true);
                        viewModel.refresh();
                      },
                    );
                  },
                ),
            ]
            : [
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return IconButton(
                      icon: Image.asset(
                        filterIcon,
                      ),
                      onPressed: () {
                        sl<NavigationService>().navigateTo(filterInquiryScreen);
                      },
                    );
                  },
                ),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final viewModel = ref.watch(inquiryViewModelProvider);
                    return IconButton(
                      icon: Image.asset(
                        reloadIcon,
                      ),
                      onPressed: () {
                        // viewModel.getParams(isReset: true);
                        viewModel.refresh();
                      },
                    );
                  },
                ),
              ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final viewModel = ref.watch(inquiryViewModelProvider);
          viewModel.context = context;

          return viewModel.items.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      if (ref.watch(connectionProvider) ==
                          ConnectivityResult.none.name) ...[
                        const NoConnectionWidget()
                      ],
                      //     const SizedBox(height: 10,),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   child: FilterTabBar(),
                      // ),
                      //                           const SizedBox(height: 10,),
                      showNoDataView(
                        context: context,
                        minHeight: 00,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ref.watch(connectionProvider) ==
                          ConnectivityResult.none.name) ...[
                        const NoConnectionWidget()
                      ],
                      // const SizedBox(height: 10,),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   child: FilterTabBar(),
                      // ),
                      //                           const SizedBox(height: 10,),

                      Expanded(
                        child: Scrollbar(
                          scrollbarOrientation: isEnglish()
                              ? ScrollbarOrientation.left
                              : ScrollbarOrientation.right,
                          child: SingleChildScrollView(
                            controller: viewModel.scrollController,
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: DataTable(
                              // source: DataTableSource(),
                              border: TableBorder.symmetric(
                                inside: const BorderSide(
                                  width: 0.5,
                                  color: Color(0xFFB1B1B1),
                                ),
                              ),
                              dataRowMaxHeight: double.infinity,
                              columnSpacing: 0,
                              headingRowHeight: 40,
                              //dividerThickness: 5,

                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) => primaryColor.withOpacity(0.9),
                              ),
                              columns: <DataColumn>[
                                DataColumn(
                                  label: SizedBox(
                                      width: width / 4,
                                      child: Center(
                                          child:
                                              Text("Procedure".localized()))),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: width / 4,
                                    child:
                                        Center(child: Text("User".localized())),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: width / 4,
                                    child: Center(
                                        child: Text("Customer".localized())),
                                  ),
                                ),
                                // Add more columns as needed
                                DataColumn(
                                  label: SizedBox(
                                    width: width / 2.5,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text("Desc".localized()),
                                    ),
                                  ),
                                )
                              ],
                              headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              dataTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              rows: viewModel.items
                                  .map(
                                    (data) => DataRow(
                                      color: MaterialStateColor.resolveWith(
                                        (states) =>
                                            viewModel.items.indexOf(data) % 2 ==
                                                    0
                                                ? textFieldBgColor
                                                : Colors.white,
                                      ),
                                      cells: [
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            width: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (data.isClosed ??
                                                        false) ...[
                                                      const SizedBox(width: 4),
                                                      Image.asset(
                                                        closedIcon,
                                                        width: 14,
                                                      ),
                                                    ],
                                                    if (data.isCanceled ??
                                                        false) ...[
                                                      const SizedBox(width: 4),
                                                      Image.asset(
                                                        canceledIcon,
                                                        width: 14,
                                                      ),
                                                    ],
                                                    if (data.isScheduled ??
                                                        false) ...[
                                                      const SizedBox(width: 4),
                                                      Image.asset(
                                                        scheduledIcon,
                                                        width: 14,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                Text(data.eventId.toString()),
                                                Text(
                                                  data.eventDate!
                                                      .toStringFormat(
                                                          "dd/MM/yyyy"),
                                                ),
                                                Text(
                                                  data.eventTypeNameA ?? "",
                                                  //maxLines: 2,
                                                ),
                                                Text(
                                                  data.eventNatureNameA ?? "",
                                                  //maxLines: 2,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataCell(Container(
                                          width: 80,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(data.enteredByUser ?? ""),
                                              Text(
                                                  data.representiveNameA ?? ""),
                                            ],
                                          ),
                                        )),
                                        DataCell(
                                          Container(
                                            width: 125,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (data.isWalkIn ??
                                                        false) ...[
                                                      Image.asset(
                                                        bodyWalkIcon,
                                                        width: 10,
                                                      ),
                                                      const SizedBox(width: 5),
                                                    ],
                                                    Expanded(
                                                      child: Text(
                                                        data.custNameA ?? "",
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(data.addressNameA ?? ""),
                                                Text(data.contactPerson ?? ""),
                                              ],
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data.eventDesc ?? ""),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
          // return Column(
          //   children: [
          //     Expanded(
          //       child: RefreshIndicator(
          //         onRefresh: allProcViewModel.refresh,
          //         child: SingleChildScrollView(
          //           physics: const AlwaysScrollableScrollPhysics(),
          //           controller: ScrollController(),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const SizedBox(height: 16),
          //               if (allProcViewModel.proceduresList.isEmpty) ...[
          //                 showNoDataView(
          //                   context: context,
          //                   minHeight: 100,
          //                 ),
          //               ] else ...[
          //                 listViewContainerBuilder(
          //                   context: context,
          //                   minHeight: 160,
          //                   itemCount:
          //                       allProcViewModel.filteredProcedures.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     return inquireCard(
          //                       obj: allProcViewModel.filteredProcedures[index],
          //                     );
          //                   },
          //                 ),
          //               ],
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
