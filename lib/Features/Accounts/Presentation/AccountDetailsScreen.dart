// Moneta Trail Account Details View Screen
// Displays Specific Account Balance, Settings, And Account-Filtered Transactions

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Accounts/Data/AccountRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';
import 'package:moneta_trail/Widgets/Shared/TransactionRow.dart';

class AccountDetailsScreen extends ConsumerWidget {
  final int accountId;

  const AccountDetailsScreen({
    super.key,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final txsAsync = ref.watch(accountTransactionsStreamProvider(accountId));
    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    final accountsAsync = ref.watch(accountsStreamProvider);

    return Scaffold(
      appBar: HeaderBar(
        title: 'Account Details',
        showBack: true,
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Account Not Found Or Has Been Deleted'),
              ),
            );
          }
          final matches = accounts.where((a) => a.id == accountId).toList();
          final acc = matches.isNotEmpty ? matches.first : accounts.first;
          final txList = txsAsync.value ?? [];

          int totalInflowCents = 0;
          int totalOutflowCents = 0;
          for (final t in txList) {
            if (t.type == 'Income' || (t.type == 'Transfer' && t.toAccountId == acc.id)) {
              totalInflowCents += t.amountCents;
            } else if (t.type == 'Expense' || (t.type == 'Transfer' && t.accountId == acc.id)) {
              totalOutflowCents += t.amountCents;
            }
          }

          final String formattedName = acc.name
              .split(' ')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
              .join(' ');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Re-imagined Sleek Account Header Hero Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF044E3B), Color(0xFF065F46), Color(0xFF0F766E), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E).withOpacity(0.4),
                        blurRadius: 20.0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Title & Account Type Badge Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    formattedName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(9999.0),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.0),
                            ),
                            child: Text(
                              acc.type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Balance Section
                      Text(
                        'CURRENT BALANCE',
                        style: AppTypography.labelCaps(
                          color: Colors.white.withOpacity(0.85),
                        ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700, fontSize: 10.5),
                      ),
                      const SizedBox(height: 2.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          CurrencyFormatter.formatCents(acc.balanceCents, currencyCode: currencyCode),
                          style: AppTypography.displayHeroMobile(color: Colors.white).copyWith(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Active Financial Asset • ${txList.length} Transactions Logged',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      Container(height: 1.0, color: Colors.white.withOpacity(0.18)),
                      const SizedBox(height: 12.0),

                      // Inflow vs Outflow Metrics Breakdown Row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34D399).withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF34D399), size: 14.0),
                                ),
                                const SizedBox(width: 6.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Inflow (Deposits)',
                                        style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.5),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          CurrencyFormatter.formatCents(totalInflowCents, currencyCode: currencyCode),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1.0, height: 26.0, color: Colors.white.withOpacity(0.18)),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF87171).withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFFF87171), size: 14.0),
                                ),
                                const SizedBox(width: 6.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Outflow (Spent)',
                                        style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.5),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          CurrencyFormatter.formatCents(totalOutflowCents, currencyCode: currencyCode),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Compact Action Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0F766E),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: () => _showDepositModal(context, ref, acc),
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 16.0),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Add Funds', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.0)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white, width: 1.2),
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: () => _showEditAccountModal(context, ref, acc),
                              icon: const Icon(Icons.edit_rounded, size: 16.0),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Edit Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                Text(
                  'Account History',
                  style: AppTypography.headlineMd(
                    color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 12.0),

                // Account Specific Transactions List
                Consumer(
                  builder: (ctx, ref, _) {
                    final categoriesAsync = ref.watch(allCategoriesFutureProvider);
                    final categoriesMap = categoriesAsync.value?.asMap().map((_, c) => MapEntry(c.id, c.name)) ?? {};
                    final categoryIconMap = categoriesAsync.value?.asMap().map((_, c) => MapEntry(c.id, c.iconName)) ?? {};

                    return txsAsync.when(
                      data: (txs) {
                        if (txs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Text(
                                'No Transactions Found For This Account',
                                style: AppTypography.bodyLg(
                                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: txs.map((t) {
                            final String catName = categoriesMap[t.categoryId] ?? (t.type == 'Transfer' ? 'Account Transfer' : (t.type == 'Income' ? 'Account Deposit' : 'Expense'));
                            final String catIcon = categoryIconMap[t.categoryId] ?? (t.type == 'Transfer' ? 'currency_exchange' : (t.type == 'Income' ? 'savings' : 'category'));
                            return TransactionRow(
                              title: catName,
                              subtitle: t.notes,
                              accountName: acc.name,
                              amountCents: t.amountCents,
                              type: t.type,
                              occurredAt: t.occurredAt,
                              iconName: catIcon,
                              currencyCode: currencyCode,
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Error Loading History: $e'),
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Failed To Load Account Details: $e')),
      ),
    );
  }

  void _showDepositModal(BuildContext context, WidgetRef ref, FinancialAccount acc) {
    final TextEditingController amountCtrl = TextEditingController();
    final TextEditingController noteCtrl = TextEditingController(text: 'Account Deposit');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Deposit Money To ${acc.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Deposit Amount (\$)'),
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
              const SizedBox(height: 14.0),
              const Text('Note / Description'),
              const SizedBox(height: 6.0),
              TextField(
                controller: noteCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. Salary / Cash Deposit',
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final double val = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              final int cents = (val * 100).round();

              if (cents <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Enter A Valid Deposit Amount')),
                );
                return;
              }

              await ref.read(accountRepositoryProvider).depositMoney(
                    accountId: acc.id,
                    amountCents: cents,
                    note: noteCtrl.text.trim(),
                  );

              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deposited \$${val.toStringAsFixed(2)} To ${acc.name}')),
                );
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }

  void _showEditAccountModal(BuildContext context, WidgetRef ref, FinancialAccount acc) {
    final TextEditingController nameCtrl = TextEditingController(text: acc.name);
    final TextEditingController balanceCtrl = TextEditingController(text: (acc.balanceCents / 100.0).toStringAsFixed(2));
    final TextEditingController subCategoryCtrl = TextEditingController(text: acc.dueDate ?? '');
    String selectedType = acc.type;
    String selectedIcon = acc.iconName;

    final List<Map<String, dynamic>> availableIcons = [
      {'key': 'account_balance', 'icon': Icons.account_balance_rounded, 'label': 'Bank'},
      {'key': 'account_balance_wallet', 'icon': Icons.account_balance_wallet_rounded, 'label': 'Wallet'},
      {'key': 'credit_card', 'icon': Icons.credit_card_rounded, 'label': 'Card'},
      {'key': 'savings', 'icon': Icons.savings_rounded, 'label': 'Savings'},
      {'key': 'payments', 'icon': Icons.payments_rounded, 'label': 'Payments'},
      {'key': 'trending_up', 'icon': Icons.trending_up_rounded, 'label': 'Investment'},
      {'key': 'currency_exchange', 'icon': Icons.currency_exchange_rounded, 'label': 'FX'},
      {'key': 'work', 'icon': Icons.work_rounded, 'label': 'Salary'},
      {'key': 'shopping_bag', 'icon': Icons.shopping_bag_rounded, 'label': 'Shopping'},
      {'key': 'attach_money', 'icon': Icons.attach_money_rounded, 'label': 'Cash'},
      {'key': 'stars', 'icon': Icons.stars_rounded, 'label': 'Vault'},
    ];

    final List<String> defaultSubCategories = [
      'Monthly',
      'Checking',
      'Savings Vault',
      'Salary Account',
      'Emergency Fund',
      'Fixed Deposit',
      'Credit Line',
      'Daily Expense',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final bool isDark = Theme.of(ctx).brightness == Brightness.dark;

          return AlertDialog(
            title: const Text('Edit Account'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Account Name', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  const Text('Account Type', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6.0),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['Bank', 'Cash', 'Card', 'Savings', 'Investment'].map((t) {
                      return DropdownMenuItem(value: t, child: Text(t));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Account Icon Picker Section
                  const Text('Select Account Icon', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 52.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableIcons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8.0),
                      itemBuilder: (ctx, idx) {
                        final item = availableIcons[idx];
                        final bool isSelected = selectedIcon == item['key'];
                        return InkWell(
                          onTap: () => setModalState(() => selectedIcon = item['key']),
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF10B981)
                                  : (isDark ? AppColors.darkSurfaceContainer : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                              size: 22.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Sub-Category / Tag Selection
                  const Text('Sub-Category / Badge Tag (e.g. Monthly)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: subCategoryCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Monthly / Checking / Emergency',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: defaultSubCategories.map((sub) {
                      return ChoiceChip(
                        label: Text(sub, style: const TextStyle(fontSize: 11.0)),
                        selected: subCategoryCtrl.text == sub,
                        onSelected: (selected) {
                          setModalState(() {
                            subCategoryCtrl.text = selected ? sub : '';
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14.0),

                  const Text('Balance Amount (\$)'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: balanceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.secondaryContainer),
                onPressed: () async {
                  await ref.read(accountRepositoryProvider).deleteAccount(acc.id);
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account Deleted Successfully')),
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
                  if (nameCtrl.text.trim().isEmpty) return;
                  final double val = double.tryParse(balanceCtrl.text.trim()) ?? 0.0;
                  final int cents = (val * 100).round();

                  await ref.read(accountRepositoryProvider).updateAccount(
                        accountId: acc.id,
                        name: nameCtrl.text.trim(),
                        type: selectedType,
                        iconName: selectedIcon,
                        dueDate: subCategoryCtrl.text.trim().isNotEmpty ? subCategoryCtrl.text.trim() : null,
                        balanceCents: cents,
                      );

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Account Details Updated Successfully')),
                    );
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }
}
