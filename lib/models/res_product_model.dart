import 'dart:convert';

import 'package:dic_app_flutter/models/product_model.dart';

class ResProduct {
  List<Product> products;
  int total;
  int skip;
  int limit;

  ResProduct({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ResProduct.fromRawJson(String str) =>
      ResProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResProduct.fromJson(Map<String, dynamic> json) => ResProduct(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}
