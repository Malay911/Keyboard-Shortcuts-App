// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:async';
// import 'package:csv/csv.dart';
// import 'package:flutter/services.dart';
// import '../models/shortcut_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//   static const int _databaseVersion = 2;

//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     String path =
//         join(await getDatabasesPath(), 'shortcuts_v2.db');

//     // Delete existing database to ensure clean slate
//     await deleteDatabase(path);

//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _createDb,
//       onUpgrade: _onUpgrade,
//     );
//   }

//   Future<void> _createDb(Database db, int version) async {
//     print('Creating new database tables...');

//     // Create OS shortcuts table
//     await db.execute('''
//       CREATE TABLE os_shortcuts(
//         id INTEGER,
//         title TEXT,
//         keys TEXT,
//         description TEXT,
//         category TEXT,
//         os_type TEXT,
//         PRIMARY KEY (id, os_type)
//       )
//     ''');
//     print('Created os_shortcuts table');

//     // Create VSCode shortcuts table
//     await db.execute('''
//       CREATE TABLE vscode_shortcuts(
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         windows_keys TEXT,
//         mac_keys TEXT,
//         category TEXT
//       )
//     ''');
//     print('Created vscode_shortcuts table');

//     // Create Android Studio shortcuts table
//     await db.execute('''
//       CREATE TABLE androidstudio_shortcuts(
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         windows_keys TEXT,
//         mac_keys TEXT,
//         category TEXT
//       )
//     ''');
//     print('Created androidstudio_shortcuts table');
//   }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     print('Upgrading database from $oldVersion to $newVersion');

//     // Drop existing tables if they exist
//     await db.execute('DROP TABLE IF EXISTS shortcuts');
//     await db.execute('DROP TABLE IF EXISTS os_shortcuts');
//     await db.execute('DROP TABLE IF EXISTS vscode_shortcuts');
//     await db.execute('DROP TABLE IF EXISTS androidstudio_shortcuts');

//     // Create new tables
//     await _createDb(db, newVersion);
//   }

//   Future<void> loadCsvData() async {
//     try {
//       final db = await database;
//       print('\n=== Starting Fresh Database Load ===');

//       // Load OS shortcuts first
//       print('\nLoading OS shortcuts...');
//       await _loadOSShortcuts(db, 'linux_keyboard_shortcuts.csv', 'linux');
//       await _loadOSShortcuts(db, 'mac_keyboard_shortcuts.csv', 'mac');
//       await _loadOSShortcuts(db, 'keyboard_shortcuts_windows.csv', 'windows');

//       // Load app shortcuts
//       print('\nLoading app shortcuts...');
//       await _loadVSCodeShortcuts(db);
//       await _loadAndroidStudioShortcuts(db);

//       // Verify data loading
//       await _verifyDataLoad(db);
//     } catch (e, stackTrace) {
//       print('Error loading CSV data: $e');
//       print('Stack trace: $stackTrace');
//       rethrow;
//     }
//   }

//   Future<void> _verifyDataLoad(Database db) async {
//     // Verify OS shortcuts
//     final osCount = Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM os_shortcuts'));
//     print('\nOS shortcuts count: $osCount');

//     // Verify VSCode shortcuts
//     final vscodeCount = Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM vscode_shortcuts'));
//     print('VSCode shortcuts count: $vscodeCount');

//     // Verify Android Studio shortcuts
//     final studioCount = Sqflite.firstIntValue(
//         await db.rawQuery('SELECT COUNT(*) FROM androidstudio_shortcuts'));
//     print('Android Studio shortcuts count: $studioCount');
//   }

//   Future<void> _loadOSShortcuts(
//       Database db, String filename, String osType) async {
//     try {
//       final data = await rootBundle.loadString('assets/shortcuts/$filename');
//       final csvTable = const CsvToListConverter().convert(data);

//       await db.transaction((txn) async {
//         for (var i = 1; i < csvTable.length; i++) {
//           var row = csvTable[i];
//           await txn.insert(
//               'os_shortcuts',
//               {
//                 'id': int.parse(row[0].toString()),
//                 'title': row[1].toString(),
//                 'keys': row[2].toString(),
//                 'description': row[3].toString(),
//                 'category': row[4].toString(),
//                 'os_type': osType,
//               },
//               conflictAlgorithm: ConflictAlgorithm.replace);
//         }
//       });
//       print('Loaded ${csvTable.length - 1} $osType shortcuts');
//     } catch (e) {
//       print('Error loading $filename: $e');
//     }
//   }

