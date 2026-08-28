import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String
  icon; // IconData name as string (e.g., 'favorite', 'fitness_center')
  final String colorHex; // Store color as hex string

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'colorHex': colorHex};
  }

  // Create from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  // Get Color from hex string
  Color getColor() {
    return Color(int.parse(colorHex.replaceFirst('#', '0xff')));
  }
}
