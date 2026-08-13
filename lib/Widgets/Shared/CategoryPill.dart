// Moneta Trail Category Filter Chip And Badge Pill Component
// Renders Active/Inactive States With Category Icon Anchor

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class CategoryPill extends StatelessWidget {
  final String label;
  final String? iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.label,
    this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String? name) {
    switch (name) {
      case 'home':
        return Icons.home_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'local_grocery_store':
        return Icons.local_grocery_store_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'movie':
        return Icons.movie_rounded;
      case 'lightbulb':
        return Icons.lightbulb_rounded;
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'subscriptions':
        return Icons.subscriptions_rounded;
      case 'pets':
        return Icons.pets_rounded;
      case 'attach_money':
        return Icons.attach_money_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      case 'phone_android':
        return Icons.phone_android_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isSelected
        ? (isDark ? AppColors.primaryFixedDim : AppColors.primaryContainer)
        : (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer);

    final Color textColor = isSelected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9999.0),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? AppColors.darkOutline.withOpacity(0.3)
                      : AppColors.lightOutlineVariant.withOpacity(0.5),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconName != null && iconName!.isNotEmpty) ...[
              Icon(
                _getCategoryIcon(iconName),
                size: 16.0,
                color: textColor,
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              label,
              style: AppTypography.bodySm(color: textColor).copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
