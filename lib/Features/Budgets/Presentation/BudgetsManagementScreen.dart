// Moneta Trail Category Budgets Management Dashboard Screen
// Renders Total Monthly Budget Health Ring, Category Progress Bars, And Unbudgeted Chips

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Features/Budgets/Data/BudgetRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/BudgetProgressBar.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

class BudgetsManagementScreen extends ConsumerStatefulWidget {
  const BudgetsManagementScreen({super.key});

  @override
  ConsumerState<BudgetsManagementScreen> createState() => _BudgetsManagementScreenState();
}

class _BudgetsManagementScreenState extends ConsumerState<BudgetsManagementScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    return Scaffold(
      appBar: const HeaderBar(
        title: 'Budgets Management',
        showProfile: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector Header
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
            const SizedBox(height: 16.0),

            // Overall Monthly Category Spending Health Card
            Consumer(
              builder: (ctx, ref, _) {
                final String monthKey = "${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}";
                final txsAsync = ref.watch(monthlyTransactionsStreamProvider(_selectedMonth));
                final categoriesAsync = ref.watch(allCategoriesFutureProvider);
                final budgetsAsync = ref.watch(monthlyBudgetsStreamProvider(monthKey));

                return txsAsync.when(
                  data: (txs) {
                    int totalExpensesCents = 0;
                    final Map<int, int> categorySpendingMap = {};

                    for (final t in txs) {
                      if (t.type == 'Expense') {
                        totalExpensesCents += t.amountCents;
                        if (t.categoryId != null) {
                          categorySpendingMap[t.categoryId!] = (categorySpendingMap[t.categoryId!] ?? 0) + t.amountCents;
                        }
                      }
                    }

                    final budgets = budgetsAsync.value ?? [];
                    final Map<int, Budget> budgetMap = {for (var b in budgets) b.categoryId: b};
                    final int totalBudgetLimitCents = budgets.fold<int>(0, (sum, b) => sum + b.limitAmountCents);

                    final categories = categoriesAsync.value?.where((c) => c.type == 'Expense').toList() ?? [];

                    String healthStatus = 'On Track';
                    Color healthColor = AppColors.primaryContainer;
                    if (totalBudgetLimitCents > 0) {
                      final double ratio = totalExpensesCents / totalBudgetLimitCents;
                      if (ratio >= 1.0) {
                        healthStatus = 'Over Budget';
                        healthColor = AppColors.secondaryContainer;
                      } else if (ratio >= 0.8) {
                        healthStatus = 'Warning';
                        healthColor = const Color(0xFFF59E0B);
                      }
                    }

                    // Total Monthly Budget Card (Matching Screenshot 3 Spec)
                    final double spentPercent = totalBudgetLimitCents > 0
                        ? ((totalExpensesCents / totalBudgetLimitCents) * 100.0).clamp(0.0, 100.0)
                        : 0.0;
                    final double progressRatio = totalBudgetLimitCents > 0
                        ? (totalExpensesCents / totalBudgetLimitCents).clamp(0.0, 1.0)
                        : 0.0;
                    final int remainingCents = (totalBudgetLimitCents - totalExpensesCents).clamp(0, 999999999);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22.0),
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
                                'Total Monthly Budget',
                                style: AppTypography.headlineMd(
                                  color: isDark ? AppColors.darkOnSurface : const Color(0xFF0F172A),
                                ).copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'You Have Spent ${spentPercent.toStringAsFixed(0)}% Of Your Limit.',
                                style: AppTypography.bodySm(
                                  color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SPENT',
                                        style: AppTypography.labelCaps(
                                          color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF64748B),
                                        ).copyWith(fontSize: 10.0, letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        CurrencyFormatter.formatCents(totalExpensesCents, currencyCode: currencyCode),
                                        style: AppTypography.displayHeroMobile(
                                          color: isDark ? AppColors.darkOnSurface : const Color(0xFF0F172A),
                                        ).copyWith(fontSize: 26.0, fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'LIMIT',
                                        style: AppTypography.labelCaps(
                                          color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF64748B),
                                        ).copyWith(fontSize: 10.0, letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        CurrencyFormatter.formatCents(totalBudgetLimitCents, currencyCode: currencyCode),
                                        style: AppTypography.bodyLg(
                                          color: isDark ? AppColors.darkOnSurface : const Color(0xFF0F172A),
                                        ).copyWith(fontSize: 17.0, fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14.0),

                              // Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9999.0),
                                child: LinearProgressIndicator(
                                  value: progressRatio,
                                  minHeight: 10.0,
                                  backgroundColor: isDark
                                      ? AppColors.darkSurfaceHigh
                                      : const Color(0xFFE2E8F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Progress Bottom Labels
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$0',
                                    style: AppTypography.bodySm(
                                      color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  Text(
                                    'Remaining: ${CurrencyFormatter.formatCents(remainingCents, currencyCode: currencyCode)}',
                                    style: AppTypography.bodySm(color: const Color(0xFF10B981)).copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Health Section Card (Matching Screenshot 3 Spec)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22.0),
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
                                'Health',
                                style: AppTypography.headlineMd(
                                  color: isDark ? AppColors.darkOnSurface : const Color(0xFF0F172A),
                                ).copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 130.0,
                                      height: 130.0,
                                      child: CircularProgressIndicator(
                                        value: progressRatio > 0 ? progressRatio : 0.05,
                                        strokeWidth: 12.0,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor: isDark
                                            ? AppColors.darkSurfaceHigh
                                            : const Color(0xFFE2E8F0),
                                        valueColor: AlwaysStoppedAnimation<Color>(healthColor),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          progressRatio > 0.9 ? Icons.warning_amber_rounded : Icons.thumb_up_rounded,
                                          color: healthColor,
                                          size: 28.0,
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          healthStatus,
                                          style: AppTypography.headlineMd(
                                            color: isDark ? AppColors.darkOnSurface : const Color(0xFF0F172A),
                                          ).copyWith(fontSize: 16.0, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: Text(
                                  progressRatio < 0.85
                                      ? 'Pacing Well For This Month.'
                                      : 'High Budget Utilization Warning.',
                                  style: AppTypography.bodySm(
                                    color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        // Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Category Allowances',
                                style: AppTypography.headlineMd(
                                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                                ).copyWith(fontSize: 18.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            TextButton.icon(
                              onPressed: () => _showSetBudgetModal(context, categories, null, monthKey),
                              icon: const Icon(Icons.add_rounded, size: 18.0),
                              label: const Text('Set Budget'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),

                        if (categories.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(
                              child: Text(
                                'No Expense Categories Found',
                                style: AppTypography.bodyLg(
                                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                                ),
                              ),
                            ),
                          )
                        else
                          ...categories.map((cat) {
                            final int spentCents = categorySpendingMap[cat.id] ?? 0;
                            final Budget? existingBudget = budgetMap[cat.id];
                            final int limitCents = existingBudget?.limitAmountCents ?? 0;

                            if (spentCents == 0 && existingBudget == null) {
                              return const SizedBox.shrink();
                            }

                            return GestureDetector(
                              onTap: () => _showSetBudgetModal(context, categories, cat, monthKey, existingBudget: existingBudget),
                              child: BudgetProgressBar(
                                categoryName: cat.name,
                                iconName: cat.iconName,
                                spentCents: spentCents,
                                limitCents: limitCents > 0 ? limitCents : spentCents,
                                currencyCode: currencyCode,
                              ),
                            );
                          }),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error Loading Category Data: $e'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSetBudgetModal(
    BuildContext context,
    List<Category> categories,
    Category? initialCategory,
    String monthKey, {
    Budget? existingBudget,
  }) {
    Category? selectedCategory = initialCategory ?? (categories.isNotEmpty ? categories.first : null);
    final TextEditingController amountCtrl = TextEditingController(
      text: existingBudget != null ? (existingBudget.limitAmountCents / 100.0).toStringAsFixed(2) : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            title: Text(existingBudget != null ? 'Edit Category Budget' : 'Set Category Budget'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Category:'),
                  const SizedBox(height: 6.0),
                  DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    items: categories.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() => selectedCategory = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Monthly Limit Amount (\$)'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. 500.00',
                      prefixText: '\$ ',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (existingBudget != null)
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColors.secondaryContainer),
                  onPressed: () async {
                    await ref.read(budgetRepositoryProvider).deleteBudget(existingBudget.id);
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Budget Deleted Successfully')),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCategory == null) return;
                  final double val = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                  final int cents = (val * 100).round();

                  if (cents <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please Enter A Valid Limit Amount')),
                    );
                    return;
                  }

                  await ref.read(budgetRepositoryProvider).setBudget(
                        categoryId: selectedCategory!.id,
                        month: monthKey,
                        limitAmountCents: cents,
                      );

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Category Budget Set Successfully')),
                    );
                  }
                },
                child: const Text('Save Budget'),
              ),
            ],
          );
        },
      ),
    );
  }
}

final monthlyBudgetsStreamProvider = StreamProvider.family<List<Budget>, String>((ref, month) {
  return ref.watch(budgetRepositoryProvider).watchMonthlyBudgets(month);
});
