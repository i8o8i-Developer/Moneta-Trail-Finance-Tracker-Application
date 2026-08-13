// Moneta Trail Application Settings Dashboard Screen Component
// Preferences (Currency, Theme, Language), Local CSV Export, And Local JSON Backup/Restore

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Services/BackupService.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Data/ProfileRepository.dart';
import 'package:moneta_trail/Features/Records/Data/RecordsRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(databaseProvider));
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);

    final String currentCurrency = profileAsync.value?.primaryCurrency ?? 'USD';
    final String currentTheme = profileAsync.value?.appearanceTheme ?? 'Light';

    return Scaffold(
      appBar: HeaderBar(
        title: 'Settings',
        showBack: true,
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Summary Tile
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              leading: CircleAvatar(
                radius: 24.0,
                backgroundColor: AppColors.primaryContainer.withOpacity(0.15),
                child: const Icon(Icons.person_rounded, color: AppColors.primaryContainer),
              ),
              title: Text(
                profileAsync.value?.username ?? 'Alex Morgan',
                style: AppTypography.bodyLg(
                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Local Offline Profile'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/profile'),
            ),
            const SizedBox(height: 24.0),

            // Preferences Section
            Text(
              'Preferences',
              style: AppTypography.headlineMd(
                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 12.0),
            ListTile(
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              leading: const Icon(Icons.monetization_on_rounded),
              title: const Text('Primary Currency'),
              trailing: Text(
                currentCurrency,
                style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.w700),
              ),
              onTap: () {
                _showCurrencyPickerDialog(context, ref, currentCurrency);
              },
            ),
            const SizedBox(height: 8.0),
            ListTile(
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              leading: const Icon(Icons.brightness_6_rounded),
              title: const Text('Appearance / Theme'),
              trailing: Text(
                currentTheme,
                style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.w700),
              ),
              onTap: () {
                _showThemePickerDialog(context, ref, currentTheme);
              },
            ),
            const SizedBox(height: 24.0),

            // Data Management Section
            Text(
              'Data Management',
              style: AppTypography.headlineMd(
                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 12.0),
            ListTile(
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              leading: const Icon(Icons.table_chart_rounded, color: AppColors.primaryContainer),
              title: const Text('Export CSV File'),
              subtitle: const Text('Share Transaction Feed Feed To Device'),
              onTap: () async {
                print('Triggering CSV Export');
                await ref.read(backupServiceProvider).exportTransactionsCsv();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV Export Generated Successfully')),
                  );
                }
              },
            ),
            const SizedBox(height: 8.0),
            ListTile(
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              leading: const Icon(Icons.backup_rounded, color: AppColors.tertiaryContainer),
              title: const Text('Export JSON Database Backup'),
              subtitle: const Text('Create Timestamped Full Backup File'),
              onTap: () async {
                print('Triggering JSON Backup Export');
                await ref.read(backupServiceProvider).exportJsonBackup();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('JSON Backup File Created Successfully')),
                  );
                }
              },
            ),
            const SizedBox(height: 8.0),
            ListTile(
              tileColor: isDark ? AppColors.darkSurfaceContainer : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              leading: const Icon(Icons.restore_page_rounded, color: AppColors.secondaryContainer),
              title: const Text('Restore From JSON Backup File'),
              subtitle: const Text('Import Backup File From Storage'),
              onTap: () async {
                print('Triggering JSON Backup Import');
                final bool success = await ref.read(backupServiceProvider).importJsonBackup();
                if (context.mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Database Restored Successfully')),
                  );
                }
              },
            ),
            const SizedBox(height: 32.0),

            // Lock App Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.lock_rounded),
                label: const Text('Lock Moneta Trail'),
                onPressed: () {
                  context.go('/lock');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPickerDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Primary Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppTokens.supportedCurrencies.map((c) {
            return RadioListTile<String>(
              title: Text('$c (${AppTokens.currencySymbols[c]})'),
              value: c,
              groupValue: current,
              onChanged: (val) async {
                if (val != null) {
                  await ref.read(profileRepositoryProvider).updateProfile(primaryCurrency: val);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemePickerDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Appearance Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Light', 'Dark'].map((t) {
            return RadioListTile<String>(
              title: Text('$t Mode'),
              value: t,
              groupValue: current,
              onChanged: (val) async {
                if (val != null) {
                  await ref.read(profileRepositoryProvider).updateProfile(appearanceTheme: val);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
