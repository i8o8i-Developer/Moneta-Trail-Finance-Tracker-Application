// Moneta Trail Header Navigation Bar Widget
// Displays Brand Mark, Screen Title, Search Action, And Profile Avatar

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Constants/AppTokens.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

import 'package:go_router/go_router.dart';

import 'package:moneta_trail/Widgets/Shared/AppLogoWidget.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showProfile;
  final VoidCallback? onBackTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;

  const HeaderBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.showProfile = true,
    this.onBackTap,
    this.onProfileTap,
    this.onSearchTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBackTap ?? () => Navigator.of(context).pop(),
            )
          : const Padding(
              padding: EdgeInsets.all(12.0),
              child: AppLogoWidget(size: 32.0, showBorder: true),
            ),
      title: Text(
        title.isEmpty ? AppTokens.appName : title,
        style: AppTypography.headlineMd(
          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
        ),
      ),
      actions: [
        if (onSearchTap != null)
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: onSearchTap,
          ),
        if (showProfile)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: onProfileTap ?? () => context.push('/profile'),
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: AppColors.primaryContainer.withOpacity(0.2),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryContainer,
                  size: 22.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
