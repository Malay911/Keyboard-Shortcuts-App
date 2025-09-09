import '../utils/import_exports.dart';
// import 'package:get/get.dart';
// import 'package:keyboard_shortcuts_app/utils/constants/string_constants.dart';
import '../models/category_model.dart';
// import '../utils/database_helper.dart';
// import 'package:flutter/material.dart';

class CategoryController extends GetxController {
  final String parentName;
  final String osType;
  final bool isApp;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool _isSearchingShortcuts = false.obs;
  final RxList<Map<String, dynamic>> _searchResults =
      <Map<String, dynamic>>[].obs;

  bool get isSearchingShortcuts => _isSearchingShortcuts.value;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  CategoryController({
    required this.parentName,
    required this.osType,
    this.isApp = false,
  });

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final result = await _dbHelper.getCategories(osType,
          appName: isApp ? parentName : null);

      final shortcutList = await _dbHelper.getShortcutsByOS(osType,
          appName: isApp ? parentName : null);

      categories.assignAll(result.map((categoryName) {
        final catShortcuts =
            shortcutList.where((s) => s.category == categoryName).toList();

        return CategoryModel(
          name: categoryName,
          description: 'Shortcuts for $categoryName',
          icon: getCategoryIcon(categoryName),
          shortcuts: catShortcuts,
          svgIconPath: getCategorySvgIconPath(categoryName),
        );
      }).toList());
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  List<CategoryModel> getFilteredCategories() {
    if (searchQuery.isEmpty || _isSearchingShortcuts.value) {
      return categories;
    }

    return categories.where((category) {
      return category.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          category.description
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      _isSearchingShortcuts.value = false;
      _searchResults.clear();
      return;
    }

    _isSearchingShortcuts.value = true;
    _searchResults.clear();
    _searchCategoriesAndShortcuts(query.toLowerCase());
  }

  void _searchCategoriesAndShortcuts(String query) {
    for (var category in categories) {
      final matchingShortcuts = category.shortcuts.where((shortcut) {
        final searchQuery = query.toLowerCase();
        final shortcutName = shortcut.appName?.toLowerCase() ?? '';
        final shortcutDesc = shortcut.description?.toLowerCase() ?? '';
        final shortcutAction = shortcut.action?.toLowerCase() ?? '';

        // Normalize shortcut keys by removing spaces after modifiers
        final shortcutKeys = (shortcut.keys?.toLowerCase() ?? '')
            .replaceAll('ctrl + ', 'ctrl+')
            .replaceAll('shift + ', 'shift+')
            .replaceAll('alt + ', 'alt+');

        // Normalize search query the same way
        final normalizedQuery = searchQuery
            .replaceAll('ctrl + ', 'ctrl+')
            .replaceAll('shift + ', 'shift+')
            .replaceAll('alt + ', 'alt+');

        return shortcutName.contains(searchQuery) ||
            shortcutDesc.contains(searchQuery) ||
            shortcutAction.contains(searchQuery) ||
            shortcutKeys.contains(normalizedQuery);
      }).toList();

      if (category.name.toLowerCase().contains(query) ||
          category.description.toLowerCase().contains(query) ||
          matchingShortcuts.isNotEmpty) {
        _searchResults.add({
          'category': category,
          'isCategory': true,
          'shortcuts': matchingShortcuts,
        });
      }
    }
  }

  void navigateToCategoryPage(String name) {
    if (isApp) {
      Get.to(
        () => AppCategoryDetailsPage(
          categoryName: name,
          appName: parentName,
          osType: osType,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.to(
        () => CategoryDetailsPage(
          categoryName: name,
          parentName: parentName,
          osType: osType,
          isApp: false,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      // ----- IDE / App Shortcuts -----
      case 'general':
        return Icons.settings;
      case 'navigation':
        return Icons.navigation;
      case 'debugging':
        return Icons.bug_report;
      case 'refactoring':
        return Icons.transform;
      case 'code assist':
        return Icons.code;
      case 'view':
        return Icons.visibility;
      case 'git/scm':
        return Icons.source;
      case 'run/build':
        return Icons.play_arrow;
      case 'terminal':
        return Icons.terminal;

      // ----- OS Shortcuts -----
      case 'window management':
        return Icons.window;
      case 'file explorer':
        return Icons.folder;
      case 'accessibility':
        return Icons.accessibility_new;
      case 'taskbar':
        return Icons.dock;
      case 'screenshot & recording':
        return Icons.screenshot;
      case 'system':
        return Icons.computer;

      // ----- Photoshop Categories -----
      case 'file':
        return Icons.insert_drive_file;
      case 'edit':
        return Icons.edit;
      case 'select':
        return Icons.select_all;
      case 'layer':
        return Icons.layers;
      case 'tools':
        return Icons.build;
      case 'filter':
        return Icons.filter_list;

      // ----- IntelliJ IDEA Categories -----
      case 'code':
        return Icons.code_rounded;
      case 'execution':
        return Icons.play_arrow;
      case 'build':
        return Icons.build_circle;
      case 'search':
        return Icons.search;
      case 'settings':
        return Icons.settings;
      case 'help':
        return Icons.help_outline;

      default:
        return Icons.keyboard;
    }
  }

  String? getCategorySvgIconPath(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'general':
        return 'assets/icons/category-general.svg';
      case 'navigation':
        return 'assets/icons/category-navigation.svg';
      case 'debugging':
        return 'assets/icons/category-debugging.svg';
      case 'window management':
        return 'assets/icons/category-window-management.svg';
      case 'file explorer':
        return 'assets/icons/category-file-explorer.svg';
      case 'accessibility':
        return 'assets/icons/category-accessibility.svg';
      case 'tabs':
        return 'assets/icons/category-tabs.svg';
      case 'bookmarks':
        return 'assets/icons/category-bookmarks.svg';
      case 'search':
        return 'assets/icons/category-search.svg';
      case 'developer':
        return 'assets/icons/category-developer.svg';
      case 'scrolling':
        return 'assets/icons/category-scrolling.svg';
      case 'taskbar':
        return 'assets/icons/category-taskbar.svg';
      case 'screenshot & recording':
        return 'assets/icons/category-screenshot.svg';
      case 'code assist':
        return 'assets/icons/category-code-assist.svg';
      case 'git/scm':
        return 'assets/icons/category-git-scm.svg';
      case 'run/build':
        return 'assets/icons/category-run-build.svg';
      case 'terminal':
        return 'assets/icons/category-terminal.svg';
      case 'refactoring':
        return 'assets/icons/category-refactoring.svg';
      case 'formatting':
        return 'assets/icons/category-formatting.svg';
      case 'view':
        return 'assets/icons/category-view.svg';
      case 'editing':
        return 'assets/icons/category-editing.svg';
      case 'selection':
        return 'assets/icons/category-selection.svg';
      case 'inserting':
        return 'assets/icons/category-inserting.svg';
      case 'system':
        return 'assets/icons/category-system.svg';
      // Office app categories
      case 'object':
        return 'assets/icons/category-object.svg';
      case 'presentation':
        return 'assets/icons/category-presentation.svg';
      case 'slides':
        return 'assets/icons/category-slides.svg';
      case 'document':
        return 'assets/icons/category-document.svg';
      case 'table':
        return 'assets/icons/category-table.svg';
      case 'workbook':
        return 'assets/icons/category-workbook.svg';
      case 'data':
        return 'assets/icons/category-data.svg';
      case 'formulas':
        return 'assets/icons/category-formulas.svg';
      case 'review':
        return 'assets/icons/category-review.svg';
      // Photoshop categories
      case 'file':
        return 'assets/icons/category-document.svg';
      case 'edit':
        return 'assets/icons/category-editing.svg';
      case 'select':
        return 'assets/icons/category-selection.svg';
      case 'layer':
        return 'assets/icons/category-layer.svg';
      case 'tools':
        return 'assets/icons/category-tools.svg';
      case 'filter':
        return 'assets/icons/category-filter.svg';
      // IntelliJ IDEA categories (additional ones not already covered)
      case 'code':
        return 'assets/icons/category-developer.svg';
      case 'execution':
        return 'assets/icons/category-run-build.svg';
      case 'build':
        return 'assets/icons/category-run-build.svg';
      case 'settings':
        return 'assets/icons/category-general.svg';
      case 'help':
        return 'assets/icons/category-help.svg';
      default:
        return null;
    }
  }
}
