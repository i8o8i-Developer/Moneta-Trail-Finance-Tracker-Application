// Moneta Trail Category Spending Donut Chart Component
// Powered By fl_chart PieChart With Center Total Display And Legend

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

class CategorySpendingData {
  final String categoryName;
  final int amountCents;
  final Color color;

  CategorySpendingData({
    required this.categoryName,
    required this.amountCents,
    required this.color,
  });
}

class DonutChartWidget extends StatelessWidget {
  final List<CategorySpendingData> data;
  final int totalExpenseCents;
  final String currencyCode;

  const DonutChartWidget({
    super.key,
    required this.data,
    required this.totalExpenseCents,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (data.isEmpty || totalExpenseCents == 0) {
      return Container(
        height: 200.0,
        alignment: Alignment.center,
        child: Text(
          'No Expense Data Available For Selected Period',
          style: AppTypography.bodyLg(
            color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
          ),
        ),
      );
    }

    final String formattedTotal = CurrencyFormatter.formatCents(
      totalExpenseCents,
      currencyCode: currencyCode,
    );

    return Column(
      children: [
        SizedBox(
          height: 220.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 4.0,
                  centerSpaceRadius: 65.0,
                  sections: data.map((item) {
                    final double percentage = (item.amountCents / totalExpenseCents) * 100.0;
                    return PieChartSectionData(
                      color: item.color,
                      value: item.amountCents.toDouble(),
                      title: '${percentage.toStringAsFixed(0)}%',
                      radius: 35.0,
                      titleStyle: AppTypography.labelCaps(color: Colors.white).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.0,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Spent',
                    style: AppTypography.labelCaps(
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOutline,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    formattedTotal,
                    style: AppTypography.numericData(
                      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                    ).copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        // Chart Legend List
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          children: data.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6.0),
                Text(
                  item.categoryName,
                  style: AppTypography.bodySm(
                    color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
