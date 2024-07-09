import 'dart:convert';

class EventCount {
  String? eventDate;
  int? eventCount;

  EventCount({
    this.eventDate,
    this.eventCount,
  });

  factory EventCount.fromJson(Map<String, dynamic> json) => EventCount(
        eventDate: json["eventDate"],
        eventCount: json["eventCount"],
      );

  Map<String, dynamic> toJson() => {
        "eventDate": eventDate,
        "eventCount": eventCount,
      };

  static List<EventCount> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<EventCount>((item) => EventCount.fromJson(item))
          .toList();
}
