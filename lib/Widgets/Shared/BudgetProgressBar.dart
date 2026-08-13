// Moneta Trail Budget Progress Bar Component
// Renders Progress Percentage, Limit Vs Spent, And Threshold Color Indicators

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CategoryIconMapper.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

class BudgetProgressBar extends StatelessWidget {
  final String categoryName;
  final String iconName;
  final int spentCents;
  final int limitCents;
  final String currencyCode;

  const BudgetProgressBar({
    super.key,
    required this.categoryName,
    required this.iconName,
    required this.spentCents,
    required this.limitCents,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double ratio = limitCents > 0 ? (spentCents / limitCents).clamp(0.0, 1.5) : 0.0;
    final double percentage = (ratio * 100).clamp(0.0, 999.0);

    // Determine Threshold Color
    Color progressColor = AppColors.primaryContainer;
    if (ratio >= 1.0) {
      progressColor = AppColors.secondaryContainer; // Over Budget (Red)
    } else if (ratio >= 0.8) {
      progressColor = const Color(0xFFF59E0B); // Warning (Amber)
    }

    final String spentText = CurrencyFormatter.formatCents(spentCents, currencyCode: currencyCode);
    final String limitText = CurrencyFormatter.formatCents(limitCents, currencyCode: currencyCode);

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark
              ? AppColors.darkOutline.withOpacity(0.2)
              : AppColors.lightOutlineVariant.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CategoryIconMapper.getIcon(iconName),
                  color: progressColor,
                  size: 18.0,
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                categoryName
                    .split(' ')
                    .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                    .join(' '),
                style: AppTypography.bodyLg(
                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (ratio >= 1.0) ...[
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.secondaryContainer,
                  size: 18.0,
                ),
                const SizedBox(width: 4.0),
              ],
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTypography.numericData(color: progressColor).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Progress Bar Track
          ClipRRect(
            borderRadius: BorderRadius.circular(9999.0),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 10.0,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceHigh
                  : AppColors.lightSurfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: $spentText',
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.lightOnSurfaceVariant,
                ),
              ),
              Text(
                'Limit: $limitText',
                style: AppTypography.bodySm(
                  color: isDark
                      ? AppColors.darkOnSurfaceVariant
                      : AppColors.lightOutline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
