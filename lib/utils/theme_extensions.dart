import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

extension ThemeExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ThemeController get themeController => Get.find<ThemeController>();
}

extension ThemeHelperX on GetInterface {
  bool get isDarkMode => Get.theme.brightness == Brightness.dark;

  void toggleTheme() {
    final ThemeController themeController = Get.find<ThemeController>();
    themeController.toggleTheme();
  }
}
