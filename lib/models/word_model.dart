import 'dart:convert';

class Word {
  String id;
  String nameEn;
  String despEn;
  String nameCn;
  String despCn;
  String nameTh;
  String despTh;

  Word({
    required this.id,
    required this.nameEn,
    required this.despEn,
    required this.nameCn,
    required this.despCn,
    required this.nameTh,
    required this.despTh,
  });

  factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json["id"],
        nameEn: json["name_en"],
        despEn: json["desp_en"],
        nameCn: json["name_cn"],
        despCn: json["desp_cn"],
        nameTh: json["name_th"],
        despTh: json["desp_th"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "desp_en": despEn,
        "name_cn": nameCn,
        "desp_cn": despCn,
        "name_th": nameTh,
        "desp_th": despTh,
      };
}


// class Word {
//   String id;
//   String nameEn;
//   String despEn;
//   String nameCn;
//   String despCn;
//   String nameTh;
//   String despTh;

//   Word({
//     required this.id,
//     required this.nameEn,
//     required this.despEn,
//     required this.nameCn,
//     required this.despCn,
//     required this.nameTh,
//     required this.despTh,
//   });

//   factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Word.fromJson(Map<String, dynamic> json) => Word(
//         id: json["id"],
//         nameEn: json["name_en"],
//         despEn: json["desp_en"],
//         nameCn: json["name_cn"],
//         despCn: json["desp_cn"],
//         nameTh: json["name_th"],
//         despTh: json["desp_th"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name_en": nameEn,
//         "desp_en": despEn,
//         "name_cn": nameCn,
//         "desp_cn": despCn,
//         "name_th": nameTh,
//         "desp_th": despTh,
//       };
// }
