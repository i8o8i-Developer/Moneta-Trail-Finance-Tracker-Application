// Moneta Trail Cash Flow Interactive Line Chart Component
// Powered By fl_chart LineChart For Net Income Vs Expense Trajectories

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class CashFlowChartWidget extends StatelessWidget {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;

  const CashFlowChartWidget({
    super.key,
    required this.incomeSpots,
    required this.expenseSpots,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 220.0,
      padding: const EdgeInsets.only(right: 16.0, top: 16.0, bottom: 8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark
                    ? AppColors.darkOutline.withOpacity(0.1)
                    : AppColors.lightOutlineVariant.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  final int index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Text(
                      months[index],
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
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Income Green Line
            LineChartBarData(
              spots: incomeSpots.isEmpty
                  ? const [
                      FlSpot(0, 3),
                      FlSpot(1, 4),
                      FlSpot(2, 3.5),
                      FlSpot(3, 5),
                      FlSpot(4, 4.5),
                      FlSpot(5, 6),
                    ]
                  : incomeSpots,
              isCurved: true,
              color: AppColors.primaryContainer,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primaryContainer.withOpacity(0.1),
              ),
            ),
            // Expense Red Line
            LineChartBarData(
              spots: expenseSpots.isEmpty
                  ? const [
                      FlSpot(0, 2),
                      FlSpot(1, 2.5),
                      FlSpot(2, 3),
                      FlSpot(3, 2.8),
                      FlSpot(4, 3.2),
                      FlSpot(5, 3.5),
                    ]
                  : expenseSpots,
              isCurved: true,
              color: AppColors.secondaryContainer,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.secondaryContainer.withOpacity(0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
