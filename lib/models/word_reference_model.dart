import 'dart:convert';

class WordReference {
  final int id;
  final String? name; // Nullable

  WordReference({required this.id, this.name});

  factory WordReference.fromRawJson(String str) =>
      WordReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WordReference.fromJson(Map<String, dynamic> json) {
    return WordReference(
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
        name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
