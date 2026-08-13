// Moneta Trail Category Selector Bottom Sheet Modal
// Grid View Display Of Available Expense/Income Categories

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

import 'package:moneta_trail/Core/Utilities/CategoryIconMapper.dart';

class CategorySelectorModal extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<Category> onSelect;

  const CategorySelectorModal({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxHeight: 400.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: AppTypography.headlineMd(
              color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (ctx, index) {
                final cat = categories[index];
                final bool isSelected = cat.id == selectedCategoryId;

                final List<Color> vibrantColors = [
                  const Color(0xFF3B82F6),
                  const Color(0xFF10B981),
                  const Color(0xFFF59E0B),
                  const Color(0xFF8B5CF6),
                  const Color(0xFFEC4899),
                  const Color(0xFF06B6D4),
                  const Color(0xFFEF4444),
                  const Color(0xFF14B8A6),
                  const Color(0xFF6366F1),
                  const Color(0xFFF97316),
                ];

                Color catColor = vibrantColors[index % vibrantColors.length];
                if (cat.colorHex.isNotEmpty) {
                  try {
                    final hex = cat.colorHex.replaceAll('#', '');
                    if (hex.length == 6) {
                      catColor = Color(int.parse('FF$hex', radix: 16));
                    }
                  } catch (_) {}
                }

                return InkWell(
                  onTap: () {
                    onSelect(cat);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isSelected ? catColor : catColor.withOpacity(0.3),
                        width: isSelected ? 2.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CategoryIconMapper.getIcon(cat.iconName),
                            color: catColor,
                            size: 22.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          cat.name,
                          style: AppTypography.bodySm(
                            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                          ).copyWith(fontSize: 12.0, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
