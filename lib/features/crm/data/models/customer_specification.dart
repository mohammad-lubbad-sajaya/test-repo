import 'dart:convert';

import '../../../../core/services/app_translations/app_translations.dart';
import 'drop_down_obj.dart';



class CustomerSpecification {
  final int? id;
  final String? nameA;
  final String? nameE;
  final int? filterId;
  final int? addressId;
  final bool? isWalkIn;
  final int? option1;
  final int? totalRows;

  CustomerSpecification({
    this.id,
    this.nameA,
    this.nameE,
    this.filterId,
    this.addressId,
    this.isWalkIn,
    this.option1,
    this.totalRows,
  });

  factory CustomerSpecification.fromJson(Map<String, dynamic> json) =>
      CustomerSpecification(
        id: json["id"],
        nameA: json["nameA"],
        nameE: json["nameE"],
        filterId: json["filterID"],
        addressId: json["addressID"],
        isWalkIn: json["isWalkIn"],
        option1: json["option1"],
        totalRows: json["totalRows"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameA": nameA,
        "nameE": nameE,
        "filterID": filterId,
        "addressID": addressId,
        "isWalkIn": isWalkIn,
        "option1": option1,
        "totalRows": totalRows,
      };

  static List<CustomerSpecification> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<CustomerSpecification>(
              (item) => CustomerSpecification.fromJson(item))
          .toList();
}

extension CustomerSpecificationExtension on List<CustomerSpecification> {
  List<DropdownObj> toDropdownObj() {
    return map(
      (e) => DropdownObj(
        name: isEnglish() ? e.nameE : e.nameA,
        id: e.id.toString(),
      ),
    ).toList();
  }
}
