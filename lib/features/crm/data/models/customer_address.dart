import 'dart:convert';

class CustomerAddress {
  late int? addressID;
  late String? addressNameA;
  late String? addressNameE;
  late int? countryID;
  late int? cityID;
  late int? areaID;
  late int? taxTypeID;
  late String? locationNorth;
  late String? locationEast;

  CustomerAddress({
    this.addressID,
    this.addressNameA,
    this.addressNameE,
    this.countryID,
    this.cityID,
    this.areaID,
    this.taxTypeID,
    this.locationNorth,
    this.locationEast,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      addressID: json['addressID'],
      addressNameA: json['addressNameA'],
      addressNameE: json['addressNameE'],
      countryID: json['countryID'],
      cityID: json['cityID'],
      areaID: json['areaID'],
      taxTypeID: json['taxTypeID'],
      locationNorth: json['locationNorth'],
      locationEast: json['locationEast'],
    );
  }

  static List<CustomerAddress> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<CustomerAddress>((item) => CustomerAddress.fromJson(item))
          .toList();
}