//   Future<void> _loadVSCodeShortcuts(Database db) async {
//     try {
//       final data =
//           await rootBundle.loadString('assets/shortcuts/vscode_shortcuts.csv');
//       final csvTable = const CsvToListConverter().convert(data);
//       print('\nLoading VSCode shortcuts...');

//       await db.transaction((txn) async {
//         for (var i = 1; i < csvTable.length; i++) {
//           var row = csvTable[i];
//           await txn.insert(
//             'vscode_shortcuts',
//             {
//               'id': int.parse(row[0].toString()),
//               'title': row[1].toString(),
//               'windows_keys': row[2].toString(),
//               'mac_keys': row[3].toString(),
//               'category': row[4].toString(),
//             },
//             conflictAlgorithm: ConflictAlgorithm.replace,
//           );
//         }
//       });

//       final count = Sqflite.firstIntValue(
//           await db.rawQuery('SELECT COUNT(*) FROM vscode_shortcuts'));
//       print('Loaded $count VSCode shortcuts');

//       final sample = await db.query('vscode_shortcuts', limit: 1);
//       if (sample.isNotEmpty) {
//         print('Sample VSCode shortcut: ${sample.first}');
//       }
//     } catch (e, stackTrace) {
//       print('Error loading VSCode shortcuts: $e');
//       print('Stack trace: $stackTrace');
//     }
//   }

//   Future<void> _loadAndroidStudioShortcuts(Database db) async {
//     try {
//       final data = await rootBundle
//           .loadString('assets/shortcuts/androidstudio_shortcuts.csv');
//       final csvTable = const CsvToListConverter().convert(data);

//       await db.transaction((txn) async {
//         for (var i = 1; i < csvTable.length; i++) {
//           var row = csvTable[i];
//           await txn.insert(
//               'androidstudio_shortcuts',
//               {
//                 'id': int.parse(row[0].toString()),
//                 'title': row[1].toString(),
//                 'windows_keys': row[2].toString(),
//                 'mac_keys': row[3].toString(),
//                 'category': row[4].toString(),
//               },
//               conflictAlgorithm: ConflictAlgorithm.replace);
//         }
//       });
//       print('Loaded ${csvTable.length - 1} Android Studio shortcuts');
//     } catch (e) {
//       print('Error loading Android Studio shortcuts: $e');
//     }
//   }

//   Future<List<String>> getCategories(String osType, {String? appName}) async {
//     try {
//       final db = await database;
//       List<Map<String, dynamic>> maps;

//       if (appName == null || appName == 'system') {
//         maps = await db.query(
//           'os_shortcuts',
//           distinct: true,
//           columns: ['category'],
//           where: 'os_type = ?',
//           whereArgs: [osType],
//         );
//       } else {
//         final tableName = _getNormalizedTableName(appName);
//         print('Getting categories from table: $tableName');

//         maps = await db.rawQuery('''
//           SELECT DISTINCT category
//           FROM $tableName
//           ORDER BY category
//         ''');
//       }

//       final categories = maps.map((map) => map['category'] as String).toList()
//         ..sort();
//       print('Found categories: $categories');
//       return categories;
//     } catch (e, stackTrace) {
//       print('Error getting categories: $e');
//       print('Stack trace: $stackTrace');
//       return [];
//     }
//   }

//   Future<List<ShortcutModel>> getShortcutsByCategory(
//       String category, String osType,
//       {String? appName}) async {
//     try {
//       final db = await database;
//       List<Map<String, dynamic>> maps;

//       if (appName == null || appName == 'system') {
//         maps = await db.query(
//           'os_shortcuts',
//           where: 'LOWER(category) = LOWER(?) AND os_type = ?',
//           whereArgs: [category, osType],
//         );
//       } else {
//         final tableName = _getNormalizedTableName(appName);
//         final keysColumn = Platform.isMacOS ? 'mac_keys' : 'windows_keys';

//         print('Querying $tableName for category: $category');
//         maps = await db.rawQuery('''
//           SELECT
//             id,
//             title,
//             $keysColumn as keys,
//             category,
//             ? as os_type,
//             ? as app_name
//           FROM $tableName
//           WHERE LOWER(category) = LOWER(?)
//           ORDER BY id
//         ''', [osType, appName, category]);
//       }

//       print(
//           'Found ${maps.length} shortcuts for $category in ${appName ?? osType}');
//       if (maps.isNotEmpty) {
//         print('Sample shortcut: ${maps.first}');
//       }

//       return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//     } catch (e) {
//       print('Error getting shortcuts by category: $e');
//       return [];
//     }
//   }

//   Future<List<ShortcutModel>> getShortcutsByOS(String osType,
//       {String? appName}) async {
//     try {
//       final db = await database;

