import 'dart:convert';

class MediaFile {
  int mediaId;
  String fileType;
  String filePath;
  String? fileName; // Nullable
  String? description; // Nullable

  MediaFile({
    required this.mediaId,
    required this.fileType,
    required this.filePath,
    this.fileName, // Nullable
    this.description, // Nullable
  });

  factory MediaFile.fromRawJson(String str) =>
      MediaFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaFile.fromJson(Map<String, dynamic> json) => MediaFile(
        // mediaId: json["media_id"],
        mediaId: json['media_id'] is String
            ? int.parse(json['media_id'])
            : json['media_id'], // Convert if necessary
        fileType: json["file_type"],
        filePath: json["file_path"],
        fileName: json["file_name"] as String? ?? '', // Cast to nullable String
        description:
            json["description"] as String? ?? '', // Cast to nullable String
      );

  Map<String, dynamic> toJson() => {
        "media_id": mediaId,
        "file_type": fileType,
        "file_path": filePath,
        "file_name": fileName,
        "description": description,
      };
}
