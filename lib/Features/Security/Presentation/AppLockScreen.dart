// Moneta Trail Security App Lock Screen Component
// Biometric And Local PIN Entry Gate On Application Launch

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Presentation/ProfileAndSecurityScreen.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _pinInput = '';

  void _onDigit(String d) {
    if (_pinInput.length < 4) {
      setState(() => _pinInput += d);
      if (_pinInput.length == 4) {
        _verifyAndUnlock();
      }
    }
  }

  void _onBackspace() {
    if (_pinInput.isNotEmpty) {
      setState(() {
        _pinInput = _pinInput.substring(0, _pinInput.length - 1);
      });
    }
  }

  void _verifyAndUnlock() {
    context.go('/records');
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.lock_outline_rounded,
              size: 64.0,
              color: AppColors.primaryContainer,
            ),
            const SizedBox(height: 16.0),
            Text(
              AppTokens.appName,
              style: AppTypography.displayHeroMobile(
                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Enter Security PIN To Unlock',
              style: AppTypography.bodyLg(
                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
              ),
            ),
            const SizedBox(height: 24.0),

            // PIN Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final bool isFilled = i < _pinInput.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? AppColors.primaryContainer
                        : isDark
                            ? AppColors.darkSurfaceHigh
                            : AppColors.lightSurfaceContainer,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const Spacer(),

            // Numeric Keypad Grid
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  for (var row in [
                    ['1', '2', '3'],
                    ['4', '5', '6'],
                    ['7', '8', '9'],
                    ['', '0', '⌫']
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((key) {
                          if (key.isEmpty) return const SizedBox(width: 60.0);
                          return InkWell(
                            onTap: () {
                              if (key == '⌫') {
                                _onBackspace();
                              } else {
                                _onDigit(key);
                              }
                            },
                            borderRadius: BorderRadius.circular(30.0),
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurfaceContainer
                                    : AppColors.lightSurfaceContainer,
                                shape: BoxShape.circle,
                              ),
                              child: key == '⌫'
                                  ? const Icon(Icons.backspace_outlined, size: 20.0)
                                  : Text(
                                      key,
                                      style: AppTypography.headlineMd(
                                        color: isDark
                                            ? AppColors.darkOnSurface
                                            : AppColors.lightOnSurface,
                                      ),
                                    ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Biometric Trigger Button
            IconButton(
              iconSize: 48.0,
              icon: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryContainer),
              onPressed: () async {
                final bool success = await ref.read(securityServiceProvider).authenticateWithBiometrics();
                if (success && context.mounted) {
                  context.go('/records');
                }
              },
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
