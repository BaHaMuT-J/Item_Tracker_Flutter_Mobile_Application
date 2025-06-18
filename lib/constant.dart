import 'package:flutter/material.dart';

const brownColor = Color(0xFF7b4019);
const orangeColor = Color(0xFFFF7D29);
const weakOrangeColor = Color(0xFFFFBF78);
const creamColor = Color(0xFFFFEEA9);

class Category {
  String name;
  List<String> children;

  Category({required this.name, required this.children});
}
