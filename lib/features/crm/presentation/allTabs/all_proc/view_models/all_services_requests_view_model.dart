import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/service_request.dart';

final allServicesRequestviewModel =
    ChangeNotifierProvider((ref) => AllServicesRequestsViewModel());

class AllServicesRequestsViewModel extends ChangeNotifier {
  List<ServiceRequest> servicesRequestsList = [];
  List<ServiceRequest> filteredServicesRequestsList = [];
  late BuildContext context;
  final textController = TextEditingController();

  initServices() {
    servicesRequestsList = [
      ServiceRequest(
          bondNo: 655,
          clientName: "عملاء مركز الصيانة",
          address: "العبدلي",
          date: DateTime.now(),
          serviceStatus: "جاهز للتسليم",
          serviceType: "طلب صيانة"),
      ServiceRequest(
          bondNo: 542,
          address: "ضاحية الرشيد",
          clientName: "شركة المستقبل",
          date: DateTime.now(),
          serviceStatus: "جاهز للتسليم",
          serviceType: "طلب صيانة"),
      ServiceRequest(
          bondNo: 965,
          address: "خلدا",
          clientName: "عملاء مركز الصيانة",
          date: DateTime.now(),
          serviceStatus: "جاهز للتسليم",
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

  clearSearch() {
    textController.text = "";
    filteredServicesRequestsList = servicesRequestsList;
    notifyListeners();
  }
}