//       if (appName == null || appName == 'system') {
//         return _getOSShortcuts(db, osType);
//       } else {
//         return _getAppShortcuts(db, osType, appName);
//       }
//     } catch (e) {
//       print('Error getting shortcuts: $e');
//       return [];
//     }
//   }

//   Future<List<ShortcutModel>> _getOSShortcuts(
//       Database db, String osType) async {
//     final maps = await db.query('os_shortcuts',
//         where: 'os_type = ?', whereArgs: [osType], orderBy: 'category, id');
//     return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//   }

//   Future<List<ShortcutModel>> _getAppShortcuts(
//       Database db, String osType, String appName) async {
//     final tableName = _getNormalizedTableName(appName);
//     final keysColumn = Platform.isMacOS ? 'mac_keys' : 'windows_keys';

//     print('Querying $tableName for $keysColumn shortcuts');

//     final maps = await db.rawQuery('''
//       SELECT
//         id,
//         title,
//         $keysColumn as keys,
//         COALESCE(description, '') as description,
//         category,
//         ? as os_type,
//         ? as app_name
//       FROM $tableName
//       ORDER BY category, id
//     ''', [osType, appName]);

//     print('Found ${maps.length} shortcuts in $tableName');
//     return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//   }

//   String _getNormalizedTableName(String appName) {
//     if (appName.toLowerCase().contains('visual studio code')) {
//       return 'vscode_shortcuts';
//     } else if (appName.toLowerCase().contains('android studio')) {
//       return 'androidstudio_shortcuts';
//     }
//     throw Exception('Unknown app: $appName');
//   }

//   Future<void> debugPrintDatabaseContent() async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> allData = await db.query('shortcuts');
//       print('Total records in database: ${allData.length}');

//       // Count by OS type
//       final windowsCount =
//           allData.where((row) => row['os_type'] == 'windows').length;
//       final macCount = allData.where((row) => row['os_type'] == 'mac').length;
//       final linuxCount =
//           allData.where((row) => row['os_type'] == 'linux').length;

//       print('Windows shortcuts: $windowsCount');
//       print('Mac shortcuts: $macCount');
//       print('Linux shortcuts: $linuxCount');
//     } catch (e) {
//       print('Error printing database content: $e');
//     }
//   }

//   Future<void> verifyDataLoading() async {
//     try {
//       final db = await database;
//       final linuxCount = Sqflite.firstIntValue(await db.rawQuery(
//           'SELECT COUNT(*) FROM shortcuts WHERE os_type = ?', ['linux']));
//       print('Linux shortcuts in database: $linuxCount');

//       // Show some sample data
//       final sampleData = await db.query('shortcuts', limit: 5);
//       print('Sample data from database:');
//       sampleData.forEach((row) => print(row));
//     } catch (e) {
//       print('Error verifying data: $e');
//     }
//   }
// }

// import 'dart:io';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:async';
// import 'package:csv/csv.dart';
// import 'package:flutter/services.dart';
// import '../models/shortcut_model.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//   static const int _databaseVersion = 3;

//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final path = join(await getDatabasesPath(), 'shortcuts_v3.db');

//     // For testing: delete old database to load fresh CSVs
//     await deleteDatabase(path);

//     return await openDatabase(
//       path,
//       version: _databaseVersion,
//       onCreate: _createDb,
//     );
//   }

//   Future<void> _createDb(Database db, int version) async {
//     print('Creating tables...');

//     // Generic table creation for apps
//     Future<void> createShortcutTable(String tableName) async {
//       await db.execute('''
//         CREATE TABLE $tableName(
//           id INTEGER PRIMARY KEY,
//           title TEXT,
//           windows_keys TEXT,
//           mac_keys TEXT,
//           category TEXT
//         )
//       ''');
//       print('Created $tableName table');
//     }

//     // Existing app tables
//     await createShortcutTable('vscode_shortcuts');
//     await createShortcutTable('androidstudio_shortcuts');

//     // New Word, Excel, PPT tables
//     await createShortcutTable('word_shortcuts');
//     await createShortcutTable('excel_shortcuts');
//     await createShortcutTable('ppt_shortcuts');

//     // OS table remains same
//     await db.execute('''
//       CREATE TABLE os_shortcuts(
//         id INTEGER,
//         title TEXT,
//         keys TEXT,
//         description TEXT,
//         category TEXT,
//         os_type TEXT,
//         PRIMARY KEY (id, os_type)
//       )
//     ''');
//   }

//   /// Load all CSV files into DB
//   Future<void> loadCsvData() async {
//     final db = await database;

