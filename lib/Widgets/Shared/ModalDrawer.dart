// Moneta Trail Reusable Bottom Sheet Modal Container Component
// Provides Rounded Sheet Radius, Top Grab Handle, And Backdrop Overlay

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';

class ModalDrawer extends StatelessWidget {
  final Widget child;
  final String? title;

  const ModalDrawer({
    super.key,
    required this.child,
    this.title,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ModalDrawer(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: EdgeInsets.only(
        top: 12.0,
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Grabber Bar
          Center(
            child: Container(
              width: 36.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkOutline : AppColors.lightOutlineVariant,
                borderRadius: BorderRadius.circular(9999.0),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: 16.0),
            Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          const SizedBox(height: 16.0),
          Flexible(child: child),
        ],
      ),
    );
  }
}
