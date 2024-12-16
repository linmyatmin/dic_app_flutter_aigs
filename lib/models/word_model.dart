import 'dart:convert';
import 'package:dic_app_flutter/models/media_file_model.dart';

class Word {
  final int id;
  final String? nameEn; // Nullable
  final String? despEn; // Nullable
  final String? nameCn; // Nullable
  final String? despCn; // Nullable
  final String? nameTh; // Nullable
  final String? despTh; // Nullable
  final String? despFr; // Nullable
  final String? despSp; // Nullable
  final String? despJp; // Nullable
  final String? section; // Nullable
  final String? pureNameEn; // Nullable
  final List<MediaFile>? mediaFiles;

  Word({
    required this.id,
    this.nameEn,
    this.despEn,
    this.nameCn,
    this.despCn,
    this.nameTh,
    this.despTh,
    this.despFr,
    this.despSp,
    this.despJp,
    this.section,
    this.pureNameEn,
    this.mediaFiles,
  });

  factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      // id: json['id'] as int,
      id: json['id'] is String
          ? int.parse(json['id'])
          : json['id'], // Convert if necessary
      // nameEn: json['name_en'],
      // despEn: json['desp_en'],
      // nameCn: json['name_cn'],
      // despCn: json['desp_cn'],
      // nameTh: json['name_th'],
      // despTh: json['desp_th'],
      // despFr: json['desp_fr'],
      // despSp: json['desp_sp'],
      // despJp: json['desp_jp'],
      nameEn: json['nameEn'],
      despEn: json['despEn'],
      nameCn: json['nameCn'],
      despCn: json['despCn'],
      nameTh: json['nameTh'],
      despTh: json['despTh'],
      despFr: json['despFr'],
      despSp: json['despSp'],
      despJp: json['despJp'],
      section: json['section'],
      pureNameEn: json['pureNameEn'],
      mediaFiles: json["mediaFiles"] != null
          ? List<MediaFile>.from(
              json["mediaFiles"].map((x) => MediaFile.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'despEn': despEn,
        'nameCn': nameCn,
        'despCn': despCn,
        'nameTh': nameTh,
        'despTh': despTh,
        'despFr': despFr,
        'despSp': despSp,
        'despJp': despJp,
        // 'name_en': nameEn,
        // 'desp_en': despEn,
        // 'name_cn': nameCn,
        // 'desp_cn': despCn,
        // 'name_th': nameTh,
        // 'desp_th': despTh,
        // 'desp_fr': despFr,
        // 'desp_sp': despSp,
        // 'desp_jp': despJp,
        'section': section,
        'pureNameEn': pureNameEn,
        "mediaFiles": mediaFiles != null
            ? List<dynamic>.from(mediaFiles!.map((x) => x.toJson()))
            : null,
      };
}
