// Moneta Trail Integrated Multi-Tab Shell Screen Container
// Connects 5-Tab Navigation Bar To Indexed Screen Views

import 'package:flutter/material.dart';
import 'package:moneta_trail/Features/Accounts/Presentation/MyAccountsScreen.dart';
import 'package:moneta_trail/Features/Analysis/Presentation/FinancialAnalysisScreen.dart';
import 'package:moneta_trail/Features/Budgets/Presentation/BudgetsManagementScreen.dart';
import 'package:moneta_trail/Features/Categories/Presentation/ManageCategoriesScreen.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/BottomNavBar.dart';

class MonetaTrailSuiteScreen extends StatefulWidget {
  final int initialIndex;

  const MonetaTrailSuiteScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MonetaTrailSuiteScreen> createState() => _MonetaTrailSuiteScreenState();
}

class _MonetaTrailSuiteScreenState extends State<MonetaTrailSuiteScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    RecordsDashboardScreen(),
    FinancialAnalysisScreen(),
    BudgetsManagementScreen(),
    MyAccountsScreen(),
    ManageCategoriesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