//     // OS Shortcuts
//     await _loadOSShortcuts(db, 'linux_keyboard_shortcuts.csv', 'linux');
//     await _loadOSShortcuts(db, 'mac_keyboard_shortcuts.csv', 'mac');
//     await _loadOSShortcuts(db, 'keyboard_shortcuts_windows.csv', 'windows');

//     // App Shortcuts
//     await _loadAppCsv(db, 'vscode_shortcuts.csv', 'vscode_shortcuts');
//     await _loadAppCsv(
//         db, 'androidstudio_shortcuts.csv', 'androidstudio_shortcuts');

//     // Word, Excel, PPT
//     await _loadAppCsv(db, 'word_shortcuts.csv', 'word_shortcuts');
//     await _loadAppCsv(db, 'excel_shortcuts.csv', 'excel_shortcuts');
//     await _loadAppCsv(db, 'ppt_shortcuts.csv', 'ppt_shortcuts');

//     print('All CSV data loaded successfully!');
//   }

//   /// Generic app CSV loader
//   Future<void> _loadAppCsv(
//       Database db, String filename, String tableName) async {
//     try {
//       final data = await rootBundle.loadString('assets/shortcuts/$filename');
//       final csvTable = const CsvToListConverter().convert(data);

//       await db.transaction((txn) async {
//         for (var i = 1; i < csvTable.length; i++) {
//           final row = csvTable[i];
//           await txn.insert(
//               tableName,
//               {
//                 'id': int.parse(row[0].toString()),
//                 'title': row[1].toString(),
//                 'windows_keys': row[2].toString(),
//                 'mac_keys': row[3].toString(),
//                 'category': row[4].toString(),
//               },
//               conflictAlgorithm: ConflictAlgorithm.replace);
//         }
//       });

//       print('Loaded ${csvTable.length - 1} shortcuts into $tableName');
//     } catch (e) {
//       print('Error loading $filename: $e');
//     }
//   }

//   Future<void> _loadOSShortcuts(
//       Database db, String filename, String osType) async {
//     try {
//       final data = await rootBundle.loadString('assets/shortcuts/$filename');
//       final csvTable = const CsvToListConverter().convert(data);

//       await db.transaction((txn) async {
//         for (var i = 1; i < csvTable.length; i++) {
//           final row = csvTable[i];
//           await txn.insert(
//               'os_shortcuts',
//               {
//                 'id': int.parse(row[0].toString()),
//                 'title': row[1].toString(),
//                 'keys': row[2].toString(),
//                 'description': row[3].toString(),
//                 'category': row[4].toString(),
//                 'os_type': osType,
//               },
//               conflictAlgorithm: ConflictAlgorithm.replace);
//         }
//       });

//       print('Loaded ${csvTable.length - 1} $osType shortcuts');
//     } catch (e) {
//       print('Error loading $filename: $e');
//     }
//   }

//   /// Map app names to tables
//   String _getNormalizedTableName(String appName) {
//     final lower = appName.toLowerCase();
//     if (lower.contains('visual studio code')) return 'vscode_shortcuts';
//     if (lower.contains('android studio')) return 'androidstudio_shortcuts';
//     if (lower.contains('word')) return 'word_shortcuts';
//     if (lower.contains('excel')) return 'excel_shortcuts';
//     if (lower.contains('powerpoint') || lower.contains('ppt'))
//       return 'ppt_shortcuts';
//     throw Exception('Unknown app: $appName');
//   }

//   /// Fetch categories for given app
//   Future<List<String>> getCategories(String osType, {String? appName}) async {
//     final db = await database;
//     List<Map<String, dynamic>> maps;

//     if (appName == null || appName == 'system') {
//       maps = await db.query(
//         'os_shortcuts',
//         distinct: true,
//         columns: ['category'],
//         where: 'os_type = ?',
//         whereArgs: [osType],
//       );
//     } else {
//       final tableName = _getNormalizedTableName(appName);
//       maps = await db.rawQuery(
//           'SELECT DISTINCT category FROM $tableName ORDER BY category');
//     }

//     return maps.map((map) => map['category'] as String).toList();
//   }

//   Future<List<ShortcutModel>> getShortcutsByOS(String osType,
//       {String? appName}) async {
//     final db = await database;

//     if (appName == null || appName.toLowerCase() == 'system') {
//       final maps = await db.query(
//         'os_shortcuts',
//         where: 'os_type = ?',
//         whereArgs: [osType],
//         orderBy: 'category, id',
//       );
//       return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//     } else {
//       final tableName = _getNormalizedTableName(appName);
//       final keysColumn = Platform.isMacOS ? 'mac_keys' : 'windows_keys';

