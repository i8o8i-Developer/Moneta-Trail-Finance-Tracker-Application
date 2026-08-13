// Moneta Trail Inter-Account Fund Transfer Dialog Form Component
// Handles Transfers Between Accounts With Input Validation

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';

class AccountTransferDialog extends StatefulWidget {
  final List<FinancialAccount> accounts;
  final Function(int fromId, int toId, int amountCents) onConfirm;

  const AccountTransferDialog({
    super.key,
    required this.accounts,
    required this.onConfirm,
  });

  @override
  State<AccountTransferDialog> createState() => _AccountTransferDialogState();
}

class _AccountTransferDialogState extends State<AccountTransferDialog> {
  int? _fromAccountId;
  int? _toAccountId;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.accounts.length >= 2) {
      _fromAccountId = widget.accounts[0].id;
      _toAccountId = widget.accounts[1].id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      title: Text(
        'Transfer Funds Between Accounts',
        style: AppTypography.headlineMd(
          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From Account',
              style: AppTypography.labelCaps(
                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
              ),
            ),
            const SizedBox(height: 6.0),
            DropdownButtonFormField<int>(
              initialValue: _fromAccountId,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              items: widget.accounts.map((a) {
                return DropdownMenuItem<int>(
                  value: a.id,
                  child: Text(a.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => _fromAccountId = val),
            ),
            const SizedBox(height: 16.0),
            Text(
              'To Account',
              style: AppTypography.labelCaps(
                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
              ),
            ),
            const SizedBox(height: 6.0),
            DropdownButtonFormField<int>(
              initialValue: _toAccountId,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              items: widget.accounts.map((a) {
                return DropdownMenuItem<int>(
                  value: a.id,
                  child: Text(a.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => _toAccountId = val),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Transfer Amount',
              style: AppTypography.labelCaps(
                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
              ),
            ),
            const SizedBox(height: 6.0),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter Transfer Amount',
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceContainer
                    : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_fromAccountId != null &&
                _toAccountId != null &&
                _fromAccountId != _toAccountId) {
              final int cents = CurrencyFormatter.parseToCents(_amountController.text);
              if (cents > 0) {
                widget.onConfirm(_fromAccountId!, _toAccountId!, cents);
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Transfer'),
        ),
      ],
    );
  }
}
