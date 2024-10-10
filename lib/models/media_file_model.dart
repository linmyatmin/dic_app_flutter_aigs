import 'dart:convert';

class MediaFile {
  String mediaId;
  String fileType;
  String filePath;
  String fileName;
  String description;

  MediaFile({
    required this.mediaId,
    required this.fileType,
    required this.filePath,
    required this.fileName,
    required this.description,
  });

  factory MediaFile.fromRawJson(String str) =>
      MediaFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        mediaId: json["media_id"],
        fileType: json["file_type"],
        filePath: json["file_path"],
        fileName: json["file_name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "media_id": mediaId,
        "file_type": fileType,
        "file_path": filePath,
        "file_name": fileName,
        "description": description,
      };
}
