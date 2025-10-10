import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class AppsPage extends GetView<AppsController> {
  final ThemeController themeController = Get.find<ThemeController>();
  AppsPage({Key? key}) : super(key: key) {
    _pdfService = Get.find<PdfService>();
  }

  late final PdfService _pdfService;
  final RxBool _isGeneratingPdf = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? AppTheme.darkBackground
          : AppTheme.lightBackground,
      body: Obx(() {
        final apps = controller.apps;

        if (apps.isEmpty) {
          return _buildEmptyState();
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeaderSection(),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildAppCard(apps[index], index),
                  childCount: apps.length,
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: themeController.isDarkMode
                  ? AppTheme.darkSurface.withOpacity(0.5)
                  : AppTheme.lightSurface.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (themeController.isDarkMode
                          ? Colors.black
                          : AppTheme.lightSecondaryText)
                      .withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.apps_rounded,
              size: 64,
              color: themeController.isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Apps Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode
                  ? AppTheme.darkPrimaryText
                  : AppTheme.lightPrimaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apps will appear here when available',
            style: TextStyle(
              fontSize: 16,
              color: themeController.isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.apps_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Discover keyboard shortcuts for your favorite apps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeController.isDarkMode
                      ? AppTheme.darkPrimaryText
                      : AppTheme.lightPrimaryText,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppCard(AppModel app, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => controller.navigateToCategoryPage(app.name),
        child: Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(16), // Reduced from 20
            border: Border.all(
              color: themeController.isDarkMode
                  ? AppTheme.darkBorder.withOpacity(0.3)
                  : AppTheme.lightBorder.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: themeController.isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : AppTheme.lightSecondaryText.withOpacity(0.08),
                blurRadius: 12, // Reduced from 16
                offset: const Offset(0, 3), // Reduced from 4
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: AppTheme.primaryColor.withOpacity(0.1),
              highlightColor: AppTheme.primaryColor.withOpacity(0.05),
              onTap: () => controller.navigateToCategoryPage(app.name),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.primaryColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: app.svgIconPath != null
                              ? SvgPicture.asset(
                                  app.svgIconPath!,
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    AppTheme.primaryColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Icon(
                                  app.icon,
                                  color: AppTheme.primaryColor,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      flex: 2,
                      child: Text(
                        app.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: themeController.isDarkMode
                              ? AppTheme.darkPrimaryText
                              : AppTheme.lightPrimaryText,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Shortcuts',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  void _showPdfOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? AppTheme.darkSurface
              : AppTheme.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: themeController.isDarkMode
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
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: themeController.isDarkMode
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
                      color: themeController.isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how you want to export your shortcuts',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode
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
                      _generateAndShareAllAppsPdf();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildPdfOption(
                    icon: Icons.preview_rounded,
                    title: 'Preview PDF',
                    subtitle: 'View PDF before sharing',
                    onTap: () {
                      Get.back();
                      _previewAllAppsPdf();
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
        color: themeController.isDarkMode
            ? AppTheme.darkSurfaceVariant.withOpacity(0.5)
            : AppTheme.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeController.isDarkMode
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
                          color: themeController.isDarkMode
                              ? AppTheme.darkPrimaryText
                              : AppTheme.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeController.isDarkMode
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
                  color: themeController.isDarkMode
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

  Future<void> _generateAndShareAllAppsPdf() async {
    try {
      _isGeneratingPdf.value = true;
      _showLoadingDialog(
          'Generating PDF', 'Creating your shortcuts document...');

      final pdfFile = await _pdfService.generateAllAppsPdf();
      Get.back();
      await _pdfService.sharePdf(pdfFile);
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Failed to generate PDF: $e');
    } finally {
      _isGeneratingPdf.value = false;
    }
  }

  Future<void> _previewAllAppsPdf() async {
    try {
      _isGeneratingPdf.value = true;
      _showLoadingDialog('Generating PDF', 'Preparing preview...');

      final pdfFile = await _pdfService.generateAllAppsPdf();
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
            color: themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeController.isDarkMode
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
                  color: themeController.isDarkMode
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
                  color: themeController.isDarkMode
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
}
