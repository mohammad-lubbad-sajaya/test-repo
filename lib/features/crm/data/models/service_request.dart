class ServiceRequest{
  int bondNo;
  DateTime date;
  String clientName;
  String serviceType;
  String serviceStatus;

  ServiceRequest({
    required this.bondNo,
    required this.clientName,
    required this.date,
    required this.serviceStatus,
    required this.serviceType,
  });
}