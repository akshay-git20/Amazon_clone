// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Order {
  final String id;
  final List<dynamic> products;
  final num totalPrice;
  final String address;
  final num orderedAt;
  final String userId;
  final int status;
  Order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.orderedAt,
    required this.userId,
    required this.status,
  });

  Order copyWith({
    String? id,
    List<dynamic>? products,
    num? totalPrice,
    String? address,
    num? orderedAt,
    String? userId,
    int? status,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      orderedAt: orderedAt ?? this.orderedAt,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'products': products,
      'totalPrice': totalPrice,
      'address': address,
      'orderedAt': orderedAt,
      'userId': userId,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      products: List<Map<String, dynamic>>.from(
        map['products']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
      totalPrice: map['totalPrice'] as num,
      address: map['address'] as String,
      orderedAt: map['orderedAt'] as num,
      userId: map['userId'] as String,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, products: $products, totalPrice: $totalPrice, address: $address, orderedAt: $orderedAt, userId: $userId, status: $status)';
  }
}
