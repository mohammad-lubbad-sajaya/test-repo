import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../crm/data/models/service_request.dart';

final allServicesRequestviewModel =
    ChangeNotifierProvider((ref) => AllServicesRequestsViewModel());

class AllServicesRequestsViewModel extends ChangeNotifier {
  List<ServiceRequest> servicesRequestsList = [];
  List<ServiceRequest> filteredServicesRequestsList = [];
  late BuildContext context;
  final textController = TextEditingController();
  List<String> statuses = ['الكل', 'جاهز للتسليم', 'غير جاهز', 'به مشاكل'];
  Set<String> selectedStatuses = {'الكل'};
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

  void Function(bool)? onSelected(String status, bool selected) {
    if (status == 'الكل') {
      selectedStatuses.clear();
      selectedStatuses.add('الكل');
      filteredServicesRequestsList = servicesRequestsList;
    } else {
      selectedStatuses.remove('الكل');
      if (selected) {
        selectedStatuses.add(status);
        _filterStatus();
      } else {
        selectedStatuses.remove(status);
        _filterStatus();
      }
      if (selectedStatuses.isEmpty) {
        selectedStatuses.add('الكل');
        filteredServicesRequestsList = servicesRequestsList;
      }
    }

    notifyListeners();
    return null;
  }

  clearSearch() {
    textController.text = "";
    filteredServicesRequestsList = servicesRequestsList;
    notifyListeners();
  }

  void _filterStatus() {
    filteredServicesRequestsList = [];
    for (var element in selectedStatuses) {
      filteredServicesRequestsList.add(
          servicesRequestsList.firstWhere((e) => e.serviceStatus == element));
    }
  }
}
