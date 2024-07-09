import 'dart:convert';

import 'user_company.dart';

class CheckUser {
  CheckUser({
    this.authKey,
    this.userId,
    this.userName,
    this.password,
    this.licenseKey,
    this.userClientID,
    this.clientID,
    this.clientSecret,
    this.resultMsg,
    this.selectedUserCompany,
  });

  String? authKey;
  String? userId;
  String? userName;
  String? password;
  String? licenseKey;
  int? userClientID;

  String? clientID;
  String? clientSecret;
  String? resultMsg;

  UserCompany? selectedUserCompany;

  factory CheckUser.fromRawJson(String str) =>
      CheckUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckUser.fromJson(Map<String, dynamic>? json) => CheckUser(
        authKey: json?["authKey"],
        userId: json?["userId"],
        userName: json?["userName"],
        password: json?["password"],
        licenseKey: json?["licenseKey"],
        userClientID: json?["userClientID"],
        clientID: json?["client_ID"],
        clientSecret: json?["client_Secret"],
        resultMsg: json?["resultMsg"],
        selectedUserCompany:
            UserCompany?.fromJson(json?["selectedUserCompany"]),
      );

  Map<String, dynamic> toJson() => {
        "authKey": authKey,
        "userId": userId,
        "userName": userName,
        "password": password,
        "licenseKey": licenseKey,
        "userClientID": userClientID,
        "client_ID": clientID,
        "client_Secret": clientSecret,
        "resultMsg": resultMsg,
        "selectedUserCompany": selectedUserCompany?.toJson(),
      };
}
