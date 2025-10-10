import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class ThemeController extends GetxController {
  static const String themeKey = 'is_dark_mode';
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  
  RxBool get isDarkModeObs => _isDarkMode;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(themeKey)) {
      _isDarkMode.value = prefs.getBool(themeKey) ?? false;
    } else {
      final brightness = Get.mediaQuery.platformBrightness;
      _isDarkMode.value = brightness == Brightness.dark;
    }
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, _isDarkMode.value);

    update();
  }
}
