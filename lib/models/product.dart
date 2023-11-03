import 'dart:convert';
import 'package:amazon/models/rating.dart';
class Product {
  final String name;
  final String description;
  final num price;
  final num quantity;
  final String category;
  final List<String> images;
  final String? id;
  final List<Rating>? ratings;
  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    this.id,
    this.ratings
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'id': id,
      'ratings':ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      quantity: map['quantity'] as num,
      category: map['category'] as String,
      images: List<String>.from((map['images'])),
      id: map['_id'] as String,
      ratings:  map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
