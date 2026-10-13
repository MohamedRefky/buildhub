import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final IconData icon;
  final List<String> badges;
  final Color iconColor;
  final Color iconBgColor;
  final int targetTab;

  const ServiceItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.icon,
    required this.badges,
    required this.iconColor,
    required this.iconBgColor,
    required this.targetTab,
  });
}

class ServiceCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final IconData icon;
  final List<ServiceItem> items;

  const ServiceCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.items,
  });
}
