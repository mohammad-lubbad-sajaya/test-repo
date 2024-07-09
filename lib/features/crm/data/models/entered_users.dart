import 'dart:convert';

import '../../../../core/services/app_translations/app_translations.dart';
import 'drop_down_obj.dart';

class EnteredUsers {
  String? enteredByUser;
  String? userNameA;
  String? userNameE;
  int? representiveId;
  String? representiveNameA;
  String? representiveNameE;
  String? adminId;

  EnteredUsers({
    this.enteredByUser,
    this.userNameA,
    this.userNameE,
    this.representiveId,
    this.representiveNameA,
    this.representiveNameE,
    this.adminId,
  });

  factory EnteredUsers.fromJson(Map<String, dynamic> json) => EnteredUsers(
        enteredByUser: json["enteredByUser"],
        userNameA: json["userNameA"],
        userNameE: json["userNameE"],
        representiveId: json["representiveID"],
        representiveNameA: json["representiveNameA"],
        representiveNameE: json["representiveNameE"],
        adminId: json["adminID"],
      );

  Map<String, dynamic> toJson() => {
        "enteredByUser": enteredByUser,
        "userNameA": userNameA,
        "userNameE": userNameE,
        "representiveID": representiveId,
        "representiveNameA": representiveNameA,
        "representiveNameE": representiveNameE,
        "adminID": adminId,
      };

  static List<EnteredUsers> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<EnteredUsers>((item) => EnteredUsers.fromJson(item))
          .toList();
}

extension EnteredUsersExtension on List<EnteredUsers> {
  List<DropdownObj> toDropdownObj() {
    return map(
      (e) => DropdownObj(
        name: isEnglish() ? e.userNameE : e.userNameA,
        id: e.enteredByUser.toString(),
      ),
    ).toList();
  }
}
