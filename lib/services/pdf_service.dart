import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class PdfService extends GetxService {
  final ShortcutController _shortcutController = Get.find<ShortcutController>();

  Future<PdfService> init() async {
    return this;
  }

  Future<File> generateCategoryPdf(String category, String? appName,
      {String? osType}) async {
    final effectiveOsType = osType ?? _shortcutController.currentOS;
    final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
        category, effectiveOsType,
        appName: appName);

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);

    final pageFormat = PdfPageFormat.a4;
    final theme = pw.ThemeData.base();

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      buildBackground: (pw.Context context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: backgroundColor),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) => [
          _buildHeader(category, appName, textColor, accentColor),
          _buildShortcutsList(shortcuts, textColor, accentColor),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    String fileName = '${category.replaceAll(' ', '_')}_shortcuts';
    if (appName != null && appName.isNotEmpty) {
      fileName += '_${appName.replaceAll(' ', '_')}';
    }
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<File> generateAppPdf(String? appName, {String? osType}) async {
    final effectiveOsType = osType ?? _shortcutController.currentOS;
    final categories = await _shortcutController.getAllCategories(appName);

    Map<String, List<ShortcutModel>> categoryShortcuts = {};
    for (final category in categories) {
      categoryShortcuts[category] =
          await _shortcutController.getShortcutsByCategoryAndOS(
        category,
        effectiveOsType,
        appName: appName,
      );
    }

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1); // Blue accent color

    final pageFormat = PdfPageFormat.a4;
    final theme = pw.ThemeData.base();

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      buildBackground: (pw.Context context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: backgroundColor),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (pw.Context context) => [
          _buildAppHeader(appName, textColor, accentColor),
          ...categories.map(
            (category) => _buildCategorySection(
              category,
              appName,
              textColor,
              accentColor,
              categoryShortcuts[category]!,
            ),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    String fileName = appName != null && appName.isNotEmpty
        ? '${appName.replaceAll(' ', '_')}_shortcuts'
        : 'all_shortcuts';
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildHeader(String category, String? appName, PdfColor textColor,
      PdfColor accentColor) {
    final title = appName != null && appName.isNotEmpty
        ? '$category - $appName Shortcuts'
        : '$category Shortcuts';

    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
                fontSize: 24, color: textColor, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(color: accentColor, thickness: 2),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }

  pw.Widget _buildAppHeader(
      String? appName, PdfColor textColor, PdfColor accentColor) {
    final title = appName != null && appName.isNotEmpty
        ? '$appName Shortcuts'
        : 'All Shortcuts';

    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
                fontSize: 24, color: textColor, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(color: accentColor, thickness: 2),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }

  pw.Widget _buildCategorySection(String category, String? appName,
      PdfColor textColor, PdfColor accentColor, List<ShortcutModel> shortcuts) {
    print(
        'Building category section for $category with ${shortcuts.length} shortcuts');
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: pw.BoxDecoration(
        border:
            pw.Border(bottom: pw.BorderSide(color: accentColor, width: 0.5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text(
              category,
              style: pw.TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: pw.FontWeight.bold),
            ),
          ),
          _buildShortcutsList(shortcuts, textColor, accentColor),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }

  PdfColor withPdfAlpha(PdfColor color, int alpha) {
    final r = color.red;
    final g = color.green;
    final b = color.blue;
    final a = alpha / 255.0;
    return PdfColor(r, g, b, a);
  }

  pw.Widget _buildShortcutsList(
      List<ShortcutModel> shortcuts, PdfColor textColor, PdfColor accentColor) {
    print('Building shortcuts list with ${shortcuts.length} shortcuts');
    if (shortcuts.isEmpty) {
      return pw.Container();
    }

    // Print first shortcut for debugging
    if (shortcuts.isNotEmpty) {
      print(
          'First shortcut: ${shortcuts.first.action} - ${shortcuts.first.keys}');
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: accentColor, width: 1),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(
            color: withPdfAlpha(accentColor, 100), width: 0.5),
        columnWidths: {
          0: const pw.FlexColumnWidth(3), // Action
          1: const pw.FlexColumnWidth(2), // Keys
        },
        children: [
          // Header row
          pw.TableRow(
            decoration: pw.BoxDecoration(
              color: withPdfAlpha(accentColor, 50),
            ),
            children: [
              _buildTableCell('Action', textColor, true),
              _buildTableCell('Keys', textColor, true),
            ],
          ),
          // Data rows
          ...shortcuts
              .map((shortcut) => pw.TableRow(
                    children: [
                      _buildTableCell(shortcut.action, textColor, false),
                      _buildTableCell(shortcut.keys, textColor, false),
                    ],
                  ))
              .toList(),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, PdfColor textColor, bool isHeader) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: textColor,
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  Future<void> sharePdf(File pdfFile) async {
    await Share.shareXFiles(
      [XFile(pdfFile.path)],
      subject: 'Keyboard Shortcuts',
      text: 'Here are your keyboard shortcuts',
    );
  }

  Future<void> previewPdf(File pdfFile) async {
    await Printing.layoutPdf(
      onLayout: (_) async => pdfFile.readAsBytes(),
    );
  }

  Future<File> generateAllAppsPdf() async {
    final ideTabApps = [
      'Visual Studio Code',
      'Android Studio',
      'Microsoft Word',
      'Microsoft Excel',
      'Microsoft PowerPoint',
      'Adobe Photoshop',
      'IntelliJ IDEA',
    ];
    final windowsOS = 'windows';

    Map<String, Map<String, List<ShortcutModel>>> appData = {};

    print('Generating PDF for IDE tab apps: $ideTabApps');
    print('Operating system: $windowsOS');

    for (final app in ideTabApps) {
      print('Processing app: $app');
      appData[app] = {};

      final categories = await _shortcutController.getAllCategories(app);
      print('Categories for $app on $windowsOS: $categories');

      for (final category in categories) {
        final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
          category,
          windowsOS,
          appName: app,
        );

        print(
            'App: $app, OS: $windowsOS, Category: $category, Shortcuts: ${shortcuts.length}');

        if (shortcuts.isNotEmpty) {
          appData[app]![category] = shortcuts;
          print(
              'Added ${shortcuts.length} shortcuts for $app - $windowsOS - $category');
        }
      }
    }

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);

    final pageFormat = PdfPageFormat.a4;

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      buildBackground: (pw.Context context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: backgroundColor),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) =>
            _buildAppHeader('Apps Shortcuts (Windows)', textColor, accentColor),
        build: (context) => [
          pw.SizedBox(height: 20),
          for (final app in ideTabApps) ...[
            if (appData[app]!.isNotEmpty) ...[
              pw.Header(
                level: 0,
                child: pw.Text(
                  app,
                  style: pw.TextStyle(
                    fontSize: 24,
                    color: textColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              for (final category in appData[app]!.keys)
                _buildCategorySection(
                  category,
                  app,
                  textColor,
                  accentColor,
                  appData[app]![category]!,
                ),
              pw.SizedBox(height: 30),
            ],
          ],
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    String fileName = 'apps_shortcuts_windows';
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Future<File> generateOSPdf(String osName, String osType) async {
  //   // Get all categories for this OS
  //   final categories = await _shortcutController.getAllCategoriesByOS(osType);

  //   // Get shortcuts for each category
  //   Map<String, List<ShortcutModel>> categoryShortcuts = {};
  //   for (final category in categories) {
  //     categoryShortcuts[category] =
  //         await _shortcutController.getShortcutsByCategoryAndOS(
  //           category,
  //           osType,
  //         );
  //   }

  //   final pdf = pw.Document();

  //   // Get current theme state directly when generating PDF
  //   final isDarkMode = ThemeUtils.isDarkMode.value;
  //   final backgroundColor =
  //       isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
  //   final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
  //   final accentColor = PdfColor(0.2, 0.6, 1);

  //   final pageFormat = PdfPageFormat.a4;
  //   final theme = pw.ThemeData.base();

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: pageFormat,
  //       theme: theme,
  //       buildBackground: (pw.Context context) => pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Container(color: backgroundColor),
  //       ),
  //       build: (pw.Context context) => [
  //         _buildHeader(osName, null, textColor, accentColor),
  //         pw.SizedBox(height: 20),
  //         for (final category in categories) ...[
  //           if (categoryShortcuts[category]!.isNotEmpty) ...[
  //             _buildCategorySection(
  //               category,
  //               osName,
  //               textColor,
  //               accentColor,
  //               categoryShortcuts[category]!,
  //             ),
  //             pw.SizedBox(height: 20),
  //           ],
  //         ],
  //       ],
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   String fileName = '${osName.replaceAll(' ', '_')}_shortcuts';
  //   final file = File('${output.path}/$fileName.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   return file;
  // }
  // Future<File> generateAllOSPdf() async {
  //   // Fetch all OS names/types
  //   final operatingSystems = await _shortcutController.getAllOS();

  //   final pdf = pw.Document();

  //   final isDarkMode = ThemeUtils.isDarkMode.value;
  //   final backgroundColor =
  //       isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
  //   final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
  //   final accentColor = PdfColor(0.2, 0.6, 1);

  //   final pageFormat = PdfPageFormat.a4;
  //   final theme = pw.ThemeData.base();

  //   // Create a separate page for each OS to avoid TooManyPagesException
  //   for (final os in operatingSystems) {
  //     // Get categories and shortcuts for this OS
  //     final categories = await _shortcutController.getAllCategoriesByOS(os);
  //     Map<String, List<ShortcutModel>> categoryShortcuts = {};

  //     // Only process categories that have shortcuts
  //     List<String> validCategories = [];
  //     for (final category in categories) {
  //       final shortcuts =
  //           await _shortcutController.getShortcutsByCategoryAndOS(category, os);
  //       if (shortcuts.isNotEmpty) {
  //         categoryShortcuts[category] = shortcuts;
  //         validCategories.add(category);
  //       }
  //     }

  //     // Skip OS if no shortcuts found
  //     if (validCategories.isEmpty) continue;

  //     // Add a page for this OS
  //     // pdf.addPage(
  //     //   pw.MultiPage(
  //     //     pageFormat: pageFormat,
  //     //     theme: theme,
  //     //     buildBackground: (pw.Context context) => pw.FullPage(
  //     //       ignoreMargins: true,
  //     //       child: pw.Container(color: backgroundColor),
  //     //     ),
  //     //     header: (context) => _buildAppHeader(
  //     //       '$os Shortcuts',
  //     //       textColor,
  //     //       accentColor,
  //     //     ),
  //     //     build: (context) => [
  //     //       pw.SizedBox(height: 20),
  //     //       for (final category in validCategories) ...[
  //     //         _buildCategorySection(
  //     //           category,
  //     //           os,
  //     //           textColor,
  //     //           accentColor,
  //     //           categoryShortcuts[category]!,
  //     //         ),
  //     //         pw.SizedBox(height: 20),
  //     //       ],
  //     //     ],
  //     //     // Set a reasonable maxPages value to avoid TooManyPagesException
  //     //     maxPages: 100,
  //     //   ),
  //     // );
  //     final pageTheme = pw.PageTheme(
  //       pageFormat: pageFormat,
  //       buildBackground: (pw.Context ctx) => pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Container(color: backgroundColor),
  //       ),
  //     );

  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageTheme: pageTheme,
  //         // header must explicitly use pw.Context to avoid BuildContext collision
  //         header: (pw.Context pdfContext) => _buildAppHeader(
  //           '$os Shortcuts',
  //           textColor,
  //           accentColor,
  //         ),
  //         // and build must explicitly use pw.Context
  //         build: (pw.Context pdfContext) {
  //           final List<pw.Widget> widgets = [];
  //           widgets.add(pw.SizedBox(height: 20));

  //           for (final category in validCategories) {
  //             final shortcuts = categoryShortcuts[category]!;

  //             const int chunkSize = 30;
  //             for (var i = 0; i < shortcuts.length; i += chunkSize) {
  //               final chunk = shortcuts.sublist(
  //                 i,
  //                 i + chunkSize > shortcuts.length
  //                     ? shortcuts.length
  //                     : i + chunkSize,
  //               );

  //               // Add category title only on first chunk
  //               if (i == 0) {
  //                 widgets.add(
  //                   pw.Text(
  //                     category,
  //                     style: pw.TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: textColor,
  //                     ),
  //                   ),
  //                 );
  //                 widgets.add(pw.SizedBox(height: 10));
  //               }

  //               // _buildCategorySection must return a pw.Widget
  //               widgets.add(
  //                 _buildCategorySection(
  //                   category,
  //                   os,
  //                   textColor,
  //                   accentColor,
  //                   chunk,
  //                 ),
  //               );

  //               widgets.add(pw.SizedBox(height: 20));
  //             }
  //           }

  //           return widgets;
  //         },
  //         // optional safety cap
  //         maxPages: 100,
  //       ),
  //     );
  //   }

  //   final output = await getTemporaryDirectory();
  //   String fileName = 'all_os_shortcuts';
  //   final file = File('${output.path}/$fileName.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   return file;
  // }
  Future<File> generateAllOSPdf() async {
    final operatingSystems = await _shortcutController.getAllOS();

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);
    final pageFormat = PdfPageFormat.a4;

    for (final osName in operatingSystems) {
      final categories = await _shortcutController.getAllCategoriesByOS(osName);
      Map<String, List<ShortcutModel>> categoryShortcuts = {};

      List<String> validCategories = [];
      for (final category in categories) {
        final shortcuts = await _shortcutController
            .getShortcutsByCategoryAndOS(category, osName, appName: null);
        if (shortcuts.isNotEmpty) {
          categoryShortcuts[category] = shortcuts;
          validCategories.add(category);
        }
      }

      if (validCategories.isEmpty) continue;

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: pageFormat,
            buildBackground: (pw.Context ctx) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: backgroundColor),
            ),
          ),
          header: (pw.Context ctx) => _buildAppHeader(
            '$osName Shortcuts',
            textColor,
            accentColor,
          ),
          build: (pw.Context ctx) {
            final List<pw.Widget> widgets = [];

            for (final category in validCategories) {
              widgets.add(
                _buildCategorySection(
                  category,
                  osName,
                  textColor,
                  accentColor,
                  categoryShortcuts[category]!,
                ),
              );
              widgets.add(pw.SizedBox(height: 20));
            }

            return widgets;
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/all_os_shortcuts.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
  //1
  // Future<File> generateOSPdf(String osName, String osType) async {
  //   // Get all categories for this OS
  //   final categories = await _shortcutController.getAllCategoriesByOS(osType);

  //   // Get shortcuts for each category
  //   Map<String, List<ShortcutModel>> categoryShortcuts = {};
  //   List<String> validCategories = [];

  //   for (final category in categories) {
  //     final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
  //       category,
  //       osType,
  //     );

  //     // Only include categories with shortcuts
  //     if (shortcuts.isNotEmpty) {
  //       categoryShortcuts[category] = shortcuts;
  //       validCategories.add(category);
  //     }
  //   }

  //   // Check if we have any valid categories with shortcuts
  //   if (validCategories.isEmpty) {
  //     throw Exception('No shortcuts found for $osName');
  //   }

  //   final pdf = pw.Document();

  //   // Get current theme state directly when generating PDF
  //   final isDarkMode = ThemeUtils.isDarkMode.value;
  //   final backgroundColor =
  //       isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
  //   final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
  //   final accentColor = PdfColor(0.2, 0.6, 1);

  //   final pageFormat = PdfPageFormat.a4;
  //   final theme = pw.ThemeData.base();

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: pageFormat,
  //       theme: theme,
  //       buildBackground: (pw.Context context) => pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Container(color: backgroundColor),
  //       ),
  //       build: (pw.Context context) => [
  //         _buildHeader(osName, null, textColor, accentColor),
  //         pw.SizedBox(height: 20),
  //         for (final category in validCategories) ...[
  //           _buildCategorySection(
  //             category,
  //             osName,
  //             textColor,
  //             accentColor,
  //             categoryShortcuts[category]!,
  //           ),
  //           pw.SizedBox(height: 20),
  //         ],
  //       ],
  //       // Set a reasonable maxPages value to avoid TooManyPagesException
  //       maxPages: 100,
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   String fileName = '${osName.replaceAll(' ', '_')}_shortcuts';
  //   final file = File('${output.path}/$fileName.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   return file;
  // }
  //2
  // Future<File> generateOSPdf(String osName, String osType) async {
  //   print('Generating PDF for OS: $osName ($osType)');

  //   // Get all categories for this OS
  //   final categories = await _shortcutController.getAllCategoriesByOS(osType);
  //   print('Found ${categories.length} categories for $osName');

  //   // Get shortcuts for each category
  //   Map<String, List<ShortcutModel>> categoryShortcuts = {};
  //   List<String> validCategories = [];

  //   for (final category in categories) {
  //     final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
  //       category,
  //       osType,
  //     );

  //     print('Category "$category" has ${shortcuts.length} shortcuts');

  //     // Only include categories with shortcuts
  //     if (shortcuts.isNotEmpty) {
  //       categoryShortcuts[category] = shortcuts;
  //       validCategories.add(category);
  //     }
  //   }

  //   // Check if we have any valid categories with shortcuts
  //   if (validCategories.isEmpty) {
  //     throw Exception('No shortcuts found for $osName');
  //   }

  //   print('Found ${validCategories.length} valid categories with shortcuts');

  //   final pdf = pw.Document();

  //   // Get current theme state directly when generating PDF
  //   final isDarkMode = ThemeUtils.isDarkMode.value;
  //   final backgroundColor =
  //       isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
  //   final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
  //   final accentColor = PdfColor(0.2, 0.6, 1);

  //   final pageFormat = PdfPageFormat.a4;
  //   final theme = pw.ThemeData.base();

  //   final pageTheme = pw.PageTheme(
  //     pageFormat: pageFormat,
  //     buildBackground: (pw.Context ctx) => pw.FullPage(
  //       ignoreMargins: true,
  //       child: pw.Container(color: backgroundColor),
  //     ),
  //   );

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: pageFormat,
  //       theme: theme,
  //       buildBackground: (pw.Context context) => pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Container(color: backgroundColor),
  //       ),
  //       build: (pw.Context context) {
  //         final List<pw.Widget> widgets = [];

  //         // Add header
  //         widgets.add(_buildHeader(osName, null, textColor, accentColor));
  //         widgets.add(pw.SizedBox(height: 20));

  //         // Add each category section
  //         for (final category in validCategories) {
  //           widgets.add(
  //             _buildCategorySection(
  //               category,
  //               osName,
  //               textColor,
  //               accentColor,
  //               categoryShortcuts[category]!,
  //             ),
  //           );
  //           widgets.add(pw.SizedBox(height: 20));
  //         }

  //         return widgets;
  //       },
  //       // Set a reasonable maxPages value to avoid TooManyPagesException
  //       maxPages: 100,
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   String fileName = '${osName.replaceAll(' ', '_')}_shortcuts';
  //   final file = File('${output.path}/$fileName.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   print('PDF generated successfully: ${file.path}');
  //   return file;
  // }

  Future<File> generateOSPdf(String osName, String osType) async {
    print('Generating PDF for OS: $osName ($osType)');

    final categories = await _shortcutController.getAllCategoriesByOS(osType);
    print('Found ${categories.length} categories for $osName');

    Map<String, List<ShortcutModel>> categoryShortcuts = {};
    List<String> validCategories = [];

    for (final category in categories) {
      final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
        category,
        osType,
        appName: null,
      );

      print('Category "$category" has ${shortcuts.length} shortcuts');

      if (shortcuts.isNotEmpty) {
        categoryShortcuts[category] = shortcuts;
        validCategories.add(category);
      }
    }

    if (validCategories.isEmpty) {
      throw Exception('No shortcuts found for $osName');
    }

    print('Found ${validCategories.length} valid categories with shortcuts');

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);

    final pageFormat = PdfPageFormat.a4;

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(
          color: backgroundColor,
          width: PdfPageFormat.a4.width,
          height: PdfPageFormat.a4.height,
        ),
      ),
      margin: const pw.EdgeInsets.all(24),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (pw.Context context) =>
            _buildHeader(osName, null, textColor, accentColor),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(color: textColor, fontSize: 10),
            ),
          );
        },
        build: (pw.Context context) {
          final widgets = <pw.Widget>[];
          widgets.add(pw.SizedBox(height: 20));

          for (final category in validCategories) {
            print(
                'Adding category $category with ${categoryShortcuts[category]!.length} shortcuts');
            if (categoryShortcuts[category]!.isNotEmpty) {
              widgets.add(
                _buildCategorySection(
                  category,
                  osName,
                  textColor,
                  accentColor,
                  categoryShortcuts[category]!,
                ),
              );
              widgets.add(pw.SizedBox(height: 10));
            }
          }

          return widgets;
        },
        maxPages: 200,
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName = '${osName.replaceAll(' ', '_')}_shortcuts.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    print('PDF generated successfully: ${file.path}');
    return file;
  }

  // Future<File> generateOSPdf(String osName, String osType) async {
  //   // Get all categories for this OS
  //   final categories = await _shortcutController.getAllCategoriesByOS(osType);

  //   Map<String, List<ShortcutModel>> categoryShortcuts = {};
  //   List<String> validCategories = [];

  //   for (final category in categories) {
  //     final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
  //       category,
  //       osType,
  //     );

  //     if (shortcuts.isNotEmpty) {
  //       categoryShortcuts[category] = shortcuts;
  //       validCategories.add(category);
  //     }
  //   }

  //   if (validCategories.isEmpty) {
  //     throw Exception('No shortcuts found for $osName');
  //   }

  //   final pdf = pw.Document();

  //   final isDarkMode = ThemeUtils.isDarkMode.value;
  //   final backgroundColor =
  //       isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
  //   final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
  //   final accentColor = PdfColor(0.2, 0.6, 1);

  //   final pageFormat = PdfPageFormat.a4;

  //   final pageTheme = pw.PageTheme(
  //     pageFormat: pageFormat,
  //     buildBackground: (pw.Context ctx) => pw.FullPage(
  //       ignoreMargins: true,
  //       child: pw.Container(color: backgroundColor),
  //     ),
  //   );

  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageTheme: pageTheme,
  //       header: (pw.Context pdfContext) => _buildHeader(
  //         osName,
  //         null,
  //         textColor,
  //         accentColor,
  //       ),
  //       build: (pw.Context pdfContext) {
  //         final List<pw.Widget> widgets = [];
  //         widgets.add(pw.SizedBox(height: 20));

  //         for (final category in validCategories) {
  //           widgets.add(
  //             _buildCategorySection(
  //               category,
  //               osName,
  //               textColor,
  //               accentColor,
  //               categoryShortcuts[category]!,
  //             ),
  //           );
  //           widgets.add(pw.SizedBox(height: 20));
  //         }

  //         return widgets;
  //       },
  //       maxPages: 100,
  //     ),
  //   );

  //   final output = await getTemporaryDirectory();
  //   final fileName = '${osName.replaceAll(' ', '_')}_shortcuts';
  //   final file = File('${output.path}/$fileName.pdf');
  //   await file.writeAsBytes(await pdf.save());

  //   return file;
  // }

  Future<File> generateBrowserPdf(String browserName) async {
    print('Generating PDF for Browser: $browserName');

    final categories = await _shortcutController.getAllCategories(browserName);
    print('Found ${categories.length} categories for $browserName');

    Map<String, List<ShortcutModel>> categoryShortcuts = {};
    List<String> validCategories = [];

    for (final category in categories) {
      final operatingSystems = await _shortcutController.getAllOS();
      List<ShortcutModel> allShortcuts = [];

      for (final osType in operatingSystems) {
        final shortcuts = await _shortcutController.getShortcutsByCategoryAndOS(
          category,
          osType,
          appName: browserName,
        );
        allShortcuts.addAll(shortcuts);
      }

      final shortcuts = allShortcuts;

      print('Category "$category" has ${shortcuts.length} shortcuts');

      if (shortcuts.isNotEmpty) {
        categoryShortcuts[category] = shortcuts;
        validCategories.add(category);
      }
    }

    if (validCategories.isEmpty) {
      throw Exception('No shortcuts found for $browserName');
    }

    print('Found ${validCategories.length} valid categories with shortcuts');

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);

    final pageFormat = PdfPageFormat.a4;

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData(),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: backgroundColor),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) =>
            _buildHeader(browserName, null, textColor, accentColor),
        build: (pw.Context context) => [
          _buildHeader(browserName, null, textColor, accentColor),
          pw.SizedBox(height: 20),
          ...validCategories.map(
            (category) => _buildCategorySection(
              category,
              browserName,
              textColor,
              accentColor,
              categoryShortcuts[category]!,
            ),
          ),
        ],
        maxPages: 200,
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName = '${browserName.replaceAll(' ', '_')}_shortcuts.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    print('PDF generated successfully: ${file.path}');
    return file;
  }

  Future<File> generateAllBrowsersPdf() async {
    print('Generating PDF for All Browsers');

    final browsers = await _shortcutController.getAllBrowsers();
    print('Found ${browsers.length} browsers');

    final pdf = pw.Document();

    final isDarkMode = ThemeUtils.isDarkMode.value;
    final backgroundColor =
        isDarkMode ? PdfColor(0.1, 0.1, 0.1) : PdfColor(1, 1, 1);
    final textColor = isDarkMode ? PdfColor(1, 1, 1) : PdfColor(0, 0, 0);
    final accentColor = PdfColor(0.2, 0.6, 1);

    final pageFormat = PdfPageFormat.a4;

    final pageTheme = pw.PageTheme(
      pageFormat: pageFormat,
      buildBackground: (pw.Context context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(
          color: backgroundColor,
          width: PdfPageFormat.a4.width,
          height: PdfPageFormat.a4.height,
        ),
      ),
      margin: const pw.EdgeInsets.all(24),
    );

    final List<pw.Widget> content = [];
    // content.add(pw.Header(
    //   level: 0,
    //   child: pw.Text(
    //     'All Browser Shortcuts',
    //     style: pw.TextStyle(
    //       fontSize: 24,
    //       fontWeight: pw.FontWeight.bold,
    //       color: accentColor,
    //     ),
    //   ),
    // ));
    // content.add(pw.SizedBox(height: 20));

    for (final browser in browsers) {
      print('Processing browser: $browser');

      final categories = await _shortcutController.getAllCategories(browser);
      Map<String, List<ShortcutModel>> categoryShortcuts = {};
      List<String> validCategories = [];

      for (final category in categories) {
        final shortcuts =
            await _shortcutController.getShortcutsByCategoryAndBrowser(
          category,
          browser,
        );

        if (shortcuts.isNotEmpty) {
          categoryShortcuts[category] = shortcuts;
          validCategories.add(category);
        }
      }

      if (validCategories.isEmpty) {
        print('Skipping $browser - no shortcuts found');
        continue;
      }

      print('Adding $browser with ${validCategories.length} categories');

      content.add(pw.Header(
        level: 1,
        child: pw.Text(
          browser,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: textColor,
          ),
        ),
      ));
      content.add(pw.SizedBox(height: 15));

      for (final category in validCategories) {
        content.add(_buildCategorySection(
          category,
          browser,
          textColor,
          accentColor,
          categoryShortcuts[category]!,
        ));
        content.add(pw.SizedBox(height: 10));
      }

      if (browser != browsers.last) {
        content.add(pw.SizedBox(height: 20));
        content.add(pw.Divider());
        content.add(pw.SizedBox(height: 20));
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (pw.Context context) =>
            _buildAppHeader('Browser Shortcuts', textColor, accentColor),
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(color: textColor, fontSize: 10),
            ),
          );
        },
        build: (pw.Context context) => content,
        maxPages: 500,
      ),
    );

    final output = await getTemporaryDirectory();
    final fileName = 'all_browsers_shortcuts.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    print('All browsers PDF generated successfully: ${file.path}');
    return file;
  }
}
