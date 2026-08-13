// Moneta Trail Weekly Spending Breakdown Bar Chart Component
// Powered By fl_chart BarChart For Visual Budget Tracking

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class SpendingBarChartWidget extends StatelessWidget {
  final List<double> weeklySpending;

  const SpendingBarChartWidget({
    super.key,
    required this.weeklySpending,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<double> spending = weeklySpending.isEmpty
        ? [320.0, 450.0, 210.0, 580.0, 390.0, 620.0, 290.0]
        : weeklySpending;

    final double maxVal = spending.fold<double>(50.0, (max, v) => v > max ? v : max);
    final double chartMaxY = (maxVal * 1.25).clamp(50.0, 1000000.0);

    return Container(
      height: 180.0,
      padding: const EdgeInsets.only(top: 16.0, right: 12.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: chartMaxY,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final int index = value.toInt();
                  if (index >= 0 && index < days.length) {
                    return Text(
                      days[index],
                      style: AppTypography.labelCaps(
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOutline,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: spending.asMap().entries.map((entry) {
            final int index = entry.key;
            final double val = entry.value;

            final List<LinearGradient> barGradients = [
              const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFBE185D)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0E7490)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFB91C1C)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ];

            final gradient = barGradients[index % barGradients.length];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: val,
                  gradient: gradient,
                  width: 18.0,
                  borderRadius: BorderRadius.circular(8.0),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: chartMaxY,
                    color: isDark
                        ? AppColors.darkSurfaceHigh
                        : AppColors.lightSurfaceContainer,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
