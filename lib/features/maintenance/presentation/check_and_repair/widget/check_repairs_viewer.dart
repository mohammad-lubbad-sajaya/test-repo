import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../../../core/utils/app_widgets/custom_app_text.dart';
import '../../../../crm/presentation/allTabs/settings/settings_view_model.dart';
import '../view_model/check_repair_view_model.dart';

import '../../../../../core/utils/theme/app_colors.dart';
import '../check_and_repair_screen.dart';

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
              child: Card(
                color: Colors.grey[200],
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextApp(
                        color: secondaryColor,
                        size: 22,
                        fontWeight: FontWeight.bold,
                        text: _object.serviceType,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.serviceLocation,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.action,
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.startDate
                            .toStringFormat("yyyy-MM-ddTHH:mm:ss"),
                      ),
                      customTextApp(
                        color: _isDark ? backGroundColor : Colors.black,
                        size: 15,
                        fontWeight: FontWeight.w500,
                        text: _object.endDate
                            .toStringFormat("yyyy-MM-ddTHH:mm:ss"),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
