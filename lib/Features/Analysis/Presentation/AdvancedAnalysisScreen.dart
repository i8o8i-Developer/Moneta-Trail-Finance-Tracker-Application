// Moneta Trail Advanced Financial Analysis Dashboard Screen
// In-Depth Wealth Trajectory Forecast, Cash Flow Line Charts, And Savings Rates

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/CashFlowChartWidget.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

class AdvancedAnalysisScreen extends ConsumerStatefulWidget {
  const AdvancedAnalysisScreen({super.key});

  @override
  ConsumerState<AdvancedAnalysisScreen> createState() => _AdvancedAnalysisScreenState();
}

class _AdvancedAnalysisScreenState extends ConsumerState<AdvancedAnalysisScreen> {
  String _selectedRange = '6M';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    return Scaffold(
      appBar: const HeaderBar(
        title: 'Advanced Analysis',
        showProfile: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wealth Trajectory Header Card
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wealth Trajectory',
                        style: AppTypography.headlineMd(
                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                        ),
                      ),
                      // Horizon Filter Toggle
                      Row(
                        children: ['6M', '1Y', 'ALL'].map((range) {
                          final bool isSel = _selectedRange == range;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRange = range),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              margin: const EdgeInsets.only(left: 4.0),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryContainer : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                range,
                                style: AppTypography.labelCaps(
                                  color: isSel ? Colors.white : AppColors.lightOutline,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const CashFlowChartWidget(
                    incomeSpots: [
                      FlSpot(0, 3.5),
                      FlSpot(1, 4.2),
                      FlSpot(2, 4.0),
                      FlSpot(3, 5.1),
                      FlSpot(4, 4.8),
                      FlSpot(5, 6.2),
                    ],
                    expenseSpots: [
                      FlSpot(0, 2.1),
                      FlSpot(1, 2.8),
                      FlSpot(2, 2.4),
                      FlSpot(3, 2.9),
                      FlSpot(4, 3.1),
                      FlSpot(5, 3.3),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Savings Rate KPI Card
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Savings Rate',
                          style: AppTypography.labelCaps(color: AppColors.primaryContainer),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          '46.8%',
                          style: AppTypography.displayHeroMobile(color: AppColors.primaryContainer),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '+4.2% Vs Last Month',
                          style: AppTypography.bodySm(color: AppColors.primaryContainer),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avg Monthly Surplus',
                          style: AppTypography.labelCaps(
                            color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          CurrencyFormatter.formatCents(179000, currencyCode: currencyCode),
                          style: AppTypography.headlineMd(
                            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Based On 6M Average',
                          style: AppTypography.bodySm(
                            color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
