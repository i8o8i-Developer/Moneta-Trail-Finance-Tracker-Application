// Moneta Trail Profile And Security Alternative Presentation Screen Component
// Pertains To Alternate Profile View Instance 61e5eb310ff94100b04d46cbca1ef5bd

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Profile/Presentation/ProfileAndSecurityScreen.dart';

class ProfileAndSecurityAltScreen extends ConsumerWidget {
  const ProfileAndSecurityAltScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Security (Alt View)',
          style: AppTypography.headlineMd(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
      ),
      body: const ProfileAndSecurityScreen(),
    );
  }
}
