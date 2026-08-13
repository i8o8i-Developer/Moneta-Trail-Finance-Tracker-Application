// Moneta Trail Ground-Truth 5-Tab Bottom Navigation Bar
// Navigation Tabs: Records, Analysis, Budgets, Accounts, Categories

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E293B),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  index: 0,
                  icon: Icons.receipt_long_rounded,
                  label: 'Records',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 1,
                  icon: Icons.insert_chart_rounded,
                  label: 'Analysis',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 2,
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Budgets',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 3,
                  icon: Icons.account_balance_rounded,
                  label: 'Accounts',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 4,
                  icon: Icons.category_rounded,
                  label: 'Categories',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    final bool isSelected = currentIndex == index;
    final Color activeColor = const Color(0xFF10B981);
    final Color inactiveColor = const Color(0xFF64748B);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22.0,
            ),
            const SizedBox(height: 2.0),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: AppTypography.labelCaps(
                  color: isSelected ? activeColor : inactiveColor,
                ).copyWith(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
