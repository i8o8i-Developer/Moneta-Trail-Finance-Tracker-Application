// Moneta Trail Biometric & Security Passcode Lock Screen
// Enforces Local Fingerprint/Face ID Or 4-Digit PIN Lock Before Application Access

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';

import 'package:moneta_trail/Widgets/Shared/AppLogoWidget.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  String _enteredPin = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _attemptBiometricAuth();
  }

  Future<void> _attemptBiometricAuth() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (canCheck) {
        final bool authenticated = await _auth.authenticate(
          localizedReason: 'Authenticate To Access Moneta Trail Tracker',
          options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
        );
        if (authenticated && mounted) {
          context.go('/records');
        }
      }
    } catch (e) {
      print('Biometric Lock Exception: $e');
    }
  }

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = null;
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDeletePress() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _verifyPin() {
    final profile = ref.read(profileStreamProvider).value;
    final String targetPin = profile?.pinHash ?? '1234';

    if (_enteredPin == targetPin) {
      context.go('/records');
    } else {
      setState(() {
        _errorMessage = 'Incorrect Security PIN';
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double buttonSize = (constraints.maxHeight < 680) ? 54.0 : 62.0;
            final double rowSpacing = (constraints.maxHeight < 680) ? 10.0 : 14.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32.0),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      // Official App Logo
                      const AppLogoWidget(size: 72.0, showBorder: true),
                      const SizedBox(height: 16.0),
                      Text(
                        'Application Locked',
                        style: AppTypography.displayHeroMobile(
                          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                        ).copyWith(fontSize: 26.0),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'Enter Security PIN Or Authenticate',
                        style: AppTypography.bodyLg(
                          color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                        ).copyWith(fontSize: 14.0),
                      ),
                      const SizedBox(height: 24.0),

                      // 4 PIN Dots Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final bool filled = index < _enteredPin.length;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filled
                                  ? const Color(0xFF10B981)
                                  : (isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer),
                              border: Border.all(
                                color: const Color(0xFF10B981),
                                width: 2.0,
                              ),
                              boxShadow: filled
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withOpacity(0.4),
                                        blurRadius: 8.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),

                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12.0),
                        Text(
                          _errorMessage!,
                          style: AppTypography.bodySm(color: AppColors.secondaryContainer).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],

                      const Spacer(),

                      // Numeric Keypad Grid
                      Column(
                        children: [
                          _buildKeypadRow(['1', '2', '3'], buttonSize),
                          SizedBox(height: rowSpacing),
                          _buildKeypadRow(['4', '5', '6'], buttonSize),
                          SizedBox(height: rowSpacing),
                          _buildKeypadRow(['7', '8', '9'], buttonSize),
                          SizedBox(height: rowSpacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: IconButton(
                                  iconSize: 28.0,
                                  icon: const Icon(Icons.fingerprint_rounded, color: Color(0xFF10B981)),
                                  onPressed: _attemptBiometricAuth,
                                ),
                              ),
                              _buildKeypadButton('0', buttonSize),
                              SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: IconButton(
                                  iconSize: 26.0,
                                  icon: const Icon(Icons.backspace_outlined),
                                  onPressed: _onDeletePress,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits, double buttonSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildKeypadButton(d, buttonSize)).toList(),
    );
  }

  Widget _buildKeypadButton(String digit, double size) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => _onKeyPress(digit),
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: AppTypography.headlineMd(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ).copyWith(fontSize: 20.0),
        ),
      ),
    );
  }
}
