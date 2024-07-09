import 'dart:convert';

import '../../../../core/services/app_translations/app_translations.dart';
import 'drop_down_obj.dart';

class Country {
  final int? id;
  final String? nameA;
  final String? nameE;
  final int? option1;

  Country({
    this.id,
    this.nameA,
    this.nameE,
    this.option1,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        nameA: json["nameA"],
        nameE: json["nameE"],
        option1: json["option1"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameA": nameA,
        "nameE": nameE,
        "option1": option1,
      };

  static List<Country> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<Country>((item) => Country.fromJson(item))
          .toList();
}

extension CountryExtension on List<Country> {
  List<DropdownObj> toDropdownObj() {
    return map(
      (e) => DropdownObj(
        name: isEnglish() ? e.nameE : e.nameA,
        id: e.id.toString(),
      ),
    ).toList();
  }
}
