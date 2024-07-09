import 'dart:convert';

import 'package:intl/intl.dart';

class NearbyCustomers {
  final int? custId;
  final int? walkInId;
  final String? custNameA;
  final String? custNameE;
  final String? walkinNameA;
  final String? walkinNameE;
  final int? addressCount;

  final String? addressNameA;
  final String? addressNameE;
  final bool? isWalkIn;
  final int? addressID;
  final double? distance;
  final String? locationNorth;
  final String? locationEast;

  NearbyCustomers({
    this.custId,
    this.walkInId,
    this.custNameA,
    this.custNameE,
    this.walkinNameA,
    this.walkinNameE,
    this.addressCount,
    this.addressNameA,
    this.addressNameE,
    this.isWalkIn,
    this.addressID,
    this.distance,
    this.locationNorth,
    this.locationEast,
  });

  String getDistanceFromated() {
    if (distance == null) {
      return "****";
    }

    double value = distance ?? 0.0;

    // Create a NumberFormat instance for formatting with commas as thousands and hundreds separators
    NumberFormat formatter = NumberFormat('#,##0');

    formatter.format(value);

    return formatter.format(value);
  }

  static List<NearbyCustomers> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<NearbyCustomers>((item) => NearbyCustomers.fromJson(item))
          .toList();

  factory NearbyCustomers.fromJson(Map<String, dynamic> json) =>
      NearbyCustomers(
        custId: json["custID"],
        walkInId: json["walkInID"],
        custNameA: json["custNameA"],
        custNameE: json["custNameE"],
        walkinNameA: json["walkinNameA"],
        walkinNameE: json["walkinNameE"],
        addressCount: json["addressCount"],
        addressNameA: json["addressNameA"],
        addressNameE: json["addressNameE"],
        isWalkIn: json["isWalkIn"],
        addressID: json["addressID"],
        distance: json["distance"],
        locationNorth: json["locationNorth"],
        locationEast: json["locationEast"],
      );

  Map<String, dynamic> toJson() => {
        "custID": custId,
        "walkInID": walkInId,
        "custNameA": custNameA,
        "custNameE": custNameE,
        "walkinNameA": walkinNameA,
        "walkinNameE": walkinNameE,
        "addressCount": addressCount,
        "addressNameA": addressNameA,
        "addressNameE": addressNameE,
        "isWalkIn": isWalkIn,
        "addressID": addressID,
        "distance": distance,
        "locationNorth": locationNorth,
        "locationEast": locationEast,
      };
}
