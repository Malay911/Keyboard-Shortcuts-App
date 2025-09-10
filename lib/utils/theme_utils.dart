import '../utils/import_exports.dart';

class ThemeUtils {
  static final isDarkMode = false.obs;
  
  static void init() {
    try {
      final ThemeController themeController = Get.find<ThemeController>();
      isDarkMode.value = themeController.isDarkMode;
      
      ever(themeController.isDarkModeObs, (bool value) {
        isDarkMode.value = value;
      });
    } catch (e) {
      isDarkMode.value = Get.isDarkMode;
    }
  }
}