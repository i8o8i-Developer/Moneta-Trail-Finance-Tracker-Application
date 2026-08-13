// Moneta Trail My Accounts Dashboard Screen Component
// Displays Total Liquid Balance Hero Card And Connected Accounts List

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Features/Accounts/Data/AccountRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/AccountCard.dart';
import 'package:moneta_trail/Widgets/Shared/AccountTransferDialog.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

class MyAccountsScreen extends ConsumerStatefulWidget {
  const MyAccountsScreen({super.key});

  @override
  ConsumerState<MyAccountsScreen> createState() => _MyAccountsScreenState();
}

class _MyAccountsScreenState extends ConsumerState<MyAccountsScreen> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);

    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    return Scaffold(
      appBar: const HeaderBar(
        title: 'My Accounts',
        showProfile: false,
      ),
      body: accountsAsync.when(
        data: (accounts) {
          final int totalNetWorthCents = accounts.fold<int>(0, (sum, a) => sum + a.balanceCents);

          int liquidAssetsCents = 0;
          int liabilitiesCents = 0;
          for (final a in accounts) {
            if (a.type == 'Card' && a.balanceCents < 0) {
              liabilitiesCents += a.balanceCents.abs();
            } else if (a.balanceCents > 0) {
              liquidAssetsCents += a.balanceCents;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Net Worth Hero Card
                Container(
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF044E3B), Color(0xFF065F46), Color(0xFF0F766E), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
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
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL NET WORTH',
                                  style: AppTypography.labelCaps(
                                    color: Colors.white.withOpacity(0.85),
                                  ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  'Active Portfolio (${accounts.length} Accounts)',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBalanceVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                              color: Colors.white,
                              size: 22.0,
                            ),
                            onPressed: () {
                              setState(() => _isBalanceVisible = !_isBalanceVisible);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _isBalanceVisible
                              ? CurrencyFormatter.formatCents(totalNetWorthCents, currencyCode: currencyCode)
                              : '••••••••',
                          style: AppTypography.displayHeroMobile(color: Colors.white).copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 34.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(height: 1.0, color: Colors.white.withOpacity(0.2)),
                      const SizedBox(height: 14.0),

                      // Assets & Liabilities Metrics Breakdown Row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34D399).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.account_balance_rounded, color: Color(0xFF34D399), size: 16.0),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Liquid Assets',
                                        style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.0),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          _isBalanceVisible
                                              ? CurrencyFormatter.formatCents(liquidAssetsCents, currencyCode: currencyCode)
                                              : '••••',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1.0, height: 28.0, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF87171).withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.credit_card_rounded, color: Color(0xFFF87171), size: 16.0),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Liabilities',
                                        style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.0),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          _isBalanceVisible
                                              ? CurrencyFormatter.formatCents(liabilitiesCents, currencyCode: currencyCode)
                                              : '••••',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.0),
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
                      const SizedBox(height: 18.0),

                      // Action Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0F766E),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                              ),
                              onPressed: () => _showDepositDialog(context, accounts),
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 18.0),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Add Money', style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AccountTransferDialog(
                                    accounts: accounts,
                                    onConfirm: (fromId, toId, amountCents) async {
                                      await ref.read(accountRepositoryProvider).transferFunds(
                                            fromAccountId: fromId,
                                            toAccountId: toId,
                                            amountCents: amountCents,
                                          );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Transfer Processed Successfully'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(Icons.swap_horiz_rounded, size: 18.0),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Transfer', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Accounts List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Accounts (${accounts.length})',
                      style: AppTypography.headlineMd(
                        color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddAccountDialog(context),
                      icon: const Icon(Icons.add_rounded, size: 18.0),
                      label: const Text('Add New'),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Account Items List
                ...accounts.map((acc) {
                  return AccountCard(
                    name: acc.name,
                    type: acc.type,
                    iconName: acc.iconName,
                    balanceCents: _isBalanceVisible ? acc.balanceCents : 0,
                    creditLimitCents: acc.creditLimitCents,
                    dueDate: acc.dueDate,
                    currencyCode: currencyCode,
                    onTap: () => context.push('/accounts/${acc.id}'),
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Failed To Load Accounts: $e')),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController balanceCtrl = TextEditingController();
    final TextEditingController subCategoryCtrl = TextEditingController();
    String selectedType = 'Bank';
    String selectedIcon = 'account_balance';

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
            title: const Text('Add New Account'),
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
                      hintText: 'e.g. Platinum Credit Card / Cash Wallet',
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
                      if (val != null) {
                        setModalState(() {
                          selectedType = val;
                          if (val == 'Card') selectedIcon = 'credit_card';
                          if (val == 'Cash') selectedIcon = 'account_balance_wallet';
                          if (val == 'Savings') selectedIcon = 'savings';
                          if (val == 'Bank') selectedIcon = 'account_balance';
                          if (val == 'Investment') selectedIcon = 'trending_up';
                        });
                      }
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

                  const Text('Initial Balance (\$)'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: balanceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. 1000.00',
                      prefixText: '\$ ',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      final String rawName = nameCtrl.text.trim();
                      if (rawName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please Enter Account Name')),
                        );
                        return;
                      }

                      final String formattedName = rawName
                          .split(' ')
                          .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                          .join(' ');

                      final double val = double.tryParse(balanceCtrl.text.trim()) ?? 0.0;
                      final int cents = (val * 100).round();

                      await ref.read(accountRepositoryProvider).createAccount(
                            name: formattedName,
                            type: selectedType,
                            iconName: selectedIcon,
                            dueDate: subCategoryCtrl.text.trim().isNotEmpty ? subCategoryCtrl.text.trim() : null,
                            balanceCents: cents,
                          );

                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('New Account Created Successfully')),
                        );
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDepositDialog(BuildContext context, List<FinancialAccount> accounts) {
    if (accounts.isEmpty) return;
    FinancialAccount selectedAccount = accounts.first;
    final TextEditingController amountCtrl = TextEditingController();
    final TextEditingController noteCtrl = TextEditingController(text: 'Account Deposit');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            title: const Text('Deposit / Add Money'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Account'),
                  const SizedBox(height: 6.0),
                  DropdownButtonFormField<FinancialAccount>(
                    value: selectedAccount,
                    items: accounts.map((a) {
                      return DropdownMenuItem(value: a, child: Text('${a.name} (${a.type})'));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedAccount = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 14.0),
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
                  const Text('Deposit Note / Description'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Paycheck / Bonus',
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
                        accountId: selectedAccount.id,
                        amountCents: cents,
                        note: noteCtrl.text.trim(),
                      );

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deposited \$${val.toStringAsFixed(2)} To ${selectedAccount.name}')),
                    );
                  }
                },
                child: const Text('Deposit Funds'),
              ),
            ],
          );
        },
      ),
    );
  }
}
