// Moneta Trail Custom Numeric Calculator Keypad Component
// Supports Digits 0-9, Decimal, Arithmetic Operators (+, -, *, /), And Backspace

import 'package:flutter/material.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';

class CalculatorKeypad extends StatelessWidget {
  final ValueChanged<String> keyTap;
  final VoidCallback onBackspace;
  final VoidCallback onEqual;

  const CalculatorKeypad({
    super.key,
    required this.keyTap,
    required this.onBackspace,
    required this.onEqual,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<List<String>> keyGrid = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['.', '0', '⌫', '+'],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: keyGrid.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              final bool isOperator = ['÷', '×', '-', '+'].contains(key);
              final bool isBackspace = key == '⌫';

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      if (isBackspace) {
                        onBackspace();
                      } else {
                        keyTap(key);
                      }
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 52.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isOperator
                            ? AppColors.primaryContainer.withValues(alpha: 0.15)
                            : isDark
                                ? AppColors.darkSurfaceHigh
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: isBackspace
                          ? Icon(
                              Icons.backspace_outlined,
                              color: isDark
                                  ? AppColors.darkOnSurface
                                  : AppColors.lightOnSurface,
                              size: 20.0,
                            )
                          : Text(
                              key,
                              style: AppTypography.headlineMd(
                                color: isOperator
                                    ? AppColors.primaryContainer
                                    : isDark
                                        ? AppColors.darkOnSurface
                                        : AppColors.lightOnSurface,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
