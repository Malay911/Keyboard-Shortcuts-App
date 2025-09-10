import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'dart:io';

class CategoryPage extends StatefulWidget {
  final CategoryController controller;

  const CategoryPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final PdfService _pdfService = Get.find<PdfService>();
  final ThemeController _themeController = Get.find<ThemeController>();
  final RxBool _isGeneratingPdf = false.obs;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeController.isDarkMode;

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          _searchController.clear();
          widget.controller.updateSearchQuery('');
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: false,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isDarkMode
                      ? AppTheme.darkBackground
                      : AppTheme.lightBackground,
                  isDarkMode
                      ? AppTheme.darkBackground.withOpacity(0.95)
                      : AppTheme.lightBackground.withOpacity(0.95),
                ],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(isDarkMode),
                SliverToBoxAdapter(
                  child: _buildSearchSection(isDarkMode),
                ),
                SliverToBoxAdapter(
                  child: _buildCategoriesHeader(isDarkMode),
                ),
                _buildCategoriesList(isDarkMode),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
        ),
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
          title: Text(
            widget.controller.parentName,
            style: TextStyle(
              color: isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          titlePadding: const EdgeInsets.only(bottom: 20),
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

  Widget _buildSearchSection(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search Bar
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : AppTheme.lightSecondaryText.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: widget.controller.updateSearchQuery,
                style: TextStyle(
                  color: isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
                decoration: InputDecoration(
                  hintText: 'Search categories and shortcuts...',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppTheme.darkSecondaryText
                        : AppTheme.lightSecondaryText,
                  ),
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  suffixIcon: Obx(() => widget.controller.searchQuery.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(12),
                          child: IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: isDarkMode
                                  ? AppTheme.darkSecondaryText
                                  : AppTheme.lightSecondaryText,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              widget.controller.updateSearchQuery('');
                              _searchFocusNode.unfocus();
                            },
                          ),
                        )
                      : const SizedBox.shrink()),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          // Search Info
          Obx(() {
            if (widget.controller.searchQuery.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Found ${widget.controller.searchResults.length} results',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppTheme.darkSecondaryText
                        : AppTheme.lightSecondaryText,
                    fontSize: 12,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildCategoriesHeader(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.category_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                    ),
                  ),
                  Text(
                    'Choose a category to explore shortcuts',
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
      ),
    );
  }

  Widget _buildCategoriesList(bool isDarkMode) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      sliver: Obx(() {
        if (widget.controller.isSearchingShortcuts) {
          return _buildShortcutSearchResults(isDarkMode);
        }

        final categories = widget.controller.getFilteredCategories();

        if (categories.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(isDarkMode),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 100)),
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
                child: _buildCategoryCard(categories[index], index, isDarkMode),
              );
            },
            childCount: categories.length,
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.darkSurface.withOpacity(0.5)
                  : AppTheme.lightSurface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No categories found',
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
            'Try adjusting your search terms',
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

  Widget _buildCategoryCard(
      CategoryModel category, int index, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
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
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToDetails(category),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.1),
                        AppTheme.primaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: category.svgIconPath != null
                        ? SvgPicture.asset(
                            category.svgIconPath!,
                            width: 28,
                            height: 28,
                            colorFilter: ColorFilter.mode(
                              AppTheme.primaryColor,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            widget.controller.getCategoryIcon(category.name),
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AppTheme.darkPrimaryText
                              : AppTheme.lightPrimaryText,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (category.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? AppTheme.darkSecondaryText
                                : AppTheme.lightSecondaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${category.shortcuts.length} shortcuts',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
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
      child: FloatingActionButton.extended(
        onPressed: _showPdfOptions,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.picture_as_pdf_rounded),
        label: const Text(
          'Export PDF',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(CategoryModel category) {
    if (widget.controller.isApp) {
      Get.to(
        () => AppCategoryDetailsPage(
          categoryName: category.name,
          appName: widget.controller.parentName,
          osType: widget.controller.osType,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Get.to(
        () => CategoryDetailsPage(
          categoryName: category.name,
          parentName: widget.controller.parentName,
          osType: widget.controller.osType,
          isApp: false,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _showPdfOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: _themeController.isDarkMode
              ? AppTheme.darkSurface
              : AppTheme.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: _themeController.isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.lightSecondaryText.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _themeController.isDarkMode
                    ? AppTheme.darkSecondaryText.withOpacity(0.3)
                    : AppTheme.lightSecondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                children: [
                  Text(
                    'PDF Export Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _themeController.isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Export ${widget.controller.parentName} shortcuts',
                    style: TextStyle(
                      fontSize: 14,
                      color: _themeController.isDarkMode
                          ? AppTheme.darkSecondaryText
                          : AppTheme.lightSecondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPdfOption(
                    icon: Icons.share_rounded,
                    title: 'Generate & Share',
                    subtitle: 'Create PDF and share with others',
                    onTap: () {
                      Get.back();
                      _generateAndSharePdf();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPdfOption(
                    icon: Icons.preview_rounded,
                    title: 'Preview PDF',
                    subtitle: 'View PDF before sharing',
                    onTap: () {
                      Get.back();
                      _previewPdf();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildPdfOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _themeController.isDarkMode
            ? AppTheme.darkSurfaceVariant.withOpacity(0.5)
            : AppTheme.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _themeController.isDarkMode
              ? AppTheme.darkBorder.withOpacity(0.3)
              : AppTheme.lightBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
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
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _themeController.isDarkMode
                              ? AppTheme.darkPrimaryText
                              : AppTheme.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeController.isDarkMode
                              ? AppTheme.darkSecondaryText
                              : AppTheme.lightSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: _themeController.isDarkMode
                      ? AppTheme.darkSecondaryText
                      : AppTheme.lightSecondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf() async {
    try {
      _isGeneratingPdf.value = true;
      _showLoadingDialog(
          'Generating PDF', 'Creating your shortcuts document...');

      final File pdfFile;
      if (widget.controller.isApp) {
        pdfFile = await _pdfService.generateAppPdf(widget.controller.parentName,
            osType: widget.controller.osType);
      } else {
        pdfFile = await _pdfService.generateOSPdf(
          widget.controller.parentName,
          widget.controller.osType,
        );
      }

      Get.back();
      await _pdfService.sharePdf(pdfFile);
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Failed to generate PDF: $e');
    } finally {
      _isGeneratingPdf.value = false;
    }
  }

  Future<void> _previewPdf() async {
    try {
      _isGeneratingPdf.value = true;
      _showLoadingDialog('Generating PDF', 'Preparing preview...');

      final File pdfFile;
      if (widget.controller.isApp) {
        pdfFile = await _pdfService.generateAppPdf(widget.controller.parentName,
            osType: widget.controller.osType);
      } else {
        pdfFile = await _pdfService.generateOSPdf(
          widget.controller.parentName,
          widget.controller.osType,
        );
      }

      Get.back();
      await _pdfService.previewPdf(pdfFile);
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Failed to generate PDF: $e');
    } finally {
      _isGeneratingPdf.value = false;
    }
  }

  void _showLoadingDialog(String title, String subtitle) {
    Get.dialog(
      Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _themeController.isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : AppTheme.lightSecondaryText.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 24,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _themeController.isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _themeController.isDarkMode
                      ? AppTheme.darkSecondaryText
                      : AppTheme.lightSecondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.errorColor,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildShortcutSearchResults(bool isDarkMode) {
    final results = widget.controller.searchResults;

    if (results.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptySearchState(isDarkMode),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final result = results[index];
          final category = result['category'] as CategoryModel;
          final shortcuts = result['shortcuts'] as List<ShortcutModel>;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                ListTile(
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.controller.getCategoryIcon(category.name),
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                  onTap: () => _navigateToDetails(category),
                ),
                if (shortcuts.isNotEmpty) ...[
                  const Divider(height: 1),
                  ...shortcuts.map((shortcut) => ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                shortcut.action,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode
                                      ? AppTheme.darkPrimaryText
                                      : AppTheme.lightPrimaryText,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                ),
                              ),
                              child: Text(
                                shortcut.keys,
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                      )),
                ],
              ],
            ),
          );
        },
        childCount: results.length,
      ),
    );
  }

  Widget _buildEmptySearchState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: isDarkMode
                ? AppTheme.darkSecondaryText
                : AppTheme.lightSecondaryText,
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
