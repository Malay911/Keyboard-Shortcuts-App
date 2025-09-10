import 'dart:io';
import '../utils/import_exports.dart';

class BrowserController extends GetxController {
  final RxList<AppModel> browsers = <AppModel>[].obs;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadBrowsers();
  }

  void loadBrowsers() {
    final browsersList = [
      AppModel(
          name: StringConstants.chrome,
          icon: Icons.chrome_reader_mode,
          shortcuts: [],
          svgIconPath: 'assets/icons/chrome-brands-solid-full.svg'),
      AppModel(
          name: StringConstants.edge,
          icon: Icons.web,
          shortcuts: [],
          svgIconPath: 'assets/icons/edge-brands-solid-full.svg'),
      AppModel(
          name: StringConstants.brave,
          icon: Icons.security,
          shortcuts: [],
          svgIconPath: 'assets/icons/brave-brands-solid-full.svg'),
      AppModel(
          name: StringConstants.safari,
          icon: Icons.public,
          shortcuts: [],
          svgIconPath: 'assets/icons/safari-brands-solid-full.svg'),
    ];

    browsers.assignAll(browsersList);
  }

  Future<List<CategoryModel>> getBrowserCategories(
      String browserName, String osType) async {
    try {
      final shortcuts =
          await _dbHelper.getShortcutsByOS(osType, appName: browserName);
      final categories =
          await _dbHelper.getCategories(osType, appName: browserName);

      return categories.map((categoryName) {
        final categoryShortcuts = shortcuts
            .where((shortcut) => shortcut.category == categoryName)
            .toList();

        return CategoryModel(
          name: categoryName,
          description: '$browserName shortcuts for $categoryName',
          icon: getCategoryIcon(categoryName),
          shortcuts: categoryShortcuts,
          svgIconPath: getCategorySvgIconPath(categoryName),
        );
      }).toList();
    } catch (e) {
      print('Error loading browser categories: $e');
      return [];
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'general':
        return Icons.settings;
      case 'navigation':
        return Icons.navigation;
      case 'tabs':
        return Icons.tab;
      case 'bookmarks':
        return Icons.bookmark;
      case 'search':
        return Icons.search;
      case 'view':
        return Icons.visibility;
      case 'developer':
        return Icons.developer_mode;
      case 'scrolling':
        return Icons.swap_vert;
      case 'window management':
        return Icons.open_in_browser;
      case 'accessibility':
        return Icons.accessibility_new;
      case 'screenshot & recording':
        return Icons.camera_alt;
      case 'taskbar':
        return Icons.dashboard;
      case 'file explorer':
        return Icons.folder;
      default:
        return Icons.keyboard;
    }
  }

  void navigateToCategoryPage(String browserName) {
    final osType = Platform.isMacOS ? 'mac' : 'windows';

    Get.toNamed(
      StringConstants.categoriesRoute,
      arguments: {
        'parentName': browserName,
        'osType': osType,
        'isApp': true,
      },
    );
  }
  
  String? getCategorySvgIconPath(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'general':
        return 'assets/icons/category-general.svg';
      case 'navigation':
        return 'assets/icons/category-navigation.svg';
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
      case 'view':
        return 'assets/icons/category-view.svg';
      default:
        return null;
    }
  }
}
