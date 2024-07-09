import 'dart:convert';

class Procedure {
  int? eventId;
  int? eventTypeId;
  String? eventTypeNameA;
  String? eventTypeNameE;
  int? custId;
  int? walkinId;
  String? custNameA;
  String? custNameE;
  DateTime? eventDate;
  int? representiveId;
  String? representiveNameA;
  String? representiveNameE;
  bool? isWalkIn;
  String? enteredByUser;
  String? eventDesc;
  double? eventDuration;
  String? contactPerson;
  int? contactPersonId;
  String? eventNatureNameA;
  String? eventNatureNameE;
  int? eventNatureId;
  String? addressNameA;
  String? addressNameE;
  int? addressId;
int? eventCategoryID;
  bool? isCanceled;
  bool? isClosed;
  bool? isScheduled;
  bool? isOpen;
  bool? isMeeting;
  bool? isOrdinary;

  Procedure(
      {this.eventId,
      this.eventTypeId,
      this.eventTypeNameA,
      this.eventTypeNameE,
      this.custId,
      this.walkinId,
      this.custNameA,
      this.custNameE,
      this.eventDate,
      this.representiveId,
      this.representiveNameA,
      this.representiveNameE,
      this.isWalkIn,
      this.enteredByUser,
      this.eventDesc,
      this.eventCategoryID,
      this.eventDuration,
      this.contactPerson,
      this.contactPersonId,
      this.eventNatureNameA,
      this.eventNatureNameE,
      this.eventNatureId,
      this.addressNameA,
      this.addressNameE,
      this.addressId,
      this.isCanceled,
      this.isClosed,
      this.isScheduled,
      this.isOpen,
      this.isMeeting,
      this.isOrdinary});

  factory Procedure.fromJson(Map<String, dynamic> json) => Procedure(
        eventId: json["eventID"],
        eventTypeId: json["eventTypeID"],
        eventTypeNameA: json["eventTypeNameA"],
        eventTypeNameE: json["eventTypeNameE"],
        custId: json["custID"],
        walkinId: json["walkinID"],
        isMeeting: json["isMeeting"]??false,
        custNameA: json["custNameA"],
        custNameE: json["custNameE"],
        eventDate: json["eventDate"] == null
            ? null
            : DateTime.parse(json["eventDate"]),
        representiveId: json["representiveID"],
        eventCategoryID: json["eventCategoryID"],
        representiveNameA: json["representiveNameA"],
        representiveNameE: json["representiveNameE"],
        isWalkIn: json["isWalkIn"],
        enteredByUser: json["enteredByUser"],
        eventDesc: json["eventDesc"],
        eventDuration: json["eventDuration"].toDouble(),
        contactPerson: json["contactPerson"],
        contactPersonId: json["contactPersonID"],
        eventNatureNameA: json["eventNatureNameA"],
        eventNatureNameE: json["eventNatureNameE"],
        eventNatureId: json["eventNatureID"],
        addressNameA: json["addressNameA"],
        addressNameE: json["addressNameE"],
        addressId: json["addressID"],
        isCanceled: json["isCanceled"],
        isClosed: json["isClosed"],
        isScheduled: json["isScheduled"],
        isOpen: json["isOpen"],
        isOrdinary: json["isOrdinary"],
      );

  Map<String, dynamic> toJson() => {
        "eventID": eventId,
        "eventTypeID": eventTypeId,
        "eventTypeNameA": eventTypeNameA,
        "eventTypeNameE": eventTypeNameE,
        "custID": custId,
        "walkinID": walkinId,
        "custNameA": custNameA,
        "custNameE": custNameE,
        "eventDate": eventDate?.toIso8601String(),
        "representiveID": representiveId,
        "representiveNameA": representiveNameA,
        "representiveNameE": representiveNameE,
        "isWalkIn": isWalkIn,
        "enteredByUser": enteredByUser,
        "eventDesc": eventDesc,
        "eventDuration": eventDuration,
        "contactPerson": contactPerson,
        "contactPersonID": contactPersonId,
        "eventNatureNameA": eventNatureNameA,
        "eventNatureNameE": eventNatureNameE,
        "eventNatureID": eventNatureId,
        "addressNameA": addressNameA,
        "addressNameE": addressNameE,
        "addressID": addressId,
        "isCanceled": isCanceled,
        "isClosed": isClosed,
        "isSchedule": isScheduled,
        "isOpen": isOpen,
        "isOrdinary": isOrdinary,
      };

  static List<Procedure> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<Procedure>((item) => Procedure.fromJson(item))
          .toList();
}
