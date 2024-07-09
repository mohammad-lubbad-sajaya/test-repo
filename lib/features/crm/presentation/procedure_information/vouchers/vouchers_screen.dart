import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/app_widgets/no_data_view.dart';

import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../../core/utils/app_widgets/list_view_container_builder.dart';
import '../../../../../core/utils/app_widgets/save_and_cancel_buttons.dart';
import '../../../../../core/utils/app_widgets/voucher_card.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../allTabs/settings/settings_view_model.dart';
import '../procedure_information_view_model.dart';
import 'vouchers_view_model.dart';


class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read(vouchersViewModelProvider).getVouchers();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customTextApp(
          color: context.read(settingsViewModelProvider).isDark?backGroundColor:Colors.black ,
          text: "Linked Vouchers".localized(),
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Consumer(builder: (context, ref, _) {
            final viewModel = ref.watch(vouchersViewModelProvider);
            return IconButton(
              icon: const Icon(Icons.group),
              color: viewModel.isShowAllRepresentive
                  ? secondaryColor
                  : placeHolderColor,
              onPressed: () {
                viewModel.changeShowAllRepresentive();
                viewModel.getVouchers();
              },
            );
          }),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final viewModel = ref.watch(vouchersViewModelProvider);
          final isDark=ref.watch(settingsViewModelProvider).isDark;
          //final obj = ref.watch(viewModel.procedureObj);
          //final isEdit = ref.watch(viewModel.isEdit);

          return viewModel.vouchersList.isEmpty
              ? showNoDataView(context: context, minHeight: 0)
              : Column(
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
                              decoration:  BoxDecoration(
                                color:isDark?darkCardColor : backGroundColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(32),
                                ),
                              ),
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height - 110,
                              ),
                              child: listViewContainerBuilder(
                                context: context,
                                minHeight: 300,
                                itemCount: viewModel.vouchersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return voucherCard(
                                    isDark: isDark,
                                    isEdit: viewModel.isEdit !=
                                        ProcInfoStatusTypes.show,
                                    obj: viewModel.vouchersList[index],
                                    onSwitchChanged: (value) {
                                      viewModel.changeSwitchValue(value, index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (viewModel.isEdit != ProcInfoStatusTypes.show) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: saveAndCancelButtons(
                          context,
                          viewModel.isLoading,
                          onSave: () {
                            viewModel.save().then((value) => {
                              
                                  Navigator.of(context).pop(false),
                                });
                          },
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ]
                  ],
                );
        },
      ),
    );
  }
}
