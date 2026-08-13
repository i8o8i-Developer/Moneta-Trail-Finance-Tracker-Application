// Moneta Trail Comprehensive Category Icon Mapper
// Maps Category Icon Strings To Material Design IconData Symbols

import 'package:flutter/material.dart';

class CategoryIconMapper {
  static const Map<String, IconData> iconMap = {
    'restaurant': Icons.restaurant_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'home': Icons.home_rounded,
    'directions_car': Icons.directions_car_rounded,
    'lightbulb': Icons.lightbulb_rounded,
    'medical_services': Icons.medical_services_rounded,
    'movie': Icons.movie_rounded,
    'flight': Icons.flight_rounded,
    'school': Icons.school_rounded,
    'trending_up': Icons.trending_up_rounded,
    'attach_money': Icons.attach_money_rounded,
    'work': Icons.work_rounded,
    'card_giftcard': Icons.card_giftcard_rounded,
    'devices': Icons.devices_rounded,
    'fitness_center': Icons.fitness_center_rounded,
    'pets': Icons.pets_rounded,
    'subscriptions': Icons.subscriptions_rounded,
    'build': Icons.build_rounded,
    'receipt_long': Icons.receipt_long_rounded,
    'shield': Icons.shield_rounded,
    'spa': Icons.spa_rounded,
    'local_grocery_store': Icons.local_grocery_store_rounded,
    'fastfood': Icons.fastfood_rounded,
    'local_cafe': Icons.local_cafe_rounded,
    'local_bar': Icons.local_bar_rounded,
    'directions_bus': Icons.directions_bus_rounded,
    'flight_takeoff': Icons.flight_takeoff_rounded,
    'hotel': Icons.hotel_rounded,
    'sports_esports': Icons.sports_esports_rounded,
    'music_note': Icons.music_note_rounded,
    'child_care': Icons.child_care_rounded,
    'cleaning_services': Icons.cleaning_services_rounded,
    'content_cut': Icons.content_cut_rounded,
    'savings': Icons.savings_rounded,
    'account_balance': Icons.account_balance_rounded,
  };

  static IconData getIcon(String iconName) {
    return iconMap[iconName] ?? Icons.category_rounded;
  }

  static List<String> getAllIconNames() {
    return iconMap.keys.toList();
  }
}
