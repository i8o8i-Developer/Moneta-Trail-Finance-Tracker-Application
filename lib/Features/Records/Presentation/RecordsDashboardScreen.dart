// Moneta Trail Primary Records Dashboard Screen Component
// Main Transaction Feed Overview With Month Switcher, Filters, And FAB Trigger

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Core/Utilities/CurrencyFormatter.dart';
import 'package:moneta_trail/Features/Accounts/Data/AccountRepository.dart';
import 'package:moneta_trail/Features/Categories/Data/CategoryRepository.dart';
import 'package:moneta_trail/Features/Profile/Data/ProfileRepository.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';
import 'package:moneta_trail/Core/Utilities/CategoryIconMapper.dart';
import 'package:moneta_trail/Widgets/Shared/CategoryPill.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';
import 'package:moneta_trail/Widgets/Shared/TransactionRow.dart';

class RecordsDashboardScreen extends ConsumerStatefulWidget {
  const RecordsDashboardScreen({super.key});

  @override
  ConsumerState<RecordsDashboardScreen> createState() => _RecordsDashboardScreenState();
}

class _RecordsDashboardScreenState extends ConsumerState<RecordsDashboardScreen> {
  DateTime _selectedMonth = DateTime.now();
  String _selectedCategory = 'All';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);
    final txsAsync = ref.watch(monthlyTransactionsStreamProvider(_selectedMonth));
    final accountsAsync = ref.watch(accountsStreamProvider);
    final categoriesAsync = ref.watch(allCategoriesFutureProvider);

    final String currencyCode = profileAsync.value?.primaryCurrency ?? AppTokens.defaultCurrency;

    return Scaffold(
      appBar: HeaderBar(
        title: AppTokens.appName,
        showProfile: true,
        onProfileTap: () => context.push('/profile'),
        onSearchTap: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) _searchController.clear();
          });
        },
      ),
      body: CustomScrollView(
        slivers: [
          // Expandable Real-Time Search Bar
          if (_isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search By Category, Account, Note, Or Amount...',
                      hintStyle: TextStyle(fontSize: 13.0, color: isDark ? Colors.white54 : Colors.black45),
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF10B981), size: 20.0),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18.0),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                  ),
                ),
              ),
            ),
          // Month Selector Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      setState(() {
                        _selectedMonth = DateTime(
                          _selectedMonth.year,
                          _selectedMonth.month - 1,
                        );
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
                        _selectedMonth = DateTime(
                          _selectedMonth.year,
                          _selectedMonth.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Net Balance & Income/Expense KPI Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: txsAsync.when(
                data: (txs) {
                  int incomeCents = 0;
                  int expenseCents = 0;
                  for (final t in txs) {
                    if (t.type == 'Income') incomeCents += t.amountCents;
                    if (t.type == 'Expense') expenseCents += t.amountCents;
                  }
                  final int netCents = incomeCents - expenseCents;
                  final double savingsRate = incomeCents > 0
                      ? ((incomeCents - expenseCents) / incomeCents * 100).clamp(0.0, 100.0)
                      : 0.0;

                  final String monthFormatted = DateFormat('MMM yyyy').format(_selectedMonth);

                  return Container(
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
                        // Top Header Row (Responsive & Overflow-Safe)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL MONTHLY NET',
                                    style: AppTypography.labelCaps(
                                      color: Colors.white.withOpacity(0.85),
                                    ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w700, fontSize: 10.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Active Monthly Ledger • ${txs.length} Records',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(9999.0),
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 11.0, color: Colors.white),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    monthFormatted,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),

                        // Net Balance Display
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            CurrencyFormatter.formatCents(netCents, currencyCode: currencyCode),
                            style: AppTypography.displayHeroMobile(color: Colors.white).copyWith(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14.0),
                        Container(height: 1.0, color: Colors.white.withOpacity(0.18)),
                        const SizedBox(height: 12.0),

                        // Income vs Expenses KPI Row (Overflow-Safe & Symmetrical)
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF34D399).withOpacity(0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF34D399), size: 13.0),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Income',
                                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            CurrencyFormatter.formatCents(incomeCents, currencyCode: currencyCode),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(width: 1.0, height: 24.0, color: Colors.white.withOpacity(0.25)),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF87171).withOpacity(0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFFF87171), size: 13.0),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Expenses',
                                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            CurrencyFormatter.formatCents(expenseCents, currencyCode: currencyCode),
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(width: 1.0, height: 24.0, color: Colors.white.withOpacity(0.25)),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF60A5FA).withOpacity(0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.pie_chart_rounded, color: Color(0xFF60A5FA), size: 13.0),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Savings',
                                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${savingsRate.toStringAsFixed(0)}%',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.0),
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
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(height: 120.0, child: Center(child: CircularProgressIndicator())),
                error: (err, stack) => Text('Failed To Load Transaction Data: $err'),
              ),
            ),
          ),
          // Category Filter Pills Row
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  CategoryPill(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  if (categoriesAsync.value != null)
                    ...categoriesAsync.value!.map((cat) {
                      return CategoryPill(
                        label: cat.name,
                        isSelected: _selectedCategory == cat.name,
                        onTap: () => setState(() => _selectedCategory = cat.name),
                      );
                    }),
                ],
              ),
            ),
          ),
          // Transaction Feed Header Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Recent Transactions',
                style: AppTypography.headlineMd(
                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                ),
              ),
            ),
          ),
          // Transaction Feed List Items
          txsAsync.when(
            data: (allTxs) {
              final accountsMap = accountsAsync.value?.asMap().map((_, a) => MapEntry(a.id, a.name)) ?? {};
              final categoriesList = categoriesAsync.value ?? [];
              final categoriesMap = {for (var c in categoriesList) c.id: c};

              // Filter transactions by selected category pill AND search query
              final String searchQuery = _searchController.text.trim().toLowerCase();
              final txs = allTxs.where((t) {
                final cat = categoriesMap[t.categoryId];
                final catName = (cat?.name ?? (t.type == 'Transfer' ? 'Account Transfer' : 'Expense')).toLowerCase();
                final accountName = (accountsMap[t.accountId] ?? 'Account').toLowerCase();
                final notes = (t.notes ?? '').toLowerCase();
                final amountText = CurrencyFormatter.formatCents(t.amountCents, currencyCode: currencyCode).toLowerCase();

                final bool categoryMatch = _selectedCategory == 'All' || cat?.name == _selectedCategory;
                final bool searchMatch = searchQuery.isEmpty ||
                    catName.contains(searchQuery) ||
                    accountName.contains(searchQuery) ||
                    notes.contains(searchQuery) ||
                    amountText.contains(searchQuery);

                return categoryMatch && searchMatch;
              }).toList();

              if (txs.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48.0,
                          color: isDark ? AppColors.darkOutline : AppColors.lightOutline,
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          _selectedCategory == 'All'
                              ? 'No Transactions Logged This Month'
                              : 'No Transactions Found For $_selectedCategory',
                          style: AppTypography.bodyLg(
                            color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, index) {
                      final t = txs[index];
                      final cat = categoriesMap[t.categoryId];

                      return TransactionRow(
                        title: cat?.name ?? (t.type == 'Transfer' ? 'Account Transfer' : 'Expense'),
                        subtitle: t.notes,
                        accountName: accountsMap[t.accountId] ?? 'Account',
                        amountCents: t.amountCents,
                        type: t.type,
                        occurredAt: t.occurredAt,
                        iconName: cat?.iconName ?? 'receipt_long',
                        currencyCode: currencyCode,
                        onTap: () {
                          _showTransactionDetailsModal(
                            context,
                            ref,
                            t,
                            cat,
                            accountsMap[t.accountId] ?? 'Account',
                            currencyCode,
                          );
                        },
                      );
                    },
                    childCount: txs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, s) => SliverToBoxAdapter(child: Text('Error: $e')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/new'),
        child: const Icon(Icons.add_rounded, size: 28.0),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.0, color: isDark ? Colors.white70 : Colors.black54),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTransactionDetailsModal(
    BuildContext context,
    WidgetRef ref,
    TransactionEntry t,
    Category? cat,
    String accountName,
    String currencyCode,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isIncome = t.type == 'Income';
    final bool isTransfer = t.type == 'Transfer';
    final Color typeColor = isIncome
        ? const Color(0xFF10B981)
        : isTransfer
            ? const Color(0xFF3B82F6)
            : const Color(0xFFEF4444);

    final String title = cat?.name ?? (isTransfer ? 'Account Transfer' : 'Expense');
    final String iconName = cat?.iconName ?? 'receipt_long';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Header Row: Icon Badge + Category Name + Type Tag
              Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: typeColor.withOpacity(0.35), width: 1.0),
                    ),
                    child: Icon(
                      CategoryIconMapper.getIcon(iconName),
                      color: typeColor,
                      size: 22.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            t.type.toUpperCase(),
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Transaction Amount Hero Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: typeColor.withOpacity(0.25), width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'TRANSACTION AMOUNT',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        CurrencyFormatter.formatCents(t.amountCents, currencyCode: currencyCode, showSign: true),
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),

              // Metadata Details Tiles
              _buildDetailTile(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Account Used',
                value: accountName,
                isDark: isDark,
              ),
              const SizedBox(height: 8.0),
              _buildDetailTile(
                icon: Icons.calendar_today_rounded,
                label: 'Date & Time Logged',
                value: DateFormat('MMMM dd, yyyy • hh:mm a').format(t.occurredAt),
                isDark: isDark,
              ),
              if (t.notes != null && t.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 8.0),
                _buildDetailTile(
                  icon: Icons.notes_rounded,
                  label: 'Notes / Description',
                  value: t.notes!,
                  isDark: isDark,
                ),
              ],
              const SizedBox(height: 18.0),

              // Action Buttons Bar (DELETE & CLOSE)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (confirmCtx) => AlertDialog(
                            title: const Text('Delete Transaction?'),
                            content: const Text('Are you sure you want to delete this transaction entry? Account balance will be safely reverted.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(confirmCtx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                                onPressed: () => Navigator.of(confirmCtx).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ref.read(recordsRepositoryProvider).deleteTransaction(t.id);
                          if (ctx.mounted) {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Transaction Deleted Successfully')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.delete_forever_rounded, size: 18.0),
                      label: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : Colors.black87,
                        side: BorderSide(color: (isDark ? Colors.white : Colors.black87).withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// Riverpod Providers For Reactive Streams
final profileStreamProvider = StreamProvider<AppProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});

final monthlyTransactionsStreamProvider = StreamProvider.family<List<TransactionEntry>, DateTime>((ref, month) {
  return ref.watch(recordsRepositoryProvider).watchMonthlyTransactions(month);
});

final accountsStreamProvider = StreamProvider<List<FinancialAccount>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAccounts();
});

final accountTransactionsStreamProvider = StreamProvider.family<List<TransactionEntry>, int>((ref, accountId) {
  return ref.watch(recordsRepositoryProvider).watchAccountTransactions(accountId);
});

final allCategoriesFutureProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).getAllCategories();
});
