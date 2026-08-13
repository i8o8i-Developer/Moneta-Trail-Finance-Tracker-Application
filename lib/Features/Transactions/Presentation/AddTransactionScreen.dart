// Moneta Trail Add New Transaction Keypad Screen Component
// Income/Expense/Transfer Segmented Tabs, Amount Display, Keypad, Category & Account Selectors

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/CalculatorKeypad.dart';
import 'package:moneta_trail/Widgets/Shared/CategorySelectorModal.dart';
import 'package:moneta_trail/Widgets/Shared/ModalDrawer.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  String _type = 'Expense';
  String _amountInput = '0';
  bool _isKeypadOpen = false;
  int? _selectedAccountId;
  int? _selectedToAccountId;
  Category? _selectedCategory;
  DateTime _occurredAt = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  Future<void> _submitTransaction(BuildContext context) async {
    final int cents = CurrencyFormatter.parseToCents(_amountInput);
    if (cents <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please Enter A Valid Amount')),
      );
      return;
    }
    if (_selectedAccountId == null) return;

    await ref.read(recordsRepositoryProvider).createTransaction(
          accountId: _selectedAccountId!,
          toAccountId: _type == 'Transfer' ? _selectedToAccountId : null,
          categoryId: _type != 'Transfer' ? _selectedCategory?.id : null,
          type: _type,
          amountCents: cents,
          notes: _notesController.text.trim(),
          occurredAt: _occurredAt,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Saved Successfully')),
      );
      context.pop();
    }
  }

  void _onKeyTap(String value) {
    setState(() {
      if (_amountInput == '0' && value != '.') {
        _amountInput = value;
      } else {
        _amountInput += value;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountInput.length > 1) {
        _amountInput = _amountInput.substring(0, _amountInput.length - 1);
      } else {
        _amountInput = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final categoriesAsync = ref.watch(allCategoriesFutureProvider);

    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;
    final String currencySymbol = AppTokens.currencySymbols[currencyCode] ?? '\$';

    // Auto-select first account & category if available
    final accounts = accountsAsync.value ?? [];
    if (_selectedAccountId == null && accounts.isNotEmpty) {
      _selectedAccountId = accounts.first.id;
    }
    if (_selectedToAccountId == null && accounts.length >= 2) {
      _selectedToAccountId = accounts[1].id;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Transaction',
          style: AppTypography.headlineMd(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _submitTransaction(context),
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Segmented Tabs (Income / Expense / Transfer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceContainer : const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(9999.0),
              ),
              child: Row(
                children: ['Income', 'Expense', 'Transfer'].map((t) {
                  final bool isSelected = _type == t;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.primaryFixedDim : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9999.0),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          t,
                          style: AppTypography.bodySm(
                            color: isSelected
                                ? (isDark ? Colors.black : const Color(0xFF0F172A))
                                : (isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF64748B)),
                          ).copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Main Hero Amount & Grid Form Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => setState(() => _isKeypadOpen = !_isKeypadOpen),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: _isKeypadOpen
                            ? (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: _isKeypadOpen ? const Color(0xFF10B981) : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tap to Enter Amount',
                                style: AppTypography.labelCaps(
                                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                                ).copyWith(letterSpacing: 1.2),
                              ),
                              const SizedBox(width: 6.0),
                              Icon(
                                _isKeypadOpen ? Icons.keyboard_hide_rounded : Icons.calculate_rounded,
                                size: 18.0,
                                color: const Color(0xFF10B981),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$currencySymbol$_amountInput',
                              style: AppTypography.displayHero(
                                color: _type == 'Expense'
                                    ? AppColors.secondaryContainer
                                    : const Color(0xFF10B981),
                              ).copyWith(fontSize: 36.0, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Account & Category Large Card Grid (Matching Screenshot 2 Spec)
                  Row(
                    children: [
                      // Select Account Card Button
                      Expanded(
                        child: PopupMenuButton<int>(
                          initialValue: _selectedAccountId,
                          onSelected: (id) => setState(() => _selectedAccountId = id),
                          itemBuilder: (ctx) => accounts.map((a) {
                            return PopupMenuItem<int>(
                              value: a.id,
                              child: Text(a.name),
                            );
                          }).toList(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 52.0,
                                  height: 52.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.account_balance_rounded,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  accounts.isEmpty
                                      ? 'Select Account'
                                      : (accounts.where((a) => a.id == _selectedAccountId).isNotEmpty
                                          ? accounts.firstWhere((a) => a.id == _selectedAccountId).name
                                          : accounts.first.name),
                                  style: AppTypography.bodySm(
                                    color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14.0),

                      // Select Category Card Button OR To Account Card Button
                      Expanded(
                        child: _type == 'Transfer'
                            ? PopupMenuButton<int>(
                                initialValue: _selectedToAccountId,
                                onSelected: (id) => setState(() => _selectedToAccountId = id),
                                itemBuilder: (ctx) => accounts.map((a) {
                                  return PopupMenuItem<int>(
                                    value: a.id,
                                    child: Text(a.name),
                                  );
                                }).toList(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 52.0,
                                        height: 52.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF3B82F6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.swap_horiz_rounded,
                                          color: Colors.white,
                                          size: 26.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        accounts.isEmpty
                                            ? 'Select Account'
                                            : (accounts.where((a) => a.id == _selectedToAccountId).isNotEmpty
                                                ? accounts.firstWhere((a) => a.id == _selectedToAccountId).name
                                                : accounts.last.name),
                                        style: AppTypography.bodySm(
                                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                                        ).copyWith(fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  final catList = categoriesAsync.value ?? [];
                                  ModalDrawer.show(
                                    context: context,
                                    child: CategorySelectorModal(
                                      categories: catList.where((c) => c.type == _type).toList(),
                                      selectedCategoryId: _selectedCategory?.id,
                                      onSelect: (cat) => setState(() => _selectedCategory = cat),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10.0,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 52.0,
                                        height: 52.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.category_rounded,
                                          color: Colors.white,
                                          size: 26.0,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        _selectedCategory?.name ?? 'Select Category',
                                        style: AppTypography.bodySm(
                                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                                        ).copyWith(fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // Notes Input Card
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Add notes...',
                        prefixIcon: Icon(Icons.menu_rounded, color: Colors.grey),
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Date Picker Card
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _occurredAt,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _occurredAt = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 20.0, color: Colors.grey),
                          const SizedBox(width: 12.0),
                          Text(
                            DateFormat('EEEE, h:mm a').format(_occurredAt),
                            style: AppTypography.bodyLg(
                              color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                            ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),

          // Numeric Keypad (Closed by default, opens on Amount Tap)
          if (_isKeypadOpen)
            CalculatorKeypad(
              keyTap: _onKeyTap,
              onBackspace: _onBackspace,
              onEqual: () => setState(() => _isKeypadOpen = false),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _submitTransaction(context),
                child: const Text('Save Transaction'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
