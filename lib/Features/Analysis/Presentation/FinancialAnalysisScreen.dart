// Moneta Trail Financial Analysis Dashboard Screen
// Renders Category Spending Donut Chart, Expense Flow Bar Chart, And Ranking Breakdown

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/DailyTrendLineChartWidget.dart';
import 'package:moneta_trail/Widgets/Shared/DonutChartWidget.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';
import 'package:moneta_trail/Widgets/Shared/SpendingBarChartWidget.dart';

class FinancialAnalysisScreen extends ConsumerStatefulWidget {
  const FinancialAnalysisScreen({super.key});

  @override
  ConsumerState<FinancialAnalysisScreen> createState() => _FinancialAnalysisScreenState();
}

class _FinancialAnalysisScreenState extends ConsumerState<FinancialAnalysisScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    final txsAsync = ref.watch(monthlyTransactionsStreamProvider(_selectedMonth));
    final categoriesAsync = ref.watch(allCategoriesFutureProvider);

    return Scaffold(
      appBar: const HeaderBar(
        title: 'Financial Analysis',
        showProfile: true,
      ),
      body: txsAsync.when(
        data: (txs) {
          int totalExpenseCents = 0;
          int totalIncomeCents = 0;
          final Map<int, int> categoryTotals = {};

          for (final t in txs) {
            if (t.type == 'Expense') {
              totalExpenseCents += t.amountCents;
              if (t.categoryId != null) {
                categoryTotals[t.categoryId!] = (categoryTotals[t.categoryId!] ?? 0) + t.amountCents;
              }
            } else if (t.type == 'Income') {
              totalIncomeCents += t.amountCents;
            }
          }

          final categoriesList = categoriesAsync.value ?? [];
          final categoriesMap = {for (var c in categoriesList) c.id: c};

          final List<CategorySpendingData> categoriesData = [];
          final vibrantColors = [
            const Color(0xFF10B981),
            const Color(0xFF3B82F6),
            const Color(0xFF8B5CF6),
            const Color(0xFFEC4899),
            const Color(0xFFF59E0B),
            const Color(0xFF06B6D4),
            const Color(0xFFEF4444),
            const Color(0xFF14B8A6),
          ];

          int colorIdx = 0;
          categoryTotals.forEach((catId, cents) {
            final cat = categoriesMap[catId];
            Color col = vibrantColors[colorIdx % vibrantColors.length];
            if (cat?.colorHex != null && cat!.colorHex.isNotEmpty) {
              try {
                final hex = cat.colorHex.replaceAll('#', '');
                if (hex.length == 6) {
                  col = Color(int.parse('FF$hex', radix: 16));
                }
              } catch (_) {}
            }
            colorIdx++;

            categoriesData.add(
              CategorySpendingData(
                categoryName: cat?.name ?? 'Expense',
                amountCents: cents,
                color: col,
              ),
            );
          });

          final List<double> dailyExpenses = List.filled(31, 0.0);
          final List<double> dailyIncomes = List.filled(31, 0.0);
          final List<double> weeklySpending = List.filled(7, 0.0);

          for (final t in txs) {
            if (t.type == 'Expense') {
              final int wIdx = t.occurredAt.weekday - 1;
              if (wIdx >= 0 && wIdx < 7) {
                weeklySpending[wIdx] += (t.amountCents / 100.0);
              }
            }
            final int dayIdx = t.occurredAt.day - 1;
            if (dayIdx >= 0 && dayIdx < 31) {
              if (t.type == 'Expense') {
                dailyExpenses[dayIdx] += (t.amountCents / 100.0);
              } else if (t.type == 'Income') {
                dailyIncomes[dayIdx] += (t.amountCents / 100.0);
              }
            }
          }

          final int netCents = totalIncomeCents - totalExpenseCents;
          final double savingsRate = totalIncomeCents > 0
              ? ((netCents / totalIncomeCents) * 100.0).clamp(0.0, 100.0)
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Switcher Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedMonth),
                      style: AppTypography.headlineMd(
                        color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: () {
                        setState(() {
                          _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Cash Flow Summary KPIs
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
                                : [const Color(0xFFECFDF5), const Color(0xFFD1FAE5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward_rounded, color: Color(0xFF10B981), size: 14.0),
                                const SizedBox(width: 3.0),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Income',
                                      style: AppTypography.labelCaps(
                                        color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                                      ).copyWith(fontSize: 11.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                CurrencyFormatter.formatCents(totalIncomeCents, currencyCode: currencyCode),
                                style: AppTypography.bodyLg(color: const Color(0xFF10B981)).copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF7F1D1D), const Color(0xFF450A0A)]
                                : [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: AppColors.secondaryContainer.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward_rounded, color: AppColors.secondaryContainer, size: 14.0),
                                const SizedBox(width: 3.0),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Expenses',
                                      style: AppTypography.labelCaps(
                                        color: isDark ? const Color(0xFFFECACA) : const Color(0xFF991B1B),
                                      ).copyWith(fontSize: 11.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                CurrencyFormatter.formatCents(totalExpenseCents, currencyCode: currencyCode),
                                style: AppTypography.bodyLg(color: AppColors.secondaryContainer).copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF1E3A8A), const Color(0xFF172554)]
                                : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.savings_rounded, color: Color(0xFF3B82F6), size: 14.0),
                                const SizedBox(width: 3.0),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Savings',
                                      style: AppTypography.labelCaps(
                                        color: isDark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF),
                                      ).copyWith(fontSize: 11.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${savingsRate.toStringAsFixed(0)}%',
                                style: AppTypography.bodyLg(color: const Color(0xFF3B82F6)).copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Category Spending Donut Chart Card
                Container(
                  width: double.infinity,
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
                      Text(
                        'Category Breakdown',
                        style: AppTypography.headlineMd(
                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (categoriesData.isEmpty || totalExpenseCents == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              'No Expense Records Available For Selected Month',
                              style: AppTypography.bodyLg(
                                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                              ),
                            ),
                          ),
                        )
                      else
                        DonutChartWidget(
                          data: categoriesData,
                          totalExpenseCents: totalExpenseCents,
                          currencyCode: currencyCode,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Daily Cumulative Trend Line Chart Card
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
                            'Daily Trend Flow',
                            style: AppTypography.headlineMd(
                              color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              const Text('In', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 8),
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle)),
                              const SizedBox(width: 4),
                              const Text('Out', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      DailyTrendLineChartWidget(dailyExpenses: dailyExpenses, dailyIncomes: dailyIncomes),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Weekly Expense Flow Bar Chart Card
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
                      Text(
                        'Weekly Expense Flow',
                        style: AppTypography.headlineMd(
                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      SpendingBarChartWidget(weeklySpending: weeklySpending),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Top Category Ranking List
                Text(
                  'Top Categories',
                  style: AppTypography.headlineMd(
                    color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 12.0),
                if (categoriesData.isEmpty || totalExpenseCents == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'No Category Data To Display',
                        style: AppTypography.bodyLg(
                          color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                        ),
                      ),
                    ),
                  )
                else
                  ...categoriesData.map((c) {
                    final double percent = totalExpenseCents > 0 ? ((c.amountCents / totalExpenseCents) * 100.0) : 0.0;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              c.categoryName,
                              style: AppTypography.bodyLg(
                                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatCents(c.amountCents, currencyCode: currencyCode),
                            style: AppTypography.numericData(
                              color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '(${percent.toStringAsFixed(0)}%)',
                            style: AppTypography.bodySm(
                              color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error Loading Financial Data: $e')),
      ),
    );
  }
}
