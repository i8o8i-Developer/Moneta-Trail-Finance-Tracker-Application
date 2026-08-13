// Moneta Trail Financial Account Summary Card Component
// Displays Account Name, Type Badge, Balance, Credit Limit, And Due Date

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final String type;
  final String iconName;
  final int balanceCents;
  final int? creditLimitCents;
  final String? dueDate;
  final String currencyCode;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.name,
    required this.type,
    required this.iconName,
    required this.balanceCents,
    this.creditLimitCents,
    this.dueDate,
    required this.currencyCode,
    this.onTap,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'payments':
        return Icons.payments_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'currency_exchange':
        return Icons.currency_exchange_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'attach_money':
        return Icons.attach_money_rounded;
      case 'account_tree':
        return Icons.account_tree_rounded;
      case 'stars':
        return Icons.stars_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  Color _getAccountAccentColor(String type, String iconName, String name) {
    if (type == 'Card' || iconName == 'credit_card') return const Color(0xFFEF4444);
    if (type == 'Bank' || iconName == 'account_balance') return const Color(0xFF3B82F6);
    if (type == 'Savings' || iconName == 'savings') return const Color(0xFF8B5CF6);
    if (type == 'Cash' || iconName == 'account_balance_wallet') return const Color(0xFF10B981);
    if (type == 'Investment' || iconName == 'trending_up') return const Color(0xFFF59E0B);

    final List<Color> palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
    ];
    final int hash = name.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return palette[hash % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = _getAccountAccentColor(type, iconName, name);

    final String formattedBalance = CurrencyFormatter.formatCents(
      balanceCents,
      currencyCode: currencyCode,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: accentColor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.06),
              blurRadius: 14.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: accentColor.withOpacity(0.35),
                  width: 1.0,
                ),
              ),
              child: Icon(
                _getIconData(iconName),
                color: accentColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name
                        .split(' ')
                        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                        .join(' '),
                    style: AppTypography.bodyLg(
                      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                    ).copyWith(fontWeight: FontWeight.w700, fontSize: 16.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    'Account Type: $type',
                    style: AppTypography.labelCaps(
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOutline,
                    ).copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedBalance,
                  style: AppTypography.numericData(
                    color: balanceCents < 0
                        ? const Color(0xFFEF4444)
                        : isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                  ).copyWith(fontSize: 18.0, fontWeight: FontWeight.w800),
                ),
                if (dueDate != null && dueDate!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: accentColor.withOpacity(0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.style_rounded, size: 12.0, color: accentColor),
                        const SizedBox(width: 4.0),
                        Text(
                          dueDate!,
                          style: AppTypography.labelCaps(color: accentColor).copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
