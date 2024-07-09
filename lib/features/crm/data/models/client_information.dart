import 'dart:convert';

class ClientInformation {
  ClientInformation({
    this.clientID,
    this.authKey,
    this.clientNameA,
    this.clientNameE,
    this.connection,
  });

  int? clientID;
  String? authKey;
  String? clientNameA;
  String? clientNameE;
  String? connection;

  factory ClientInformation.fromRawJson(String str) =>
      ClientInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientInformation.fromJson(Map<String, dynamic> json) =>
      ClientInformation(
        clientID: json["clientID"],
        authKey: json["authKey"],
        clientNameA: json["clientNameA"],
        clientNameE: json["clientNameE"],
        connection: json["connection"],
      );

  Map<String, dynamic> toJson() => {
        "clientID": clientID,
        "authKey": authKey,
        "clientNameA": clientNameA,
        "clientNameE": clientNameE,
        "connection": connection,
      };
}
