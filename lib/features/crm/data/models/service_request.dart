class ServiceRequest{
  int bondNo;
  DateTime date;
  String clientName;
  String serviceType;
  String serviceStatus;
  String address;
  double latitude;
  double longitude;

  ServiceRequest({
    required this.bondNo,
    required this.address,
    required this.clientName,
    required this.date,
    required this.serviceStatus,
    required this.serviceType,
    required this.latitude,
    required this.longitude
  });
}