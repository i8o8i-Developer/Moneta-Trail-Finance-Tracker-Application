// Moneta Trail Income Vs Expense Daily Cumulative Line Chart Component
// Powered By fl_chart LineChart For Financial Trend Visualization

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class DailyTrendLineChartWidget extends StatelessWidget {
  final List<double> dailyExpenses;
  final List<double> dailyIncomes;

  const DailyTrendLineChartWidget({
    super.key,
    required this.dailyExpenses,
    required this.dailyIncomes,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<FlSpot> expenseSpots = dailyExpenses.asMap().entries.map((e) {
      return FlSpot((e.key + 1).toDouble(), e.value);
    }).toList();

    final List<FlSpot> incomeSpots = dailyIncomes.asMap().entries.map((e) {
      return FlSpot((e.key + 1).toDouble(), e.value);
    }).toList();

    final double maxVal = [...dailyExpenses, ...dailyIncomes].fold<double>(100.0, (m, v) => v > m ? v : m);
    final double maxY = (maxVal * 1.2).clamp(100.0, 1000000.0);

    return Container(
      height: 220.0,
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 8.0, bottom: 8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 3,
            getDrawingHorizontalLine: (val) => FlLine(
              color: isDark ? AppColors.darkOutline.withOpacity(0.15) : AppColors.lightOutlineVariant.withOpacity(0.4),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.0,
                interval: 5,
                getTitlesWidget: (val, meta) {
                  final int day = val.toInt();
                  if (day == 1 || day == 5 || day == 10 || day == 15 || day == 20 || day == 25 || day == 30) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 6.0,
                      child: Text(
                        '$day',
                        style: AppTypography.labelCaps(
                          color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                        ).copyWith(fontSize: 11.0, fontWeight: FontWeight.w600),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: 31,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            // Expense Line Curve
            LineChartBarData(
              spots: expenseSpots.isEmpty ? const [FlSpot(1, 0)] : expenseSpots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: AppColors.secondaryContainer,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.secondaryContainer.withOpacity(0.12),
              ),
            ),
            // Income Line Curve
            LineChartBarData(
              spots: incomeSpots.isEmpty ? const [FlSpot(1, 0)] : incomeSpots,
              isCurved: true,
              preventCurveOverShooting: true,
              color: const Color(0xFF10B981),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF10B981).withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
