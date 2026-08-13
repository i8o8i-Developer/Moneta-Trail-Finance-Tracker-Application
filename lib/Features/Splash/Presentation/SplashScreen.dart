// Moneta Trail Splash Screen Component
// Replicated 1-to-1 from Extracted_Screens/Code.html Design Spec

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Data/ProfileRepository.dart';
import 'package:moneta_trail/Widgets/Shared/AppLogoWidget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Cubic(0.16, 1.0, 0.3, 1.0),
    ));

    _animController.forward();
    _handleSplashNavigation();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleSplashNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    AppProfile? profile;
    try {
      profile = await ref.read(profileRepositoryProvider).getProfileDirect();
    } catch (e) {
      print('Splash Navigation Profile fetch error: $e');
    }
    if (!mounted) return;

    if (profile != null && (profile.biometricsEnabled || (profile.pinHash != null && profile.pinHash!.isNotEmpty))) {
      context.go('/lock');
    } else {
      context.go('/records');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Centerpiece Area
            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App Logo Centerpiece
                        const AppLogoWidget(size: 88.0, showBorder: true),
                        const SizedBox(height: 24.0),

                        // Gradient Brand Name: "Moneta Trail"
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Moneta Trail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),

                        // Sub-brand Tagline
                        Text(
                          'Clarity In Capital.',
                          style: AppTypography.bodyLg(
                            color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF3C4A42),
                          ).copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Fixed Loading Area
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minimal Sliding Progress Indicator Bar
                    Container(
                      width: 64.0,
                      height: 2.0,
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : AppColors.lightOutline).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: const LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Security Syncing Status
                    Text(
                      'Syncing Securely',
                      style: AppTypography.labelCaps(
                        color: isDark ? AppColors.darkOnSurfaceVariant : const Color(0xFF3C4A42),
                      ).copyWith(
                        fontSize: 11.5,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
