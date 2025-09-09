// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'utils/database_helper.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

// Future<void> initServices() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final dbHelper = DatabaseHelper();
//   await dbHelper.initDatabase();
//   await dbHelper.loadCsvData();

//   // Initialize controllers
//   Get.put(ThemeController(), permanent: true);
//   Get.put(ShortcutController(), permanent: true);
//   Get.put(HomeController(), permanent: true);
//   Get.put(AppsController(), permanent: true);
//   Get.put(OSController(), permanent: true);
// }

// void main() async {
//   try {
//     await initServices();
//     runApp(const KeyboardShortcutsApp());
//   } catch (e) {
//     runApp(MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Error initializing app: $e'),
//         ),
//       ),
//     ));
//   }
// }

// class KeyboardShortcutsApp extends StatelessWidget {
//   const KeyboardShortcutsApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeController = Get.find<ThemeController>();

//     return GetBuilder<ThemeController>(
//       builder: (_) => GetMaterialApp(
//         title: StringConstants.appTitle,
//         themeMode: themeController.themeMode,
//         theme: AppTheme.lightTheme.copyWith(
//           tabBarTheme: TabBarTheme(
//             labelColor: AppTheme.lightPrimaryText,
//             unselectedLabelColor: AppTheme.lightSecondaryText,
//             indicatorColor: AppTheme.secondaryColor,
//             indicatorSize: TabBarIndicatorSize.tab,
//           ),
//         ),
//         darkTheme: AppTheme.darkTheme.copyWith(
//           tabBarTheme: TabBarTheme(
//             labelColor: AppTheme.darkPrimaryText,
//             unselectedLabelColor: AppTheme.darkSecondaryText,
//             indicatorColor: AppTheme.secondaryColor,
//             indicatorSize: TabBarIndicatorSize.tab,
//           ),
//         ),
//         debugShowCheckedModeBanner: false,
//         initialRoute: StringConstants.homeRoute,
//         getPages: [
//           GetPage(
//             name: StringConstants.homeRoute,
//             page: () => HomePage(),
//           ),
//           GetPage(
//             name: StringConstants.categoriesRoute,
//             page: () {
//               final args = Get.arguments as Map<String, dynamic>;
//               final parentName = args['parentName'] as String;
//               final osType = args['osType'] as String;

//               return CategoryPage(
//                 controller: Get.put(
//                   CategoryController(parentName: parentName, osType: osType),
//                   tag: parentName,
//                 ),
//               );
//             },
//           ),
//           GetPage(
//             name: StringConstants.categoryDetailsRoute,
//             page: () {
//               final args = Get.arguments as Map<String, dynamic>;
//               return CategoryDetailsPage(
//                 categoryName: args['categoryName'],
//                 parentName: args['parentName'],
//                 osType: args['osType'],
//                 isApp: args['isApp'],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'utils/database_helper.dart';
import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'services/pdf_service_binding.dart';
import 'package:flutter/services.dart';

// Future<void> initServices() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final dbHelper = DatabaseHelper();
//   await dbHelper.initDatabase();
//   await dbHelper.loadCsvData();

//   Get.put(ThemeController(), permanent: true);
//   Get.put(ShortcutController(), permanent: true);
//   Get.put(HomeController(), permanent: true);
//   Get.put(AppsController(), permanent: true);
//   Get.put(OSController(), permanent: true);
//   Get.put(BrowserController(), permanent: true);
// }

// void main() async {
//   try {
//     await initServices();
//     runApp(const KeyboardShortcutsApp());
//   } catch (e) {
//     runApp(MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Error initializing app: $e'),
//         ),
//       ),
//     ));
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  await dbHelper.initDatabase();
  await dbHelper.loadCsvData();

  Get.put(ThemeController(), permanent: true);
  Get.put(ShortcutController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(AppsController(), permanent: true);
  Get.put(OSController(), permanent: true);
  Get.put(BrowserController(), permanent: true);

  PdfServiceBinding().dependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  runApp(const KeyboardShortcutsApp());
}

class KeyboardShortcutsApp extends StatelessWidget {
  const KeyboardShortcutsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(
      builder: (_) => GetMaterialApp(
        title: StringConstants.appTitle,
        themeMode: themeController.themeMode,
        theme: AppTheme.lightTheme.copyWith(
          tabBarTheme: TabBarTheme(
            labelColor: AppTheme.lightPrimaryText,
            unselectedLabelColor: AppTheme.lightSecondaryText,
            indicatorColor: AppTheme.secondaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        darkTheme: AppTheme.darkTheme.copyWith(
          tabBarTheme: TabBarTheme(
            labelColor: AppTheme.darkPrimaryText,
            unselectedLabelColor: AppTheme.darkSecondaryText,
            indicatorColor: AppTheme.secondaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: StringConstants.splashRoute,
        getPages: [
          GetPage(
            name: StringConstants.splashRoute,
            page: () => const SplashScreen(),
          ),
          GetPage(
            name: StringConstants.homeRoute,
            page: () => const HomePage(),
          ),
          GetPage(
            name: StringConstants.categoriesRoute,
            page: () {
              final args = Get.arguments as Map<String, dynamic>;
              final parentName = args['parentName'] as String;
              final osType = args['osType'] as String;
              final isApp = args['isApp'] as bool;

              return CategoryPage(
                controller: Get.put(
                  CategoryController(
                    parentName: parentName,
                    osType: osType,
                    isApp: isApp,
                  ),
                  tag: parentName,
                ),
              );
            },
          ),
          GetPage(
            name: StringConstants.categoryDetailsRoute,
            page: () {
              final args = Get.arguments as Map<String, dynamic>;
              return CategoryDetailsPage(
                categoryName: args['categoryName'],
                parentName: args['parentName'],
                osType: args['osType'],
                isApp: args['isApp'] ?? false,
              );
            },
          ),
        ],
      ),
    );
  }
}