//       final maps = await db.rawQuery('''
//       SELECT
//         id,
//         title,
//         $keysColumn as keys,
//         '' as description,
//         category,
//         ? as os_type,
//         ? as app_name
//       FROM $tableName
//       ORDER BY category, id
//     ''', [osType, appName]);

//       return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//     }
//   }

//   /// Fetch shortcuts by category
//   Future<List<ShortcutModel>> getShortcutsByCategory(
//       String category, String osType,
//       {String? appName}) async {
//     final db = await database;
//     List<Map<String, dynamic>> maps;

//     if (appName == null || appName == 'system') {
//       maps = await db.query('os_shortcuts',
//           where: 'LOWER(category)=LOWER(?) AND os_type=?',
//           whereArgs: [category, osType]);
//     } else {
//       final tableName = _getNormalizedTableName(appName);
//       final keysColumn = Platform.isMacOS ? 'mac_keys' : 'windows_keys';
//       maps = await db.rawQuery('''
//         SELECT id, title, $keysColumn AS keys, category, ? AS os_type, ? AS app_name
//         FROM $tableName
//         WHERE LOWER(category) = LOWER(?)
//         ORDER BY id
//       ''', [osType, appName, category]);
//     }

//     return maps.map((map) => ShortcutModel.fromMap(map)).toList();
//   }
// }

