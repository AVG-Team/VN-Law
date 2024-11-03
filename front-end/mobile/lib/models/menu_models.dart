import 'package:flutter/material.dart';

class MenuSection {
  final String? title;
  final List<MenuItem> items;

  MenuSection({
    this.title,
    required this.items,
  });
}

class MenuItem {
  final Widget? icon;
  final String title;
  final String? subtitle;
  final String? time;
  final VoidCallback? onTap;
  final Widget? menuItems; // Thêm thuộc tính này

  MenuItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.time,
    this.onTap,
    this.menuItems,
  });
}

