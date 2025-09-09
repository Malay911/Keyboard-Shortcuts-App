// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primaryColor = Color(0xFF2563EB);
//   static const Color secondaryColor = Color(0xFFF59E0B);
//   static const Color accentColor = Color(0xFF34D399);

//   static const Color lightBackground = Color(0xFFFAFAFA);
//   static const Color lightSurface = Color(0xFFF9FAFB);
//   static const Color lightPrimaryText = Color(0xFF111827);
//   static const Color lightSecondaryText = Color(0xFF4B5563);
//   static const Color lightDivider = Color(0xFFE5E7EB);

//   static const Color darkBackground = Color(0xFF111827);
//   static const Color darkSurface = Color(0xFF1F2937);
//   static const Color darkPrimaryText = Color(0xFFF9FAFB);
//   static const Color darkSecondaryText = Color(0xFFD1D5DB);
//   static const Color darkDivider = Color(0xFF374151);

//   static ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: primaryColor,
//     colorScheme: ColorScheme.light(
//       primary: primaryColor,
//       secondary: secondaryColor,
//       tertiary: accentColor,
//       background: lightBackground,
//       surface: lightSurface,
//       onPrimary: Colors.white,
//       onSecondary: lightPrimaryText,
//       onBackground: lightPrimaryText,
//       onSurface: lightPrimaryText,
//     ),
//     scaffoldBackgroundColor: lightBackground,
//     cardColor: lightSurface,
//     cardTheme: CardTheme(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     dividerColor: lightDivider,
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: lightPrimaryText),
//       bodyMedium: TextStyle(color: lightPrimaryText),
//       bodySmall: TextStyle(color: lightSecondaryText),
//       displayLarge:
//           TextStyle(color: lightPrimaryText, fontWeight: FontWeight.bold),
//       displayMedium:
//           TextStyle(color: lightPrimaryText, fontWeight: FontWeight.bold),
//       displaySmall:
//           TextStyle(color: lightPrimaryText, fontWeight: FontWeight.bold),
//       titleLarge:
//           TextStyle(color: lightPrimaryText, fontWeight: FontWeight.bold),
//       titleMedium: TextStyle(color: lightPrimaryText),
//       titleSmall: TextStyle(color: lightPrimaryText),
//     ),
//     iconTheme: IconThemeData(
//       color: primaryColor,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: primaryColor,
//       foregroundColor: Colors.white,
//       elevation: 0,
//     ),
//     tabBarTheme: TabBarTheme(
//       labelColor: primaryColor,
//       unselectedLabelColor: lightSecondaryText,
//       indicatorColor: secondaryColor,
//       labelStyle: TextStyle(fontWeight: FontWeight.bold),
//       unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     ),
//   );

//   static ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: primaryColor,
//     colorScheme: ColorScheme.dark(
//       primary: primaryColor,
//       secondary: secondaryColor,
//       tertiary: accentColor,
//       background: darkBackground,
//       surface: darkSurface,
//       onPrimary: Colors.white,
//       onSecondary: darkPrimaryText,
//       onBackground: darkPrimaryText,
//       onSurface: darkPrimaryText,
//     ),
//     scaffoldBackgroundColor: darkBackground,
//     cardColor: darkSurface,
//     cardTheme: CardTheme(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     dividerColor: darkDivider,
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: darkPrimaryText),
//       bodyMedium: TextStyle(color: darkPrimaryText),
//       bodySmall: TextStyle(color: darkSecondaryText),
//       displayLarge:
//           TextStyle(color: darkPrimaryText, fontWeight: FontWeight.bold),
//       displayMedium:
//           TextStyle(color: darkPrimaryText, fontWeight: FontWeight.bold),
//       displaySmall:
//           TextStyle(color: darkPrimaryText, fontWeight: FontWeight.bold),
//       titleLarge:
//           TextStyle(color: darkPrimaryText, fontWeight: FontWeight.bold),
//       titleMedium: TextStyle(color: darkPrimaryText),
//       titleSmall: TextStyle(color: darkPrimaryText),
//     ),
//     iconTheme: IconThemeData(
//       color: primaryColor,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: darkSurface,
//       foregroundColor: darkPrimaryText,
//       elevation: 0,
//     ),
//     tabBarTheme: TabBarTheme(
//       labelColor: primaryColor,
//       unselectedLabelColor: darkSecondaryText,
//       indicatorColor: secondaryColor,
//       labelStyle: TextStyle(fontWeight: FontWeight.bold),
//       unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';

class AppTheme {
  // Enhanced Color Palette
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  
  static const Color secondaryColor = Color(0xFFF59E0B);
  static const Color secondaryLight = Color(0xFFFBBF24);
  static const Color secondaryDark = Color(0xFFD97706);
  
  static const Color accentColor = Color(0xFF34D399);
  static const Color accentLight = Color(0xFF6EE7B7);
  static const Color accentDark = Color(0xFF10B981);

