import 'package:flutter/material.dart';

const brownColor = Color(0xFF7b4019);
const orangeColor = Color(0xFFFF7D29);
const weakOrangeColor = Color(0xFFFFBF78);
const creamColor = Color(0xFFFFEEA9);

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem({required this.name, required this.icon});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint,
    };
  }

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}

class Category {
  String name;
  List<CategoryItem> children;

  Category({required this.name, required this.children});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'children': children.map((item) => item.toJson()).toList(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      children: (json['children'] as List)
          .map((item) => CategoryItem.fromJson(item))
          .toList(),
    );
  }
}