import 'dart:io';
import 'dart:io' show Platform;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import '../models/shortcut_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const int _databaseVersion = 3;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'shortcuts_v4.db');

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  // -------------------- CREATE DATABASE --------------------
  Future<void> _createDb(Database db, int version) async {
    print('Creating new database tables...');

    await db.execute('''
      CREATE TABLE os_shortcuts(
        id INTEGER,
        title TEXT,
        keys TEXT,
        description TEXT,
        category TEXT,
        os_type TEXT,
        PRIMARY KEY (id, os_type)
      )
    ''');

    Future<void> createAppShortcutTable(String tableName) async {
      await db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY,
          title TEXT,
          windows_keys TEXT,
          mac_keys TEXT,
          category TEXT
        )
      ''');
    }

    await createAppShortcutTable('vscode_shortcuts');
    await createAppShortcutTable('androidstudio_shortcuts');
    await createAppShortcutTable('photoshop_shortcuts');
    await createAppShortcutTable('intellij_idea_shortcuts');
    await createAppShortcutTable('word_shortcuts');
    await createAppShortcutTable('excel_shortcuts');
    await createAppShortcutTable('ppt_shortcuts');

    await db.execute('''
      CREATE TABLE chrome_browser_shortcuts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        windows_keys TEXT,
        mac_keys TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE edge_browser_shortcuts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        windows_keys TEXT,
        mac_keys TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE brave_browser_shortcuts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        windows_keys TEXT,
        mac_keys TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE safari_browser_shortcuts(
        id INTEGER PRIMARY KEY,
        title TEXT,
        mac_keys TEXT,
        category TEXT
      )
    ''');

    print('All tables created successfully');
  }

  // -------------------- UPGRADE DATABASE --------------------
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from $oldVersion to $newVersion');

    await db.execute('DROP TABLE IF EXISTS os_shortcuts');
    await db.execute('DROP TABLE IF EXISTS vscode_shortcuts');
    await db.execute('DROP TABLE IF EXISTS androidstudio_shortcuts');
    await db.execute('DROP TABLE IF EXISTS photoshop_shortcuts');
    await db.execute('DROP TABLE IF EXISTS intellij_idea_shortcuts');
    await db.execute('DROP TABLE IF EXISTS word_shortcuts');
    await db.execute('DROP TABLE IF EXISTS excel_shortcuts');
    await db.execute('DROP TABLE IF EXISTS ppt_shortcuts');
    await db.execute('DROP TABLE IF EXISTS chrome_browser_shortcuts');
    await db.execute('DROP TABLE IF EXISTS edge_browser_shortcuts');
    await db.execute('DROP TABLE IF EXISTS brave_browser_shortcuts');
    await db.execute('DROP TABLE IF EXISTS safari_browser_shortcuts');

    await _createDb(db, newVersion);
  }

  // -------------------- LOAD CSV DATA --------------------
  Future<void> loadCsvData() async {
    try {
      final db = await database;
      print('\n=== Starting Fresh Database Load ===');

      await _loadOSShortcuts(db, 'linux_keyboard_shortcuts.csv', 'linux');
      await _loadOSShortcuts(db, 'mac_keyboard_shortcuts.csv', 'mac');
      await _loadOSShortcuts(db, 'keyboard_shortcuts_windows.csv', 'windows');

      await _loadAppCsv(db, 'vscode_shortcuts.csv', 'vscode_shortcuts');
      await _loadAppCsv(
          db, 'androidstudio_shortcuts.csv', 'androidstudio_shortcuts');
      await _loadAppCsv(db, 'photoshop_shortcuts.csv', 'photoshop_shortcuts');
      await _loadAppCsv(
          db, 'intellij_idea_shortcuts.csv', 'intellij_idea_shortcuts');
      await _loadAppCsv(db, 'word_shortcuts.csv', 'word_shortcuts');
      await _loadAppCsv(db, 'excel_shortcuts.csv', 'excel_shortcuts');
      await _loadAppCsv(db, 'powerpoint_shortcuts.csv', 'ppt_shortcuts');

      await _loadAppCsv(db, 'chrome_shortcuts.csv', 'chrome_browser_shortcuts');
      await _loadAppCsv(db, 'edge_shortcuts.csv', 'edge_browser_shortcuts');
      await _loadAppCsv(db, 'brave_shortcuts.csv', 'brave_browser_shortcuts');
      await _loadAppCsv(db, 'safari_shortcuts.csv', 'safari_browser_shortcuts');

      await _verifyDataLoad(db);
    } catch (e, stackTrace) {
      print('Error loading CSV data: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // -------------------- VERIFY LOADED DATA --------------------
  Future<void> _verifyDataLoad(Database db) async {
    Future<void> countTable(String table) async {
      final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $table'));
      print('$table count: $count');
    }

    await countTable('os_shortcuts');
    await countTable('vscode_shortcuts');
    await countTable('androidstudio_shortcuts');
    await countTable('word_shortcuts');
    await countTable('excel_shortcuts');
    await countTable('ppt_shortcuts');
    await countTable('photoshop_shortcuts');
    await countTable('intellij_idea_shortcuts');
    await countTable('chrome_browser_shortcuts');
    await countTable('edge_browser_shortcuts');
    await countTable('brave_browser_shortcuts');
    await countTable('safari_browser_shortcuts');
  }

  // -------------------- LOAD OS CSV --------------------
  Future<void> _loadOSShortcuts(
      Database db, String filename, String osType) async {
    try {
      final data = await rootBundle.loadString('assets/shortcuts/$filename');
      final csvTable = const CsvToListConverter().convert(data);

      await db.transaction((txn) async {
        for (var i = 1; i < csvTable.length; i++) {
          var row = csvTable[i];
          await txn.insert(
            'os_shortcuts',
            {
              'id': int.parse(row[0].toString()),
              'title': row[1].toString(),
              'keys': row[2].toString(),
              'description': row[3].toString(),
              'category': row[4].toString(),
              'os_type': osType,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      print('Loaded ${csvTable.length - 1} $osType shortcuts');
    } catch (e) {
      print('Error loading $filename: $e');
    }
  }

  // -------------------- LOAD APP CSV --------------------
  // Future<void> _loadAppCsv(
  //     Database db, String filename, String tableName) async {
  //   try {
  //     final data = await rootBundle.loadString('assets/shortcuts/$filename');
  //     final csvTable = const CsvToListConverter().convert(data);

  //     await db.transaction((txn) async {
  //       for (var i = 1; i < csvTable.length; i++) {
  //         var row = csvTable[i];

  //         if (row.isEmpty ||
  //             row.every((cell) => cell.toString().trim().isEmpty)) {
  //           continue;
  //         }

  //         if (tableName == 'chrome_browser_shortcuts' ||
  //             tableName == 'edge_browser_shortcuts' ||
  //             tableName == 'brave_browser_shortcuts') {
  //           await txn.insert(
  //             tableName,
  //             {
  //               'id': int.parse(row[0].toString()),
  //               'title': row[1].toString(),
  //               'windows_keys': row[2].toString(),
  //               'mac_keys': row[2].toString(),
  //               'category': row[3].toString(),
  //             },
  //             conflictAlgorithm: ConflictAlgorithm.replace,
  //           );
  //         } else if (tableName == 'safari_browser_shortcuts') {
  //           await txn.insert(
  //             tableName,
  //             {
  //               'id': int.parse(row[0].toString()),
  //               'title': row[1].toString(),
  //               'mac_keys': row[2].toString(),
  //               'category': row[3].toString(),
  //             },
  //             conflictAlgorithm: ConflictAlgorithm.replace,
  //           );
  //         } else {
  //           try {
  //             await txn.insert(
  //               tableName,
  //               {
  //                 'id': int.parse(row[0].toString()),
  //                 'title': row[1].toString(),
  //                 'windows_keys': row[2].toString(),
  //                 'mac_keys': row[3].toString(),
  //                 'category': row[4].toString(),
  //               },
  //               conflictAlgorithm: ConflictAlgorithm.replace,
  //             );
  //           } catch (e) {
  //             print('Error inserting row ${i} in $tableName: $e');
  //             print('Row data: $row');
  //             print('Row length: ${row.length}');
  //             print('Error inserting row $i: $e');
  //             print('Row length: ${row.length}, Row: $row');
  //           }
  //         }
  //       }
  //     });
  //     print('Loaded ${csvTable.length - 1} shortcuts into $tableName');
  //   } catch (e) {
  //     print('Error loading $filename: $e');
  //   }
  // }
  Future<void> _loadAppCsv(
      Database db, String filename, String tableName) async {
    try {
      print('Loading $filename into $tableName');
      final data = await rootBundle.loadString('assets/shortcuts/$filename');

      List<List<dynamic>> csvTable;

      if (filename == 'photoshop_shortcuts.csv' ||
          filename == 'intellij_idea_shortcuts.csv') {
        csvTable = _parseProblematicCsv(data);
      } else {
        csvTable = const CsvToListConverter().convert(data);
      }

      print('CSV file $filename has ${csvTable.length} total rows');
      if (csvTable.isNotEmpty) {
        print('Header row: ${csvTable[0]}');
        if (csvTable.length > 1) {
          print('First data row: ${csvTable[1]}');
          print('First data row length: ${csvTable[1].length}');
        }
      }

      int successfulInserts = 0;
      await db.transaction((txn) async {
        for (var i = 1; i < csvTable.length; i++) {
          var row = csvTable[i];

          if (row.isEmpty ||
              row.every((cell) => cell.toString().trim().isEmpty)) {
            continue;
          }

          try {
            if (tableName == 'safari_browser_shortcuts') {
              await txn.insert(
                tableName,
                {
                  'id': int.parse(row[0].toString()),
                  'title': row[1].toString(),
                  'mac_keys': row[2].toString(),
                  'category': row[3].toString(),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
              successfulInserts++;
            } else if (tableName == 'chrome_browser_shortcuts' ||
                tableName == 'edge_browser_shortcuts' ||
                tableName == 'brave_browser_shortcuts') {
              await txn.insert(
                tableName,
                {
                  'id': int.parse(row[0].toString()),
                  'title': row[1].toString(),
                  'windows_keys': row[2].toString(),
                  'mac_keys': row[2].toString(),
                  'category': row[3].toString(),
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
              successfulInserts++;
            } else {
              if (row.length >= 5) {
                await txn.insert(
                  tableName,
                  {
                    'id': int.parse(row[0].toString()),
                    'title': row[1].toString(),
                    'windows_keys': row[2].toString(),
                    'mac_keys': row[3].toString(),
                    'category': row[4].toString(),
                  },
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
                successfulInserts++;
              } else {
                print(
                    'Skipping row $i in $tableName: insufficient columns (${row.length})');
              }
            }
          } catch (e) {
            print('Error inserting row $i in $tableName: $e');
          }
        }
      });
      print(
          'Successfully inserted $successfulInserts shortcuts into $tableName');
    } catch (e) {
      print('Error loading $filename: $e');
    }
  }

  List<List<dynamic>> _parseProblematicCsv(String data) {
    final lines =
        data.replaceAll('\r\n', '\n').replaceAll('\r', '\n').split('\n');

    List<List<dynamic>> result = [];

    for (String line in lines) {
      if (line.trim().isEmpty) continue;

      List<String> row = [];
      bool inQuotes = false;
      String currentField = '';

      for (int i = 0; i < line.length; i++) {
        String char = line[i];

        if (char == '"') {
          inQuotes = !inQuotes;
        } else if (char == ',' && !inQuotes) {
          row.add(currentField.trim());
          currentField = '';
        } else {
          currentField += char;
        }
      }

      if (currentField.isNotEmpty) {
        row.add(currentField.trim());
      }

      if (row.length >= 5) {
        result.add(row);
      }
    }

    return result;
  }

  // -------------------- FETCH CATEGORIES --------------------
  Future<List<String>> getCategories(String osType, {String? appName}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (appName == null || appName.toLowerCase() == 'system') {
      maps = await db.query(
        'os_shortcuts',
        distinct: true,
        columns: ['category'],
        where: 'os_type = ?',
        whereArgs: [osType],
      );
    } else {
      final tableName = _getNormalizedTableName(appName);
      maps = await db.rawQuery(
          'SELECT DISTINCT category FROM $tableName ORDER BY category');
    }

    final categories = maps.map((map) => map['category'] as String).toList();
    categories.sort();
    return categories;
  }

  // -------------------- FETCH SHORTCUTS BY CATEGORY --------------------
  Future<List<ShortcutModel>> getShortcutsByCategory(
      String category, String osType,
      {String? appName}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (appName == null || appName == 'system') {
      maps = await db.query('os_shortcuts',
          where: 'LOWER(category) = LOWER(?) AND os_type = ?',
          whereArgs: [category, osType]);
    } else {
      final tableName = _getNormalizedTableName(appName);
      String keysColumn;

      if (tableName == 'safari_browser_shortcuts') {
        keysColumn = 'mac_keys';
      } else {
        keysColumn = osType == 'mac' ? 'mac_keys' : 'windows_keys';
      }

      maps = await db.rawQuery('''
        SELECT id, title, $keysColumn AS keys, category, ? AS os_type, ? AS app_name
        FROM $tableName
        WHERE LOWER(category) = LOWER(?)
        ORDER BY id
      ''', [osType, appName, category]);
    }

    return maps.map((map) => ShortcutModel.fromMap(map)).toList();
  }

  // -------------------- FETCH SHORTCUTS --------------------
  Future<List<ShortcutModel>> getShortcutsByOS(String osType,
      {String? appName}) async {
    final db = await database;

    if (appName == null || appName.toLowerCase() == 'system') {
      final maps = await db.query(
        'os_shortcuts',
        where: 'os_type = ?',
        whereArgs: [osType],
        orderBy: 'category, id',
      );
      return maps.map((map) => ShortcutModel.fromMap(map)).toList();
    } else {
      final tableName = _getNormalizedTableName(appName);
      String keysColumn;

      if (tableName == 'safari_browser_shortcuts') {
        keysColumn = 'mac_keys';
      } else {
        keysColumn =
            osType.toLowerCase() == 'mac' ? 'mac_keys' : 'windows_keys';
      }

      final maps = await db.rawQuery('''
        SELECT 
          id,
          title,
          $keysColumn as keys,
          '' as description,
          category,
          ? as os_type,
          ? as app_name
        FROM $tableName
        ORDER BY category, id
      ''', [osType, appName]);

      return maps.map((map) => ShortcutModel.fromMap(map)).toList();
    }
  }

  // -------------------- MAP APP NAME TO TABLE --------------------
  String _getNormalizedTableName(String appName) {
    final lower = appName.toLowerCase();
    if (lower.contains('visual studio code') || lower.contains('vscode'))
      return 'vscode_shortcuts';
    if (lower.contains('android studio')) return 'androidstudio_shortcuts';
    if (lower.contains('photoshop') || lower.contains('adobe photoshop'))
      return 'photoshop_shortcuts';
    if (lower.contains('intellij') || lower.contains('intellij idea'))
      return 'intellij_idea_shortcuts';
    if (lower.contains('microsoft word') || lower.contains('word'))
      return 'word_shortcuts';
    if (lower.contains('microsoft excel') || lower.contains('excel'))
      return 'excel_shortcuts';
    if (lower.contains('microsoft powerpoint') ||
        lower.contains('powerpoint') ||
        lower.contains('ppt')) return 'ppt_shortcuts';
    if (lower.contains('chrome')) return 'chrome_browser_shortcuts';
    if (lower.contains('edge')) return 'edge_browser_shortcuts';
    if (lower.contains('brave')) return 'brave_browser_shortcuts';
    if (lower.contains('safari')) return 'safari_browser_shortcuts';
    throw Exception('Unknown app: $appName');
  }

  // -------------------- GET AVAILABLE APPS --------------------
  Future<List<String>> getApps(String osType) async {
    List<String> apps = [
      'Visual Studio Code',
      'Android Studio',
      'Adobe Photoshop',
      'IntelliJ IDEA',
      'Word',
      'Excel',
      'PowerPoint',
      'Chrome',
      'Edge',
      'Brave'
    ];
    if (osType.toLowerCase() == 'mac') {
      apps.add('Safari');
    }
    return apps;
  }

  // -------------------- GET AVAILABLE OS --------------------
  Future<List<String>> getAllOS() async {
    final db = await database;
    final maps =
        await db.query('os_shortcuts', distinct: true, columns: ['os_type']);
    return maps.map((map) => map['os_type'] as String).toList();
  }

  // -------------------- GET AVAILABLE BROWSERS --------------------
  Future<List<String>> getBrowsers() async {
    List<String> browsers = ['Chrome', 'Edge', 'Brave', 'Safari'];
    if (Platform.isMacOS) {
      browsers.add('Safari');
    }
    return browsers;
  }
}
