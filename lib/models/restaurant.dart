import 'package:flutter/foundation.dart';

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String initials;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final double deliveryFee;
  final String description;

  const Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.initials,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.description,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      initials: json['initials'] as String,
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['rating_count'] as int,
      deliveryTime: json['delivery_time'] as String,
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  String get deliveryInfo =>
      '$deliveryTime - R\$ ${deliveryFee.toStringAsFixed(2).replaceAll('.', ',')}';
}
