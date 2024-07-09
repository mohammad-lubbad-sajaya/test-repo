

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/extentions.dart';
import '../../../domain/usecases/crm_usecases.dart';



import '../../../../../core/services/app_translations/app_translations.dart';
import '../../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../../core/utils/common_widgets/show_snack_bar.dart';
import '../../../../../core/utils/constants/cls_crypto.dart';
import '../../../data/models/check_user.dart';
import '../../../data/models/procedure.dart';
import '../../../data/models/vouchers.dart';
import '../../allTabs/home/home_view_model.dart';
import '../procedure_information_view_model.dart';

final vouchersViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => VouchersViewModel());

class VouchersViewModel extends ChangeNotifier {
  late BuildContext context;

  Procedure? procedureObj;
  ProcInfoStatusTypes isEdit = ProcInfoStatusTypes.show;
    List<Map<String, Object?>> _list = [];

  List<Vouchers> vouchersList = [];
  List<Vouchers> updaateVouchers = [];

  bool isLoading = false;
  bool isShowAllRepresentive = false;

  Future<List<Vouchers>> getVouchers() async {
    LoadingAlertDialog.show(context, title: "getVouchers".localized());

    Map<String, dynamic> data = {};
    data["CustID"] = procedureObj?.custId;
    data["WalkinID"] = procedureObj?.walkinId ?? 0;
    data["UserID"] = procedureObj?.enteredByUser;
    data["IsAdmin"] = context.read(homeViewModelProvider).isAdmin;
    data["EventID"] = procedureObj?.eventId;
    data["RepresentiveID"] = procedureObj?.representiveId;
    data["EventTypeID"] = procedureObj?.eventTypeId;
    data["IsFromBrowse"] = isEdit == ProcInfoStatusTypes.show ? true : false;
    data["IsShowAllRepresentive"] = isShowAllRepresentive;
    data["Lang"] = isEnglish() ? "E" : "A";

    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();
    data["userID"] = user?.userId;
    data["clientID"] = user?.userClientID;
    data["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");

    List<Vouchers>? list = await GetVouchersUseCase(sl()).call(data) ;

    vouchersList = list ?? [];
    getAllCheckedVouchers();

    LoadingAlertDialog.dismiss();
    notifyListeners();
    return list ?? [];
  }

  changeShowAllRepresentive() {
    isShowAllRepresentive = !isShowAllRepresentive;
    notifyListeners();
  }

  getAllCheckedVouchers() {
    var checkedVouchers =
        vouchersList.where((e) => e.isChecked == true).toList();

    updaateVouchers = checkedVouchers;
  }

  changeSwitchValue(bool? value, int indx) {
    vouchersList[indx].isChecked = value;

    final obj = vouchersList[indx];
    if (obj.isChecked == true) {
      removeFromVouchersList(obj);
      updaateVouchers.add(obj);
          _list = _setListMapEntiryies();

    } else {
      if (updaateVouchers.length > 1) {
        removeFromVouchersList(obj);
            _list = _setListMapEntiryies();

      }else{
        //if its the last voucher in the lest then send item with discussed data to delete it 
            _list = _setListMapEntiryies(isDeleteLastItem: true);

      }
    }

    notifyListeners();
  }

  removeFromVouchersList(Vouchers obj) {
    if (updaateVouchers.contains(obj)) {
      var index = updaateVouchers.indexOf(obj);
      updaateVouchers.removeAt(index);
    }
  }

  Future<int?> save({bool isDeleteLastItem = false}) async {

    isLoading = true;
    notifyListeners();

    // ignore: avoid_print

    int? value = await UpdateVouchersUseCase(sl()).call(_list) ;
    showSnackBar("Vouchers saved successfully".localized());
    isLoading = false;
    notifyListeners();

    return value;
  }

  List<Map<String, Object?>> _setListMapEntiryies(
      {bool isDeleteLastItem = false}) {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    if (isDeleteLastItem) {
      return updaateVouchers
          .map(
            (e) => {
              "NewStatusID": e.newStatusId,
              "OldStatusID": e.oldStatusId,
              "TransDate": DateTime.now().toIso8601String(),
              "TransFiscalYearID": DateTime.now().year,
              "TransNo": 0,
              "TransTypeID": 0,
              "TypeID": 0,
              "EventID": procedureObj?.eventId ?? 0,
              "userID": user?.userId,
              "clientID": user?.userClientID,
              "databaseName": ClsCrypto(user?.authKey ?? "")
                  .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0"),
            },
          )
          .toList();
    } else {
      return updaateVouchers
          .map(
            (e) => {
              "NewStatusID": e.newStatusId,
              "OldStatusID": e.oldStatusId,
              "TransDate": e.transDate?.toIso8601String(),
              "TransFiscalYearID": e.transFiscalYearId,
              "TransNo": e.transNo,
              "TransTypeID": e.transTypeId,
              "TypeID": e.typeId,
              "EventID": procedureObj?.eventId ?? 0,
              "userID": user?.userId,
              "clientID": user?.userClientID,
              "databaseName": ClsCrypto(user?.authKey ?? "")
                  .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0"),
            },
          )
          .toList();
    }
  }
}
