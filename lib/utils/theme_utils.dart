import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeUtils {
  static final isDarkMode = false.obs;
  
  static void init() {
    // Initialize the isDarkMode value based on the ThemeController
    try {
      final ThemeController themeController = Get.find<ThemeController>();
      isDarkMode.value = themeController.isDarkMode;
      
      // Listen for theme changes
      ever(themeController.isDarkModeObs, (bool value) {
        isDarkMode.value = value;
      });
    } catch (e) {
      // If ThemeController is not found, use the system theme
      isDarkMode.value = Get.isDarkMode;
    }
  }
}