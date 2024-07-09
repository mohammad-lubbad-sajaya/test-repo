import 'dart:convert';

import '../../../../core/services/app_translations/app_translations.dart';
import 'drop_down_obj.dart';

class Representative {
  int? id;
  String? nameA;
  String? nameE;
  String? userId;

  Representative({
    this.id,
    this.nameA,
    this.nameE,
    this.userId,
  });

  factory Representative.fromJson(Map<String, dynamic> json) => Representative(
        id: json["id"],
        nameA: json["nameA"],
        nameE: json["nameE"],
        userId: json["userID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameA": nameA,
        "nameE": nameE,
        "userID": userId,
      };

  static List<Representative> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<Representative>((item) => Representative.fromJson(item))
          .toList();
}

extension RepresentativeExtension on List<Representative> {
  List<DropdownObj> toDropdownObj() {
    return map(
      (e) => DropdownObj(
        name: isEnglish() ? e.nameE : e.nameA,
        id: e.id.toString(),
      ),
    ).toList();
  }
}
