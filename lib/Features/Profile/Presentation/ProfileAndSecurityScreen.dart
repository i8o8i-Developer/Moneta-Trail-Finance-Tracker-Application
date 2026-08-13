// Moneta Trail Profile And Security Management Screen
// Handles Name/Phone Edits, Biometric Toggles, Local PIN Setup, And Data Reset

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Services/SecurityService.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Data/ProfileRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

final securityServiceProvider = Provider<SecurityService>((ref) => SecurityService());

class ProfileAndSecurityScreen extends ConsumerStatefulWidget {
  const ProfileAndSecurityScreen({super.key});

  @override
  ConsumerState<ProfileAndSecurityScreen> createState() => _ProfileAndSecurityScreenState();
}

class _ProfileAndSecurityScreenState extends ConsumerState<ProfileAndSecurityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _biometrics = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final p = ref.read(profileStreamProvider).value;
      if (p != null) {
        _nameController.text = p.username;
        _phoneController.text = p.phoneNumber ?? '';
        setState(() => _biometrics = p.biometricsEnabled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final profileAsync = ref.watch(profileStreamProvider);

    final profile = profileAsync.value;
    if (profile != null && _nameController.text.isEmpty) {
      _nameController.text = profile.username;
      _phoneController.text = profile.phoneNumber ?? '';
      _biometrics = profile.biometricsEnabled;
    }

    return Scaffold(
      appBar: HeaderBar(
        title: 'Profile & Security',
        showBack: true,
        showProfile: false,
        onBackTap: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar Header Card
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: AppColors.primaryContainer.withOpacity(0.15),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 48.0,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    profileAsync.value?.username ?? 'Alex Morgan',
                    style: AppTypography.headlineMd(
                      color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28.0),

            // Personal Details Form Section
            Text(
              'Personal Details',
              style: AppTypography.headlineMd(
                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              value: profileAsync.value?.primaryCurrency ?? 'USD',
              decoration: InputDecoration(
                labelText: 'Primary Currency',
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
              items: ['USD', 'EUR', 'GBP', 'INR', 'CAD', 'AUD', 'JPY'].map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) async {
                if (val != null) {
                  await ref.read(profileRepositoryProvider).updateProfile(primaryCurrency: val);
                }
              },
            ),
            const SizedBox(height: 24.0),

            // Security Settings Section
            Text(
              'Security Settings',
              style: AppTypography.headlineMd(
                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 12.0),
            SwitchListTile(
              title: const Text('Enable Biometric Lock'),
              subtitle: const Text('Use Fingerprint Or Face Unlock On Launch'),
              value: _biometrics,
              activeThumbColor: AppColors.primaryContainer,
              onChanged: (val) async {
                setState(() => _biometrics = val);
                await ref.read(profileRepositoryProvider).updateProfile(biometricsEnabled: val);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pin_rounded, color: AppColors.primaryContainer),
              title: const Text('Set 4-Digit Security PIN'),
              subtitle: Text(profileAsync.value?.pinHash != null ? 'Security PIN Configured' : 'No PIN Configured'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showSetPinDialog(context),
            ),
            const SizedBox(height: 24.0),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print('Saving Profile Settings To Local Database');
                  await ref.read(profileRepositoryProvider).updateProfile(
                        username: _nameController.text.trim(),
                        phoneNumber: _phoneController.text.trim(),
                        biometricsEnabled: _biometrics,
                      );
                  ref.invalidate(profileStreamProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile Saved Successfully')),
                    );
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 32.0),

            // Danger Zone Section
            Text(
              'Danger Zone',
              style: AppTypography.headlineMd(
                color: AppColors.secondaryContainer,
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: AppColors.secondaryContainer.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset App / Delete All Local Data',
                    style: AppTypography.bodyLg(color: AppColors.secondaryContainer).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'This Will Permanently Delete All Local Accounts, Transactions, And Budgets. This Action Cannot Be Undone.',
                    style: AppTypography.bodySm(color: AppColors.secondaryContainer),
                  ),
                  const SizedBox(height: 12.0),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondaryContainer,
                      side: const BorderSide(color: AppColors.secondaryContainer),
                    ),
                    onPressed: () {
                      _showResetConfirmationDialog(context);
                    },
                    child: const Text('Reset All Local Data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Local Data Reset'),
        content: const Text('Are You Sure You Want To Delete All Local Data? This Is Irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryContainer),
            onPressed: () async {
              print('Executing Reset All Local Data');
              await ref.read(profileRepositoryProvider).resetAllLocalData();
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                context.go('/onboarding');
              }
            },
            child: const Text('Yes, Reset Everything'),
          ),
        ],
      ),
    );
  }

  void _showSetPinDialog(BuildContext context) {
    final TextEditingController pinCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set 4-Digit Security PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter 4-Digit Passcode'),
            const SizedBox(height: 6.0),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'e.g. 1234',
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pinCtrl.text.trim().length == 4) {
                await ref.read(profileRepositoryProvider).updateProfile(pinHash: pinCtrl.text.trim());
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Security PIN Saved Successfully')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN Must Be Exactly 4 Digits')),
                );
              }
            },
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
  }
}
