import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'dart:io';

class ShortcutController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  RxList<ShortcutModel> shortcuts = <ShortcutModel>[].obs;
  RxBool isLoading = false.obs;

  String get currentOS {
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'mac';
    if (Platform.isLinux) return 'linux';
    return 'windows';
  }

  Future<List<ShortcutModel>> getShortcutsByCategory(String category,
      [String? appName]) async {
    isLoading.value = true;
    try {
      final results = await _dbHelper
          .getShortcutsByCategory(category, currentOS, appName: appName);
      shortcuts.value = results;
      return results;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadDatabase() async {
    try {
      await _dbHelper.loadCsvData();
    } catch (e) {
      print('Error reloading database: $e');
    }
  }

  Future<List<String>> getAllCategories([String? appName]) async {
    try {
      return await _dbHelper.getCategories(currentOS, appName: appName);
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<List<String>> getAllCategoriesByOS(String osType) async {
    try {
      return await _dbHelper.getCategories(osType);
    } catch (e) {
      print('Error getting categories by OS: $e');
      return [];
    }
  }

  Future<List<ShortcutModel>> getShortcutsByCategoryAndOS(
      String category, String osType,
      {String? appName}) async {
    isLoading.value = true;
    try {
      final results = await _dbHelper.getShortcutsByCategory(category, osType,
          appName: appName);
      return results;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> getAllApps() async {
    try {
      return [
        'Visual Studio Code',
        'Android Studio',
        'Word',
        'Excel',
        'PowerPoint',
        'Chrome',
        'Edge',
        'Brave',
        'Safari'
      ];
    } catch (e) {
      print('Error getting apps: $e');
      return [];
    }
  }

  Future<List<String>> getAllOS() async {
    try {
      return await _dbHelper.getAllOS();
    } catch (e) {
      print('Error getting OS: $e');
      return [];
    }
  }

  Future<List<String>> getAllBrowsers() async {
    try {
      return ['Chrome', 'Edge', 'Brave', 'Safari'];
    } catch (e) {
      print('Error getting browsers: $e');
      return [];
    }
  }

  Future<List<String>> getAllCategoriesByBrowser(String browserName) async {
    try {
      return await _dbHelper.getCategories(currentOS, appName: browserName);
    } catch (e) {
      print('Error getting categories for browser $browserName: $e');
      return [];
    }
  }

  Future<List<ShortcutModel>> getShortcutsByCategoryAndBrowser(
    String category,
    String browserName,
  ) async {
    isLoading.value = true;
    try {
      final results = await _dbHelper.getShortcutsByCategory(
        category,
        currentOS,
        appName: browserName,
      );
      return results;
    } finally {
      isLoading.value = false;
    }
  }
}
