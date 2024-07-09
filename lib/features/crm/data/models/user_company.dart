import 'dart:convert';

class UserCompany {
  int? companyID;
  String? userID;
  String? dataBaseName;
  String? companyNameA;
  String? companyNameE;
  String? briefNameA;
  String? briefNameE;

  UserCompany({
    this.companyID,
    this.userID,
    this.dataBaseName,
    this.companyNameA,
    this.companyNameE,
    this.briefNameA,
    this.briefNameE,
  });

  UserCompany.fromJson(Map<String, dynamic>? json) {
    companyID = json?['companyID'];
    userID = json?['userID'];
    dataBaseName = json?['dataBaseName'];
    companyNameA = json?['companyNameA'];
    companyNameE = json?['companyNameE'];
    briefNameA = json?['briefNameA'];
    briefNameE = json?['briefNameE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyID'] = companyID;
    data['userID'] = userID;
    data['dataBaseName'] = dataBaseName;
    data['companyNameA'] = companyNameA;
    data['companyNameE'] = companyNameE;
    data['briefNameA'] = briefNameA;
    data['briefNameE'] = briefNameE;
    return data;
  }

  static List<UserCompany> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<UserCompany>((item) => UserCompany.fromJson(item))
          .toList();
}
