class CheckRepairModel {
  int bondNumber;
  String serviceType;
  String serviceLocation;
  String cuse;
  String action;
  String cause;
  String corruptedItem;
  String alternateItem;
  String notes;
  DateTime startDate;
  DateTime endDate;

  CheckRepairModel({
    required this.action,
    required this.alternateItem,
    required this.bondNumber,
    required this.cause,
    required this.corruptedItem,
    required this.cuse,
    required this.endDate,
    required this.notes,
    required this.serviceLocation,
    required this.serviceType,
    required this.startDate,
  });
}
