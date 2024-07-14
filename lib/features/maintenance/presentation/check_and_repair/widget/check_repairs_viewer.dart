import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/app_widgets/check_repairs_proc_card.dart';
import '../../../../shared_screens/allTabs/settings/settings_view_model.dart';
import '../check_and_repair_screen.dart';
import '../view_model/check_repair_view_model.dart';

class CheckRepairViewer extends StatelessWidget {
  const CheckRepairViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _viewModel = ref.watch(checkAndRepairViewModel);
      final _isDark = ref.watch(settingsViewModelProvider).isDark;
      return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
          itemCount: _viewModel.checkRepairList
              .where((element) =>
                  element.bondNumber == _viewModel.currentBondNumber)
              .length,
          itemBuilder: (context, index) {
            final _object = _viewModel.checkRepairList
                .where((element) =>
                    element.bondNumber == _viewModel.currentBondNumber)
                .toList()[index];
            return InkWell(
              onTap: () {
                _viewModel.changeAction(_viewModel.actionList.first);
                _viewModel
                    .changeAlternateItem(_viewModel.alternateItemList.first);
                _viewModel.changeCase(_viewModel.caseList.first);
                _viewModel.changeCause(_viewModel.causeList.first);
                _viewModel
                    .changeCorruptedItem(_viewModel.corruptedItemList.first);
                _viewModel
                    .changeServiceLocation(_viewModel.serviceLocations.first);
                _viewModel.changeServiceType(_viewModel.serviceTypes.first);
                _viewModel.changeEditablity(true);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CheckAndRepairScreen(
                    isShowPrevProcedure: true,
                  ),
                ));
              },
              child: buildCheckRepairProcedureCard(_object, _isDark),
            );
          });
    });
  }

 
}
