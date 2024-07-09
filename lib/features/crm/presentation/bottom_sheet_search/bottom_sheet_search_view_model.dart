import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/extentions.dart';
import '../../domain/usecases/crm_usecases.dart';

import '../../../../core/services/app_translations/app_translations.dart';
import '../../../../core/services/local_repo/local_user_repository.dart';
import '../../../../core/services/service_locator/dependency_injection.dart';
import '../../../../core/utils/common_widgets/loading_dialog.dart';
import '../../../../core/utils/constants/cls_crypto.dart';
import '../../data/models/check_user.dart';
import '../../data/models/customer_specification.dart';


final bottomSheetSearchViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => BottomSheetSearchViewModel());

class BottomSheetSearchViewModel with ChangeNotifier {
  final scrollController = ScrollController();
  final textController = TextEditingController();

  late BuildContext context;

  Map<String, dynamic> params = {};

  List<CustomerSpecification> categoriesList = [];
  CustomerSpecification? selectedCategory;

  bool isWalkin = false;

  int page = 1;
  int currentPage = 1;
  int perPage = 50;
  int itemHeight = 52;
  bool hasMore = true;
  bool isLoading = false;
  bool preventCall = false;

  List<CustomerSpecification> items = [];

  Timer? timer;
  String? searchText;
  scrollListener() {
    getIndex();
    if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 200 &&
        !scrollController.position.outOfRange) {
      if (!preventCall) {
        getCustomer(context);
        preventCall = true;
      }
    }
  }

  getIndex() {
    double offset = scrollController.offset + 300;

    // Calculate the current page based on the offset and itemsPerPage
    int newPage = (offset / (itemHeight * perPage)).ceil();

    if (newPage != currentPage && newPage != 0) {
      currentPage = newPage;
      notifyListeners();
    }
  }

  scrollTo(double index) {
    int indx = (perPage * (currentPage));
    scrollController.animateTo(
      itemHeight * (indx.toDouble()),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.ease,
    );
  }

  searchTextListener(String? value) {
    searchText = value;

    if (timer != null) {
      timer?.cancel();
      timer = null;
    }

    if (value?.isEmpty ?? false) {
      timer = Timer(const Duration(milliseconds: 700), refreshCustomers);
      preventCall = true;
    } else {
      timer = Timer(const Duration(milliseconds: 700), refreshCustomers);
    }
  }

  clearSearch() {
    textController.text = "";
    searchText = "";
    refreshCustomers();
    notifyListeners();
  }

  String getItemsCount() {
    double totalPages = ((items.first.totalRows ?? 0) / perPage);
    return "$currentPage / ${totalPages.ceil()}";
  }

  generateParameters() {
    CheckUser? user = sl<LocalUserRepo>().getLoggedUser();

    params["userID"] = user?.userId;
    params["clientID"] = user?.userClientID;
    params["databaseName"] = ClsCrypto(user?.authKey ?? "")
        .encrypt(user?.selectedUserCompany?.dataBaseName ?? "0");
  }

  Map<String, dynamic> getUserInfoParameters() {
    Map<String, dynamic> data = {};
    data["userID"] = params["userID"];
    data["clientID"] = params["clientID"];
    data["databaseName"] = params["databaseName"];
    return data;
  }

  Future<List<CustomerSpecification>> getCustomerCategories(
      BuildContext context) async {
    LoadingAlertDialog.show(context,
        title: "Get Customer Categories".localized());

    List<CustomerSpecification>? list = [];
    if (isWalkin) {
      list = await GetWalkInCategoriesUseCase(sl()).call(getUserInfoParameters());
    } else {
      list = await GetCustomerCategoriesUseCase(sl()).call(getUserInfoParameters());
    }

    LoadingAlertDialog.dismiss();

    selectedCategory = list?.first;
    categoriesList = list ?? [];

    refreshCustomers();
    return list ?? [];
  }

  Future<List<CustomerSpecification>> getCustomer(BuildContext context) async {
    if (!hasMore) return [];
    //LoadingAlertDialog.show(context);
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> data = getUserInfoParameters();
    data["PropertyTable"] = isWalkin ? "W" : "C"; // "WE"
    data["PageNumber"] = page;
    data["RowsPerPage"] = perPage;

    data["FilterCustName"] = searchText ?? ""; // Customer Name A/E

    data["FilterCategoryID"] =
        selectedCategory?.id == 0 ? -1 : selectedCategory?.id;
    data["Lang"] = isEnglish() ? "E" : "A"; // "A" or "E"

    List<CustomerSpecification>? list =
        await  GetCustomersPageUseCase(sl()).call(data);

    //LoadingAlertDialog.dismiss();

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

  isWalkinChangeValue(bool value) {
    isWalkin = value;
    notifyListeners();
  }

  changeSelectedCategory(CustomerSpecification value) {
    selectedCategory = value;

    refreshCustomers();
    notifyListeners();
  }

  refreshCustomers() {
    items.clear();
    page = 1;
    currentPage = 1;
    hasMore = true;
    preventCall = false;
    getCustomer(context);
  }
}
