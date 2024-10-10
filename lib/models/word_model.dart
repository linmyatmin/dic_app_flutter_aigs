import 'dart:convert';
import 'package:dic_app_flutter/models/media_file_model.dart';

class Word {
  String id; // Changed to String to match API response
  String? nameEn;
  String? despEn;
  String? nameCn;
  String? despCn;
  String? nameTh;
  String? despTh;
  List<MediaFile>? mediaFiles;

  Word({
    required this.id,
    this.nameEn,
    this.despEn,
    this.nameCn,
    this.despCn,
    this.nameTh,
    this.despTh,
    this.mediaFiles,
  });

  factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'].toString(), // Ensure id is handled as a String
      nameEn: json['name_en'],
      despEn: json['desp_en'],
      nameCn: json['name_cn'],
      despCn: json['desp_cn'],
      nameTh: json['name_th'],
      despTh: json['desp_th'],
      mediaFiles: json["media_files"] != null
          ? List<MediaFile>.from(
              json["media_files"].map((x) => MediaFile.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_en': nameEn,
        'desp_en': despEn,
        'name_cn': nameCn,
        'desp_cn': despCn,
        'name_th': nameTh,
        'desp_th': despTh,
        "media_files": mediaFiles != null
            ? List<dynamic>.from(mediaFiles!.map((x) => x.toJson()))
            : null,
      };
}
