import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../crm/data/models/service_request.dart';

final allServicesRequestviewModel =
    ChangeNotifierProvider((ref) => AllServicesRequestsViewModel());

class AllServicesRequestsViewModel extends ChangeNotifier {
  List<ServiceRequest> servicesRequestsList = [];
  List<ServiceRequest> filteredServicesRequestsList = [];
  List<String> filters = ["طلباتي", "مواعيدي"];
  int filterIndex = 0;
  late BuildContext context;
  final textController = TextEditingController();
  void initServices() {
    servicesRequestsList = [
      ServiceRequest(
          bondNo: 655,
          clientName: "عملاء مركز الصيانة",
          address: "العبدلي",
          date: DateTime(2024, 7, 5),
          serviceStatus: "جاهز للتسليم",
          serviceType: "طلب صيانة"),
      ServiceRequest(
          bondNo: 542,
          address: "ضاحية الرشيد",
          clientName: "شركة المستقبل",
          date: DateTime(2024, 7, 10),
          serviceStatus: "غير جاهز",
          serviceType: "طلب صيانة"),
      ServiceRequest(
          bondNo: 965,
          address: "خلدا",
          clientName: "عملاء مركز الصيانة",
          date: DateTime.now(),
          serviceStatus: "به مشاكل",
          serviceType: "طلب صيانة"),
    ];
    filteredServicesRequestsList = servicesRequestsList;
  }

  void filterList(String searchText) {
    if (searchText.isEmpty) {
      filteredServicesRequestsList = servicesRequestsList;
    } else {
      // Filter the list based on the search text
      filteredServicesRequestsList = filteredServicesRequestsList
          .where((element) =>
              element.clientName.contains(textController.text) ||
              element.bondNo
                  .toString()
                  .contains(textController.text.toString()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    textController.text = "";
    filteredServicesRequestsList = servicesRequestsList;
    notifyListeners();
  }

  void changeFilterIndex(int index) {
    filterIndex = index;
    notifyListeners();
  }

  bool isSameDate(
    DateTime date1,
  ) {
    // to check if a data is today or not
    final date2 = DateTime.now();
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int getServicesRequestLength() {
    //this is to get services request  length based on the filter choosed (طلباتي و مواعيدي)

    return filterIndex == 0
        ? filteredServicesRequestsList.length
        : filteredServicesRequestsList
            .where((element) => isSameDate(element.date))
            .length;
  }

  ServiceRequest getServiceRequestObject(int index) {
    //this is to get services based on the filter choosed (طلباتي و مواعيدي)
    return filterIndex == 0
        ? filteredServicesRequestsList[index]
        : filteredServicesRequestsList
            .where((element) => isSameDate(element.date))
            .toList()[index];
  }
}
