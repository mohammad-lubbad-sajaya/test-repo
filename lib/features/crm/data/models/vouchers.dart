import 'dart:convert';

class Vouchers {
  int? typeId;
  bool? isChecked;
  int? transFiscalYearId;
  int? transTypeId;
  int? transNo;
  String? transTypeName;
  String? eventID;
  DateTime? transDate;
  String? representiveName;
  String? statusName;
  double? total;
  String? note;
  double? totalBeforeTax;
  bool? isClosed;
  bool? isCanceled;
  int? newStatusId;
  int? oldStatusId;
  int? currentStatusId;
  int? representiveId;
  String? enteredByUser;

  Vouchers({
    this.typeId,
    this.isChecked,
    this.transFiscalYearId,
    this.transTypeId,
    this.transNo,
    this.transTypeName,
    this.transDate,
    this.eventID,
    this.representiveName,
    this.statusName,
    this.total,
    this.note,
    this.totalBeforeTax,
    this.isClosed,
    this.isCanceled,
    this.newStatusId,
    this.oldStatusId,
    this.currentStatusId,
    this.representiveId,
    this.enteredByUser,
  });

  factory Vouchers.fromJson(Map<String, dynamic> json) => Vouchers(
        typeId: json["typeID"],
        eventID: json["EventID"].toString(),
        isChecked: json["isChecked"],
        transFiscalYearId: json["transFiscalYearID"],
        transTypeId: json["transTypeID"],
        transNo: json["transNo"],
        transTypeName: json["transTypeName"],
        transDate: json["transDate"] == null
            ? null
            : DateTime.parse(json["transDate"]),
        representiveName: json["representiveName"],
        statusName: json["statusName"],
        total: json["total"]?.toDouble(),
        note: json["note"],
        totalBeforeTax: json["totalBeforeTax"]?.toDouble(),
        isClosed: json["isClosed"],
        isCanceled: json["isCanceled"],
        newStatusId: json["newStatusID"],
        oldStatusId: json["oldStatusID"],
        currentStatusId: json["currentStatusID"],
        representiveId: json["representiveID"],
        enteredByUser: json["enteredByUser"],
      );

  Map<String, dynamic> toJson() => {
        "typeID": typeId,
        "isChecked": isChecked,
        "transFiscalYearID": transFiscalYearId,
        "transTypeID": transTypeId,
        "transNo": transNo,
        "transTypeName": transTypeName,
        "transDate": transDate?.toIso8601String(),
        "representiveName": representiveName,
        "statusName": statusName,
        "total": total,
        "note": note,
        "totalBeforeTax": totalBeforeTax,
        "isClosed": isClosed,
        "isCanceled": isCanceled,
        "newStatusID": newStatusId,
        "oldStatusID": oldStatusId,
        "currentStatusID": currentStatusId,
        "representiveID": representiveId,
        "enteredByUser": enteredByUser,
      };

  static List<Vouchers> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<Vouchers>((item) => Vouchers.fromJson(item))
          .toList();
}
