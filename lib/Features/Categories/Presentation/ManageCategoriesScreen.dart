// Moneta Trail Manage Categories Dashboard Screen Component
// Expense vs. Income Category Tab Switcher And Custom Category Manager

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneta_trail/Core/Database/AppDatabase.dart';
import 'package:moneta_trail/Core/Theme/AppColors.dart';
import 'package:moneta_trail/Core/Theme/AppTypography.dart';
import 'package:moneta_trail/Features/Categories/Data/CategoryRepository.dart';
import 'package:moneta_trail/Widgets/Shared/HeaderBar.dart';

import 'package:moneta_trail/Core/Utilities/CategoryIconMapper.dart';

class ManageCategoriesScreen extends ConsumerStatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  ConsumerState<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends ConsumerState<ManageCategoriesScreen> {
  String _selectedType = 'Expense';

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(categoriesStreamProvider(_selectedType));

    return Scaffold(
      appBar: const HeaderBar(
        title: 'Manage Categories',
        showProfile: true,
      ),
      body: Column(
        children: [
          // Segmented Tab Switcher (Expense / Income)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceContainer : AppColors.lightSurfaceContainer,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                children: ['Expense', 'Income'].map((type) {
                  final bool isSelected = _selectedType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.primaryFixedDim : AppColors.primaryContainer)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          type,
                          style: AppTypography.bodyLg(
                            color: isSelected
                                ? (isDark ? Colors.black : Colors.white)
                                : (isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface),
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Category List
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return Center(
                    child: Text(
                      'No $_selectedType Categories Available',
                      style: AppTypography.bodyLg(
                        color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOutline,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final IconData icon = CategoryIconMapper.getIcon(cat.iconName);

                    final List<Color> vibrantColors = [
                      const Color(0xFF3B82F6),
                      const Color(0xFF10B981),
                      const Color(0xFFF59E0B),
                      const Color(0xFF8B5CF6),
                      const Color(0xFFEC4899),
                      const Color(0xFF06B6D4),
                      const Color(0xFFEF4444),
                      const Color(0xFF14B8A6),
                      const Color(0xFF6366F1),
                      const Color(0xFFF97316),
                    ];

                    Color catColor = vibrantColors[index % vibrantColors.length];
                    if (cat.colorHex.isNotEmpty) {
                      try {
                        final hex = cat.colorHex.replaceAll('#', '');
                        if (hex.length == 6) {
                          catColor = Color(int.parse('FF$hex', radix: 16));
                        }
                      } catch (_) {}
                    }

                    final String titleCaseName = cat.name
                        .split(' ')
                        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                        .join(' ');

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceContainer : Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkOutline.withOpacity(0.2)
                              : AppColors.lightOutlineVariant.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: catColor,
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Text(
                              titleCaseName,
                              style: AppTypography.bodyLg(
                                color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            onPressed: () => _showCategoryOptionsModal(context, cat),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCategoryDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Category'),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    String selectedIconName = 'category';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            title: const Text('Add Custom Category'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category Name'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Subscriptions / Fitness',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Select Category Icon'),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 190.0,
                    width: double.maxFinite,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: CategoryIconMapper.getAllIconNames().length,
                      itemBuilder: (ctx, idx) {
                        final String iconName = CategoryIconMapper.getAllIconNames()[idx];
                        final IconData icon = CategoryIconMapper.getIcon(iconName);
                        final bool isSelected = selectedIconName == iconName;

                        final List<Color> vibrantColors = [
                          const Color(0xFF3B82F6),
                          const Color(0xFF10B981),
                          const Color(0xFFF59E0B),
                          const Color(0xFF8B5CF6),
                          const Color(0xFFEC4899),
                          const Color(0xFF06B6D4),
                          const Color(0xFFEF4444),
                          const Color(0xFF14B8A6),
                          const Color(0xFF6366F1),
                          const Color(0xFFF97316),
                          const Color(0xFFA855F7),
                          const Color(0xFF0284C7),
                        ];

                        final Color itemColor = vibrantColors[idx % vibrantColors.length];

                        return GestureDetector(
                          onTap: () => setModalState(() => selectedIconName = iconName),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? itemColor : itemColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: isSelected ? itemColor : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : itemColor,
                              size: 22.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    final int idx = CategoryIconMapper.getAllIconNames().indexOf(selectedIconName);
                    final List<String> hexes = ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6', '#EC4899', '#06B6D4', '#EF4444', '#14B8A6', '#6366F1', '#F97316'];
                    final String chosenHex = idx >= 0 ? hexes[idx % hexes.length] : '#3B82F6';

                    final String rawName = nameCtrl.text.trim();
                    final String formattedName = rawName
                        .split(' ')
                        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                        .join(' ');

                    await ref.read(categoryRepositoryProvider).createCategory(
                          name: formattedName,
                          iconName: selectedIconName,
                          colorHex: chosenHex,
                          type: _selectedType,
                        );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Add Category'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCategoryOptionsModal(BuildContext context, Category cat) {
    final TextEditingController nameCtrl = TextEditingController(text: cat.name);
    String selectedIconName = cat.iconName;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            title: Text('Edit Category: ${cat.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Category Name'),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Category Icon'),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 190.0,
                    width: double.maxFinite,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: CategoryIconMapper.getAllIconNames().length,
                      itemBuilder: (ctx, idx) {
                        final String iconName = CategoryIconMapper.getAllIconNames()[idx];
                        final IconData icon = CategoryIconMapper.getIcon(iconName);
                        final bool isSelected = selectedIconName == iconName;

                        final List<Color> vibrantColors = [
                          const Color(0xFF3B82F6),
                          const Color(0xFF10B981),
                          const Color(0xFFF59E0B),
                          const Color(0xFF8B5CF6),
                          const Color(0xFFEC4899),
                          const Color(0xFF06B6D4),
                          const Color(0xFFEF4444),
                          const Color(0xFF14B8A6),
                          const Color(0xFF6366F1),
                          const Color(0xFFF97316),
                          const Color(0xFFA855F7),
                          const Color(0xFF0284C7),
                        ];

                        final Color itemColor = vibrantColors[idx % vibrantColors.length];

                        return GestureDetector(
                          onTap: () => setModalState(() => selectedIconName = iconName),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? itemColor : itemColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: isSelected ? itemColor : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : itemColor,
                              size: 22.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            actions: [
              Row(
                children: [
                  if (!cat.isDefault)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                      tooltip: 'Delete Category',
                      onPressed: () async {
                        await ref.read(categoryRepositoryProvider).deleteCategory(cat.id);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      },
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameCtrl.text.trim().isNotEmpty) {
                        final int idx = CategoryIconMapper.getAllIconNames().indexOf(selectedIconName);
                        final List<String> hexes = ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6', '#EC4899', '#06B6D4', '#EF4444', '#14B8A6', '#6366F1', '#F97316'];
                        final String chosenHex = idx >= 0 ? hexes[idx % hexes.length] : cat.colorHex;

                        final String rawName = nameCtrl.text.trim();
                        final String formattedName = rawName
                            .split(' ')
                            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}' : '')
                            .join(' ');

                        await ref.read(categoryRepositoryProvider).updateCategory(
                              id: cat.id,
                              name: formattedName,
                              iconName: selectedIconName,
                              colorHex: chosenHex,
                            );
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

final categoriesStreamProvider = StreamProvider.family<List<Category>, String>((ref, type) {
  return ref.watch(categoryRepositoryProvider).watchCategories(type);
});
