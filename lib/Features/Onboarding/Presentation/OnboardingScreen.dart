// Moneta Trail Onboarding And First-Run Setup Screen
// Collects Username And Primary Currency Preference On Initial Application Launch

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Data/ProfileRepository.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';
import 'package:moneta_trail/Widgets/Shared/AppLogoWidget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  String _selectedCurrency = 'USD';
  bool _enableBiometrics = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              // Official App Logo
              const AppLogoWidget(size: 64.0, showBorder: true),
              const SizedBox(height: 24.0),
              Text(
                'Create Local Account',
                style: AppTypography.displayHeroMobile(
                  color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Moneta Trail Is 100% Offline And Stores All Your Data Securely On Your Device [ Locally ]',
                style: AppTypography.bodyLg(
                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                ),
              ),
              const SizedBox(height: 28.0),

              // Name Field
              Text(
                'Full Name',
                style: AppTypography.labelCaps(
                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name (e.g. Alex Morgan)',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Phone Field
              Text(
                'Phone Number / Contact (Optional)',
                style: AppTypography.labelCaps(
                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'e.g. +1 555-0192',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Currency Field
              Text(
                'Primary Currency',
                style: AppTypography.labelCaps(
                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: AppTokens.supportedCurrencies.map((c) {
                  final String symbol = AppTokens.currencySymbols[c] ?? '\$';
                  return DropdownMenuItem<String>(
                    value: c,
                    child: Text('$c ($symbol)'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCurrency = val);
                },
              ),
              const SizedBox(height: 16.0),

              // Security 4-Digit PIN Field
              Text(
                'Security PIN (Optional 4 Digits)',
                style: AppTypography.labelCaps(
                  color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'e.g. 1234',
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enable Biometric Unlock'),
                subtitle: const Text('Require Fingerprint / Face ID On App Open'),
                value: _enableBiometrics,
                activeThumbColor: AppColors.primaryContainer,
                onChanged: (val) => setState(() => _enableBiometrics = val),
              ),
              const SizedBox(height: 28.0),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text.trim().isEmpty ? 'Local User' : _nameController.text.trim();
                    final String? pin = _pinController.text.trim().length == 4 ? _pinController.text.trim() : null;

                    await ref.read(profileRepositoryProvider).updateProfile(
                          username: name,
                          phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                          primaryCurrency: _selectedCurrency,
                          biometricsEnabled: _enableBiometrics,
                          pinHash: pin,
                        );
                    ref.invalidate(profileStreamProvider);
                    if (context.mounted) {
                      context.go('/records');
                    }
                  },
                  child: const Text('Create Local Account'),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
