// import 'package:keyboard_shortcuts_app/models/app_model.dart';
// import 'package:keyboard_shortcuts_app/models/category_model.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

// class AppsController extends GetxController {
//   final RxList<AppModel> apps = <AppModel>[].obs;
//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   @override
//   void onInit() {
//     super.onInit();
//     loadApps();
//   }

//   void loadApps() {
//     final appsList = [
//       AppModel(
//         name: StringConstants.vsCode,
//         icon: Icons.code,
//         shortcuts: [],
//       ),
//       AppModel(
//         name: 'Android Studio',
//         icon: Icons.android,
//         shortcuts: [],
//       ),
//     ];

//     apps.assignAll(appsList);
//   }

//   Future<List<CategoryModel>> getAppCategories(
//       String appName, String osType) async {
//     try {
//       final shortcuts =
//           await _dbHelper.getShortcutsByOS(osType, appName: appName);
//       final categories =
//           await _dbHelper.getCategories(osType, appName: appName);

//       return categories.map((categoryName) {
//         final categoryShortcuts = shortcuts
//             .where((shortcut) => shortcut.category == categoryName)
//             .toList();

//         return CategoryModel(
//           name: categoryName,
//           description: '$appName shortcuts for $categoryName',
//           icon: getCategoryIcon(categoryName),
//           shortcuts: categoryShortcuts,
//         );
//       }).toList();
//     } catch (e) {
//       print('Error loading app categories: $e');
//       return [];
//     }
//   }

//   IconData getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'general':
//         return Icons.settings;
//       case 'navigation':
//         return Icons.navigation;
//       case 'debugging':
//         return Icons.bug_report;
//       case 'refactoring':
//         return Icons.transform;
//       case 'code assist':
//         return Icons.code;
//       case 'view':
//         return Icons.visibility;
//       case 'git/scm':
//         return Icons.source;
//       case 'run/build':
//         return Icons.play_arrow;
//       case 'terminal':
//         return Icons.terminal;
//       default:
//         return Icons.keyboard;
//     }
//   }

//   void navigateToCategoryPage(String appName) {
//     Get.toNamed('/categories', arguments: appName);
//   }
// }

// import 'dart:io';

// import 'package:keyboard_shortcuts_app/models/app_model.dart';
// import 'package:keyboard_shortcuts_app/models/category_model.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

// class AppsController extends GetxController {
//   final RxList<AppModel> apps = <AppModel>[].obs;
//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   @override
//   void onInit() {
//     super.onInit();
//     loadApps();
//   }

//   /// Load all supported apps (dynamic list)
//   void loadApps() {
//     final appsList = [
//       AppModel(
//         name: StringConstants.vsCode,
//         icon: Icons.code,
//         shortcuts: [],
//       ),
//       AppModel(
//         name: 'Android Studio',
//         icon: Icons.android,
//         shortcuts: [],
//       ),
//       AppModel(
//         name: 'Microsoft Word',
//         icon: Icons.text_fields,
//         shortcuts: [],
//       ),
//       AppModel(
//         name: 'Microsoft Excel',
//         icon: Icons.table_chart,
//         shortcuts: [],
//       ),
//       AppModel(
//         name: 'Microsoft PowerPoint',
//         icon: Icons.slideshow,
//         shortcuts: [],
//       ),
//     ];

//     apps.assignAll(appsList);
//   }

//   // Fetch all categories for a given app
//   Future<List<CategoryModel>> getAppCategories(
//       String appName, String osType) async {
//     try {
//       // Fetch shortcuts and categories from DB
//       final shortcuts =
//           await _dbHelper.getShortcutsByOS(osType, appName: appName);
//       final categories =
//           await _dbHelper.getCategories(osType, appName: appName);

//       // Map each category to a CategoryModel
//       return categories.map((categoryName) {
//         final categoryShortcuts = shortcuts
//             .where((shortcut) => shortcut.category == categoryName)
//             .toList();

//         return CategoryModel(
//           name: categoryName,
//           description: '$appName shortcuts for $categoryName',
//           icon: getCategoryIcon(categoryName),
//           shortcuts: categoryShortcuts,
//         );
//       }).toList();
//     } catch (e) {
//       print('Error loading app categories: $e');
//       return [];
//     }
//   }

//   /// Assign icons based on category names
//   IconData getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'general':
//         return Icons.settings;
//       case 'navigation':
//         return Icons.navigation;
//       case 'debugging':
//         return Icons.bug_report;
//       case 'refactoring':
//         return Icons.transform;
//       case 'code assist':
//         return Icons.code;
//       case 'view':
//         return Icons.visibility;
//       case 'git/scm':
//         return Icons.source;
//       case 'run/build':
//         return Icons.play_arrow;
//       case 'terminal':
//         return Icons.terminal;
//       default:
//         return Icons.keyboard; // fallback for unknown categories
//     }
//   }

