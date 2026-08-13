// Moneta Trail Records Dashboard Dark Mode Alternative View
// Dark Tonal Presentation Matching Stitch Screen Instance 6ad1ed7fc4a54fd883ef734df7514d37

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardScreen.dart';

class RecordsDashboardAltDarkScreen extends ConsumerWidget {
  const RecordsDashboardAltDarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.darkSurface,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Records Feed (Dark View)',
            style: AppTypography.headlineMd(color: AppColors.darkOnSurface),
          ),
          backgroundColor: AppColors.darkSurface,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: const RecordsDashboardScreen(),
      ),
    );
  }
}
