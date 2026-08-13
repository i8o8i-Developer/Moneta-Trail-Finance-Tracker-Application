// Moneta Trail Transaction Item Row Component
// Renders Category Icon, Transaction Title, Account Badge, Date, And Color-Coded Amount

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

import 'package:moneta_trail/Core/Utilities/CategoryIconMapper.dart';

class TransactionRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String accountName;
  final int amountCents;
  final String type; // 'Income', 'Expense', 'Transfer'
  final DateTime occurredAt;
  final String iconName;
  final String currencyCode;
  final VoidCallback? onTap;

  const TransactionRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.accountName,
    required this.amountCents,
    required this.type,
    required this.occurredAt,
    required this.iconName,
    required this.currencyCode,
    this.onTap,
  });

  Color _getVibrantIconColor(String name) {
    final List<Color> palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
      const Color(0xFFEF4444),
      const Color(0xFF14B8A6),
      const Color(0xFF6366F1),
      const Color(0xFFF97316),
    ];
    final int hash = name.codeUnits.fold<int>(0, (sum, char) => sum + char);
    return palette[hash % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isIncome = type == 'Income';
    final bool isTransfer = type == 'Transfer';

    final Color badgeColor = _getVibrantIconColor(iconName);
    final Color amountColor = isIncome
        ? AppColors.primaryContainer
        : isTransfer
            ? AppColors.tertiaryContainer
            : AppColors.secondaryContainer;

    final String amountText = CurrencyFormatter.formatCents(
      amountCents,
      currencyCode: currencyCode,
      showSign: true,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Icon Circle
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CategoryIconMapper.getIcon(iconName),
                color: badgeColor,
                size: 22.0,
              ),
            ),
            const SizedBox(width: 14.0),
            // Title & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLg(
                      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                    ).copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceHigh
                                : AppColors.lightSurfaceContainer,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            accountName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelCaps(
                              color: isDark
                                  ? AppColors.darkOnSurfaceVariant
                                  : AppColors.lightOnSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        DateFormat('MMM dd').format(occurredAt),
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkOnSurfaceVariant
                              : AppColors.lightOutline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            // Amount Text
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  amountText,
                  style: AppTypography.numericData(color: amountColor).copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
