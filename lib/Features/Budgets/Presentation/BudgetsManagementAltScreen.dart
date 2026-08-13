// Moneta Trail Compact Budget Allocation Alternative Screen Component
// Presents Allocation Rows And Direct Review Transactions Link

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Budgets/Presentation/BudgetsManagementScreen.dart';

class BudgetsManagementAltScreen extends ConsumerWidget {
  const BudgetsManagementAltScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budgets (Compact View)',
          style: AppTypography.headlineMd(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
      ),
      body: const BudgetsManagementScreen(),
    );
  }
}
