import 'package:flutter/material.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/utils/app_widgets/floating_action_button.dart';
import '../../../crm/presentation/main_app_bar.dart';
import 'view_model/check_repair_view_model.dart';
import 'widget/add_repair_procedure_view.dart';
import 'widget/check_repairs_viewer.dart';

class CheckAndRepairScreen extends StatefulWidget {
  const CheckAndRepairScreen({super.key, this.isShowPrevProcedure = false});
  final bool isShowPrevProcedure;

  @override
  State<CheckAndRepairScreen> createState() => _CheckAndRepairScreenState();
}

class _CheckAndRepairScreenState extends State<CheckAndRepairScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => _onPopScreen(didPop),
      child: Scaffold(
        appBar: mainAppbar(
          context: context,
          isHideLogOut: true,
          text: "check and repair".localized(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: context
                      .read(checkAndRepairViewModel)
                      .checkRepairList
                      .where((element) =>
                          element.bondNumber ==
                          context
                              .read(checkAndRepairViewModel)
                              .currentBondNumber)
                      .isEmpty ||
                  widget.isShowPrevProcedure
              ? const AddRepairProcedureView()
              : const CheckRepairViewer(),
        ),
        floatingActionButton: context
                    .read(checkAndRepairViewModel)
                    .checkRepairList
                    .where((element) =>
                        element.bondNumber ==
                        context.read(checkAndRepairViewModel).currentBondNumber)
                    .isEmpty ||
                widget.isShowPrevProcedure
            ? Container()
            : floatingActionButton(onPressed: () {
                // sl<NavigationService>().navigateTo(checkAndRepair);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CheckAndRepairScreen(
                    isShowPrevProcedure: true,
                  ),
                ));
              }),
      ),
    );
  }

  _onPopScreen(bool didPop) {
    if(!widget.isShowPrevProcedure){
    context.read(checkAndRepairViewModel).disposeData();
    }
  }
}
