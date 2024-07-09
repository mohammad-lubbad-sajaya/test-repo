import 'dart:convert';

class FileResponse {
  String? message;
  String? imagePath;
  String? fileExtension;
  String? eventId;

  FileResponse({
    this.message,
    this.imagePath,
    this.fileExtension,
    this.eventId,
  });

  factory FileResponse.fromJson(Map<String, dynamic> json) => FileResponse(
        message: json["message"],
        imagePath: json["imagePath"],
        fileExtension: json["fileExtension"],
        eventId: json["EventId"]??""
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "imagePath": imagePath,
        "fileExtension": fileExtension,
      };

  static List<FileResponse> decode(String data) =>
      (json.decode(data) as List<dynamic>)
          .map<FileResponse>((item) => FileResponse.fromJson(item))
          .toList();
}