//   /// Navigate to app category page
//   void navigateToCategoryPage(String appName) {
//   // Default to windows, or detect from platform if needed
//   final osType = Platform.isMacOS ? 'mac' : 'windows';

//   Get.toNamed(
//     StringConstants.categoriesRoute,
//     arguments: {
//       'parentName': appName,
//       'osType': osType,
//     },
//   );
// }

// }

import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import '../models/app_model.dart';
// import '../models/category_model.dart';
import '../utils/import_exports.dart';

class AppsController extends GetxController {
  final RxList<AppModel> apps = <AppModel>[].obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadApps();
  }

  void loadApps() {
    final appsList = [
      AppModel(
          name: StringConstants.vsCode,
          icon: Icons.code,
          shortcuts: [],
          svgIconPath: 'assets/icons/vscode-brands-solid-full.svg'),
      AppModel(
          name: 'Android Studio',
          icon: Icons.android,
          shortcuts: [],
          svgIconPath: 'assets/icons/android-studio-brands-solid-full.svg'),
      AppModel(
          name: 'Adobe Photoshop',
          icon: Icons.photo,
          shortcuts: [],
          svgIconPath: 'assets/icons/photoshop-brands-solid-full.svg'),
      // AppModel(
      //     name: 'IntelliJ IDEA',
      //     icon: Icons.code_rounded,
      //     shortcuts: [],
      //     svgIconPath: 'assets/icons/intellij-idea.svg'),
      AppModel(
        name: 'IntelliJ IDEA',
        icon: Icons.code_rounded,
        shortcuts: [],
        // svgIconPath: 'assets/icons/intellij-idea.svg',
      ),
      AppModel(
          name: 'Microsoft Word',
          icon: Icons.text_fields,
          shortcuts: [],
          svgIconPath: 'assets/icons/word-brands-solid-full.svg'),
      AppModel(
          name: 'Microsoft Excel',
          icon: Icons.table_chart,
          shortcuts: [],
          svgIconPath: 'assets/icons/excel-brands-solid-full.svg'),
      AppModel(
          name: 'Microsoft PowerPoint',
          icon: Icons.slideshow,
          shortcuts: [],
          svgIconPath: 'assets/icons/powerpoint-brands-solid-full.svg'),
    ];

    apps.assignAll(appsList);
  }

  /// Fetch all categories for a given app
  Future<List<CategoryModel>> getAppCategories(
      String appName, String osType) async {
    try {
      final shortcuts =
          await _dbHelper.getShortcutsByOS(osType, appName: appName);
      final categories =
          await _dbHelper.getCategories(osType, appName: appName);

      return categories.map((categoryName) {
        final categoryShortcuts = shortcuts
            .where((shortcut) => shortcut.category == categoryName)
            .toList();

        return CategoryModel(
          name: categoryName,
          description: '$appName shortcuts for $categoryName',
          icon: getCategoryIcon(categoryName),
          shortcuts: categoryShortcuts,
          svgIconPath: getCategorySvgIconPath(categoryName),
        );
      }).toList();
    } catch (e) {
      print('Error loading app categories: $e');
      return [];
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
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
      // Office apps categories
      case 'editing':
        return Icons.edit;
      case 'select':
        return Icons.select_all;
      case 'edit':
        return Icons.edit;
      case 'file':
        return Icons.insert_drive_file;
      case 'filter':
        return Icons.filter_list;
      case 'layer':
        return Icons.layers;
      case 'tools':
        return Icons.build;
      case 'formatting':
        return Icons.format_bold;
      case 'layout':
        return Icons.view_day;
      case 'review':
        return Icons.rate_review;
      case 'references':
        return Icons.book;
      case 'help':
        return Icons.help_outline;
      // IntelliJ IDEA specific categories
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
      default:
        return Icons.keyboard;
    }
  }

  /// Navigate to app category page
  void navigateToCategoryPage(String appName) {
    final osType = Platform.isMacOS ? 'mac' : 'windows';

    Get.toNamed(
      StringConstants.categoriesRoute,
      arguments: {
        'parentName': appName,
        'osType': osType,
        'isApp': true,
      },
    );
  }

  /// Get SVG icon path for category
  String? getCategorySvgIconPath(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'general':
        return 'assets/icons/category-general.svg';
      case 'navigation':
        return 'assets/icons/category-navigation.svg';
      case 'view':
        return 'assets/icons/category-view.svg';
      case 'editing':
        return 'assets/icons/category-editing.svg';
      case 'edit':
        return 'assets/icons/category-editing.svg';
      case 'formatting':
        return 'assets/icons/category-formatting.svg';
      case 'selection':
        return 'assets/icons/category-selection.svg';
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
      case 'select':
        return 'assets/icons/category-selection.svg';
      case 'layer':
        return 'assets/icons/category-layer.svg';
      case 'tools':
        return 'assets/icons/category-tools.svg';
      case 'filter':
        return 'assets/icons/category-filter.svg';
      // IntelliJ IDEA categories
      case 'code assist':
        return 'assets/icons/category-code-assist.svg';
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
