// Moneta Trail Summary KPI Metric Stat Card Component
// Displays Key Metrics Such As Net Worth, Total Income, Expense, And Savings Rate

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(20.0),
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
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(icon, color: accentColor, size: 20.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodySm(
                    color: isDark
                        ? AppColors.darkOnSurfaceVariant
                        : AppColors.lightOutline,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            value,
            style: AppTypography.numericData(
              color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            ).copyWith(fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4.0),
            Text(
              subtitle!,
              style: AppTypography.labelCaps(
                color: accentColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
