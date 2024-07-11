
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/extentions.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../core/utils/constants/cls_crypto.dart';
import '../../../crm/data/models/check_user.dart';
import '../../../crm/data/models/procedure.dart';
import '../../../crm/domain/usecases/crm_usecases.dart';
import 'filter_inquiry/filter_inquiry_view_model.dart';

final inquiryViewModelProvider =
    ChangeNotifierProvider((ref) => InquiryViewModel());

class InquiryViewModel extends ChangeNotifier {
  late BuildContext context;
  final scrollController = ScrollController();

  int page = 1;
  int perPage = 50;
String title="Inquiry".localized();
  bool hasMore = true;
  bool isLoading = false;
  bool preventCall = false;
  bool isGeneral = false;

  Map<String, dynamic> params = {};
  List<Procedure> items = [];

  scrollListener() {
    if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 100 &&
        !scrollController.position.outOfRange) {
      if (!preventCall) {
        getInquirys();
        preventCall = true;
      }
    }
  }

  Map<String, dynamic> generateParameters() {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    Map<String, dynamic> params = {};
    // params["userID"] = user?.userId;
    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    return params;
  }
changeTitle(String name){
  title=name;
  notifyListeners();
}
  Future<List<Procedure>?> getInquirys() async {
    if (!hasMore) return [];
    LoadingAlertDialog.show(context, title: "getProcedures".localized());
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> data = generateParameters();

    data.addAll(params);

    data["PageNumber"] = page;
    data["RowsPerPage"] = perPage;

    List<Procedure>? list = await GetInquirysUseCase(sl()).call(data);

    LoadingAlertDialog.dismiss();

    items += list ?? [];
    page++;

    isLoading = false;
    preventCall = false;
    if ((list?.length ?? 0) < perPage) {
      hasMore = false;
    }

    notifyListeners();
    return list ?? [];
  }

  changeIsGeneral(bool value) {
    isGeneral = value;
    notifyListeners();
  }

  reset() {
    params = {};
    items.clear();
    page = 1;
    hasMore = true;
    preventCall = false;
  }

  Future refresh() async {
    items.clear();
    page = 1;
    hasMore = true;
    preventCall = false;
    getInquirys();
  }

  getParams({isReset = false}) {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    final filterViewModel = context.read(filterInquiryViewModelProvider);
    filterViewModel.context = context;

    // if (isReset) {
    //   filterViewModel.reset();
    //   filterViewModel.setSelectedRepresAndUserByUserName(user?.userName);
    //   params = filterViewModel.getParams();
    // } else {
    filterViewModel.getMain().then((value) => {
          filterViewModel.setSelectedRepresAndUserByUserName(user?.userName),
          params = filterViewModel.getParams(),
          getInquirys(),
        });
    // }
  }
}
