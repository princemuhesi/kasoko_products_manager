import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    this.description = '',
    required this.icon,
  });
}