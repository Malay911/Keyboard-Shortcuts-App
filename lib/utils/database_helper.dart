import 'dart:io';
import 'dart:io' show Platform;
import '../utils/import_exports.dart';

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
