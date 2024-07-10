import 'package:flutter/material.dart';

import '../../../../core/utils/app_widgets/floating_action_button.dart';
import 'view_model/check_repair_view_model.dart';
import 'widget/check_repairs_viewer.dart';
import '../../../../core/services/extentions.dart';

import '../../../crm/presentation/main_app_bar.dart';

import 'widget/add_repair_procedure_view.dart';

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
    context.read(checkAndRepairViewModel).changeEditablity(false);
    context.read(checkAndRepairViewModel).changeAction(null);
    context.read(checkAndRepairViewModel).changeAlternateItem(null);
    context.read(checkAndRepairViewModel).changeCase(null);
    context.read(checkAndRepairViewModel).changeCause(null);
    context.read(checkAndRepairViewModel).changeCorruptedItem(null);
    context.read(checkAndRepairViewModel).changeServiceLocation(null);
    context.read(checkAndRepairViewModel).changeServiceType(null);
  }
}
