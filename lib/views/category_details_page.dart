import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../models/shortcut_model.dart';
import '../theme.dart';
import '../utils/constants/string_constants.dart';
import '../utils/database_helper.dart';
import '../controllers/shortcut_controller.dart';
import '../services/pdf_service.dart';
import 'dart:io';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;
  final String parentName;
  final bool isApp;
  final String osType;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryName,
    required this.parentName,
    required this.osType,
    required this.isApp,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final RxList<ShortcutModel> _shortcuts = <ShortcutModel>[].obs;
  final Map<String, bool> _bookmarkedShortcuts = {};
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final RxString _currentSearchText = ''.obs;
  final FocusNode _searchFocusNode = FocusNode();
  final ThemeController _themeController = Get.find<ThemeController>();
  final RxList<ShortcutModel> _allShortcuts = <ShortcutModel>[].obs;

  @override
  void initState() {
    super.initState();
    _loadShortcuts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadShortcuts() async {
    try {
      print(
          'Loading shortcuts for ${widget.categoryName} (${widget.parentName})');

      final shortcuts = await _dbHelper.getShortcutsByCategory(
        widget.categoryName,
        widget.osType,
        appName: widget.isApp ? widget.parentName : null,
      );

      print('Found ${shortcuts.length} shortcuts');
      if (shortcuts.isNotEmpty) {
        print('Sample shortcut: ${shortcuts.first.toMap()}');
      }

      setState(() {
        _allShortcuts.value = shortcuts; // Store all shortcuts
        _shortcuts.value = shortcuts; // Current filtered shortcuts
        _bookmarkedShortcuts.clear();
        for (var shortcut in shortcuts) {
          _bookmarkedShortcuts[shortcut.action] = false;
        }
      });
    } catch (e) {
      print('Error loading shortcuts: $e');
      setState(() {
        _allShortcuts.clear();
        _shortcuts.clear();
      });
    }
  }

  void _filterShortcuts(String query) {
    setState(() {
      if (query.isEmpty) {
        _shortcuts.value = _allShortcuts; // Reset to all shortcuts
        return;
      }

      final normalizedQuery = query.toLowerCase();
      _shortcuts.value = _allShortcuts.where((shortcut) {
        final normalizedAction = shortcut.action.toLowerCase();
        final normalizedKeys = shortcut.keys.toLowerCase();

        return normalizedAction.contains(normalizedQuery) ||
            normalizedKeys.contains(normalizedQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeController.isDarkMode;

      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
                isDarkMode
                    ? AppTheme.darkBackground.withOpacity(0.95)
                    : AppTheme.lightBackground.withOpacity(0.95),
              ],
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              _searchController.clear();
              _filterShortcuts('');
              _currentSearchText.value = '';
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(isDarkMode),
                SliverToBoxAdapter(
                  child: _buildHeaderSection(isDarkMode),
                ),
                SliverToBoxAdapter(
                  child: _buildSearchSection(isDarkMode),
                ),
                _buildShortcutsList(isDarkMode),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(isDarkMode),
      );
    });
  }

  Widget _buildSliverAppBar(bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 60,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppTheme.darkSurface,
                    AppTheme.darkSurface.withOpacity(0.95),
                  ]
                : [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? AppTheme.darkSurface : AppTheme.primaryColor)
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FlexibleSpaceBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.categoryName,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.isApp ? widget.parentName : widget.parentName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppTheme.darkSecondaryText
                      : Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          centerTitle: true,
          titlePadding: const EdgeInsets.only(bottom: 12),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
              .withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                .withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          iconSize: 18,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                .withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                  .withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            iconSize: 18,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: animation,
                  child: child,
                );
              },
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDarkMode),
                color: isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
              ),
            ),
            onPressed: _themeController.toggleTheme,
            tooltip:
                isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              widget.isApp ? Icons.apps_rounded : Icons.keyboard_rounded,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shortcuts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppTheme.darkPrimaryText
                        : AppTheme.lightPrimaryText,
                  ),
                ),
                Text(
                  'Explore ${widget.categoryName.toLowerCase()} shortcuts',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? AppTheme.darkSecondaryText
                        : AppTheme.lightSecondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? AppTheme.darkBorder.withOpacity(0.3)
                : AppTheme.lightBorder.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.1)
                  : AppTheme.lightSecondaryText.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          focusNode: _searchFocusNode,
          controller: _searchController,
          onChanged: (value) {
            _currentSearchText.value = value;
            _filterShortcuts(value);
          },
          style: TextStyle(
            color: isDarkMode
                ? AppTheme.darkPrimaryText
                : AppTheme.lightPrimaryText,
          ),
          decoration: InputDecoration(
            hintText: 'Search shortcuts...',
            hintStyle: TextStyle(
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
            suffixIcon: Obx(() => _currentSearchText.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: isDarkMode
                          ? AppTheme.darkSecondaryText
                          : AppTheme.lightSecondaryText,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _currentSearchText.value = '';
                      _filterShortcuts('');
                      _searchFocusNode.unfocus();
                    },
                  )
                : const SizedBox.shrink()),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutsList(bool isDarkMode) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      sliver: Obx(() {
        if (_shortcuts.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(isDarkMode),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 50)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: _buildShortcutItem(context, _shortcuts[index]),
              );
            },
            childCount: _shortcuts.length,
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : AppTheme.lightSecondaryText.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No shortcuts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AppTheme.darkPrimaryText
                  : AppTheme.lightPrimaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no shortcuts available for this category',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _showPdfOptions(context),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        child: const Icon(
          Icons.picture_as_pdf_rounded,
          color: Colors.white,
          size: 24,
        ),
        tooltip: 'Export PDF',
      ),
    );
  }

  Widget _buildShortcutItem(BuildContext context, ShortcutModel shortcut) {
    final isDarkMode = _themeController.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? AppTheme.darkBorder.withOpacity(0.3)
              : AppTheme.lightBorder.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : AppTheme.lightSecondaryText.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.keyboard_rounded,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    shortcut.action,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.darkSurfaceVariant.withOpacity(0.5)
                    : AppTheme.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode
                      ? AppTheme.darkBorder.withOpacity(0.3)
                      : AppTheme.lightBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                shortcut.keys,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'monospace',
                  color: isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPdfOptions(BuildContext context) {
    final isDarkMode = _themeController.isDarkMode;
    final pdfService = Get.find<PdfService>();

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.lightSecondaryText.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.darkSecondaryText
                      : AppTheme.lightSecondaryText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Export Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
              ),
              const SizedBox(height: 24),
              _buildPdfOption(
                icon: Icons.picture_as_pdf_rounded,
                title: 'Generate PDF',
                subtitle: 'Create a PDF of these shortcuts',
                onTap: () async {
                  Navigator.pop(context);
                  _generateAndSharePdf(pdfService);
                },
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 12),
              _buildPdfOption(
                icon: Icons.preview_rounded,
                title: 'Preview PDF',
                subtitle: 'Preview before sharing',
                onTap: () async {
                  Navigator.pop(context);
                  _previewPdf(pdfService);
                },
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppTheme.darkSurfaceVariant.withOpacity(0.5)
            : AppTheme.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppTheme.darkBorder.withOpacity(0.3)
              : AppTheme.lightBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDarkMode
                ? AppTheme.darkPrimaryText
                : AppTheme.lightPrimaryText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode
                ? AppTheme.darkSecondaryText
                : AppTheme.lightSecondaryText,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf(PdfService pdfService) async {
    try {
      Get.dialog(
        Container(
          decoration: BoxDecoration(
            color: _themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Generating PDF...',
                style: TextStyle(
                  color: _themeController.isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final pdfFile = await pdfService.generateCategoryPdf(
        widget.categoryName,
        widget.isApp ? widget.parentName : null,
        osType: widget.osType,
      );

      Get.back();
      await pdfService.sharePdf(pdfFile);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _previewPdf(PdfService pdfService) async {
    try {
      Get.dialog(
        Container(
          decoration: BoxDecoration(
            color: _themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Preparing preview...',
                style: TextStyle(
                  color: _themeController.isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final pdfFile = await pdfService.generateCategoryPdf(
        widget.categoryName,
        widget.isApp ? widget.parentName : null,
        osType: widget.osType,
      );

      Get.back();
      await pdfService.previewPdf(pdfFile);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to preview PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