  // Success, Warning, Error colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF8FAFC);
  static const Color lightPrimaryText = Color(0xFF0F172A);
  static const Color lightSecondaryText = Color(0xFF64748B);
  static const Color lightTertiaryText = Color(0xFF94A3B8);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightBorder = Color(0xFFCBD5E1);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFFCBD5E1);
  static const Color darkTertiaryText = Color(0xFF94A3B8);
  static const Color darkDivider = Color(0xFF475569);
  static const Color darkBorder = Color(0xFF64748B);

  // Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentColor, accentLight],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightBackground, lightSurfaceVariant],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground, darkSurface],
  );

  // Enhanced Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLight.withOpacity(0.1),
      secondary: secondaryColor,
      secondaryContainer: secondaryLight.withOpacity(0.1),
      tertiary: accentColor,
      tertiaryContainer: accentLight.withOpacity(0.1),
      surface: lightSurface,
      surfaceVariant: lightSurfaceVariant,
      background: lightBackground,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: lightPrimaryText,
      onTertiary: Colors.white,
      onSurface: lightPrimaryText,
      onBackground: lightPrimaryText,
      onError: Colors.white,
      outline: lightBorder,
      shadow: lightPrimaryText.withOpacity(0.1),
    ),
    scaffoldBackgroundColor: lightBackground,
    
    // Enhanced Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: lightPrimaryText.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: lightSurface,
      margin: const EdgeInsets.all(8),
    ),
    
    // Enhanced AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: lightPrimaryText,
      titleTextStyle: const TextStyle(
        color: lightPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: lightPrimaryText),
      actionsIconTheme: const IconThemeData(color: lightPrimaryText),
    ),
    
    // Enhanced Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        color: lightPrimaryText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: lightPrimaryText,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: lightSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: lightSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
      labelLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: lightSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: lightTertiaryText,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Enhanced Tab Bar Theme
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: lightSecondaryText,
      indicatorColor: secondaryColor,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      overlayColor: MaterialStateProperty.all(primaryColor.withOpacity(0.1)),
    ),
    
    // Enhanced Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    // Enhanced Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Enhanced Icon Theme
    iconTheme: const IconThemeData(
      color: primaryColor,
      size: 24,
    ),
    
    dividerColor: lightDivider,
    dividerTheme: const DividerThemeData(
      color: lightDivider,
      thickness: 1,
      space: 1,
    ),
  );

  // Enhanced Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryLight,
      primaryContainer: primaryLight.withOpacity(0.2),
      secondary: secondaryLight,
      secondaryContainer: secondaryLight.withOpacity(0.2),
      tertiary: accentLight,
      tertiaryContainer: accentLight.withOpacity(0.2),
      surface: darkSurface,
      surfaceVariant: darkSurfaceVariant,
      background: darkBackground,
      error: errorColor,
      onPrimary: darkBackground,
      onSecondary: darkPrimaryText,
      onTertiary: darkBackground,
      onSurface: darkPrimaryText,
      onBackground: darkPrimaryText,
      onError: darkBackground,
      outline: darkBorder,
      shadow: Colors.black.withOpacity(0.3),
    ),
    scaffoldBackgroundColor: darkBackground,
    
    // Enhanced Card Theme for Dark Mode
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: darkSurface,
      margin: const EdgeInsets.all(8),
    ),
    
    // Enhanced AppBar Theme for Dark Mode
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: darkPrimaryText,
      titleTextStyle: const TextStyle(
        color: darkPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: darkPrimaryText),
      actionsIconTheme: const IconThemeData(color: darkPrimaryText),
    ),
    
    // Enhanced Text Theme for Dark Mode
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        color: darkPrimaryText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: darkPrimaryText,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: darkSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: darkSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
      labelLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: darkSecondaryText,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: darkTertiaryText,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Enhanced Tab Bar Theme for Dark Mode
    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: darkSecondaryText,
      indicatorColor: secondaryLight,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      overlayColor: MaterialStateProperty.all(primaryLight.withOpacity(0.1)),
    ),
    
    // Enhanced Button Themes for Dark Mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: darkBackground,
        elevation: 4,
        shadowColor: primaryLight.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        side: const BorderSide(color: primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    
    // Enhanced Input Decoration Theme for Dark Mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Enhanced Icon Theme for Dark Mode
    iconTheme: const IconThemeData(
      color: primaryLight,
      size: 24,
    ),
    
    dividerColor: darkDivider,
    dividerTheme: const DividerThemeData(
      color: darkDivider,
      thickness: 1,
      space: 1,
    ),
  );

  // Utility methods for custom styling
  static BoxShadow get lightCardShadow => BoxShadow(
        color: lightPrimaryText.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      );

  static BoxShadow get darkCardShadow => BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      );

  static BorderRadius get defaultBorderRadius => BorderRadius.circular(12);
  static BorderRadius get largeBorderRadius => BorderRadius.circular(16);
  static BorderRadius get extraLargeBorderRadius => BorderRadius.circular(24);

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
}