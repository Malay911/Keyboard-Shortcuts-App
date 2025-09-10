import '../utils/import_exports.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  
  static const Color secondaryColor = Color(0xFFF59E0B);
  static const Color secondaryLight = Color(0xFFFBBF24);
  static const Color secondaryDark = Color(0xFFD97706);
  
  static const Color accentColor = Color(0xFF34D399);
  static const Color accentLight = Color(0xFF6EE7B7);
  static const Color accentDark = Color(0xFF10B981);

  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF8FAFC);
  static const Color lightPrimaryText = Color(0xFF0F172A);
  static const Color lightSecondaryText = Color(0xFF64748B);
  static const Color lightTertiaryText = Color(0xFF94A3B8);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightBorder = Color(0xFFCBD5E1);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFFCBD5E1);
  static const Color darkTertiaryText = Color(0xFF94A3B8);
  static const Color darkDivider = Color(0xFF475569);
  static const Color darkBorder = Color(0xFF64748B);

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
    
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: lightPrimaryText.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: lightSurface,
      margin: const EdgeInsets.all(8),
    ),
    
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
    
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: darkSurface,
      margin: const EdgeInsets.all(8),
    ),
    
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

  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
}