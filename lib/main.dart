// Moneta Trail Application Entry Point And GoRouter Gateway Configuration
// Production-Ready Personal Finance Tracker Application

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppTheme.dart';
import 'package:moneta_trail/Features/Accounts/Presentation/AccountDetailsScreen.dart';
import 'package:moneta_trail/Features/Analysis/Presentation/AdvancedAnalysisScreen.dart';
import 'package:moneta_trail/Features/Budgets/Presentation/BudgetsManagementAltScreen.dart';
import 'package:moneta_trail/Features/Onboarding/Presentation/OnboardingScreen.dart';
import 'package:moneta_trail/Features/Profile/Presentation/ProfileAndSecurityAltScreen.dart';
import 'package:moneta_trail/Features/Profile/Presentation/ProfileAndSecurityScreen.dart';
import 'package:moneta_trail/Features/Records/Presentation/RecordsDashboardAltDarkScreen.dart';
import 'package:moneta_trail/Features/Profile/Presentation/AppLockScreen.dart';
import 'package:moneta_trail/Features/Settings/Presentation/SettingsScreen.dart';
import 'package:moneta_trail/Features/Shell/Presentation/MonetaTrailSuiteScreen.dart';
import 'package:moneta_trail/Features/Transactions/Presentation/AddTransactionScreen.dart';

import 'package:moneta_trail/Features/Splash/Presentation/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Moneta Trail Offline-First Personal Finance Application');
  runApp(const ProviderScope(child: MonetaTrailApp()));
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/lock',
      builder: (context, state) => const AppLockScreen(),
    ),
    GoRoute(
      path: '/records',
      builder: (context, state) => const MonetaTrailSuiteScreen(initialIndex: 0),
    ),
    GoRoute(
      path: '/records/dark',
      builder: (context, state) => const RecordsDashboardAltDarkScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) => const MonetaTrailSuiteScreen(initialIndex: 1),
    ),
    GoRoute(
      path: '/analysis/advanced',
      builder: (context, state) => const AdvancedAnalysisScreen(),
    ),
    GoRoute(
      path: '/budgets',
      builder: (context, state) => const MonetaTrailSuiteScreen(initialIndex: 2),
    ),
    GoRoute(
      path: '/budgets/alt',
      builder: (context, state) => const BudgetsManagementAltScreen(),
    ),
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const MonetaTrailSuiteScreen(initialIndex: 3),
    ),
    GoRoute(
      path: '/accounts/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '1';
        final int id = int.tryParse(idStr) ?? 1;
        return AccountDetailsScreen(accountId: id);
      },
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const MonetaTrailSuiteScreen(initialIndex: 4),
    ),
    GoRoute(
      path: '/transactions/new',
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileAndSecurityScreen(),
    ),
    GoRoute(
      path: '/profile/alt',
      builder: (context, state) => const ProfileAndSecurityAltScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class MonetaTrailApp extends ConsumerWidget {
  const MonetaTrailApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppTokens.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}
