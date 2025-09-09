// // import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
// // import 'package:keyboard_shortcuts_app/controllers/browser_controller.dart';
// // import 'package:flutter_svg/flutter_svg.dart';

// // class BrowserPage extends GetView<BrowserController> {
// //   const BrowserPage({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

// //     return Obx(() {
// //       final browsers = controller.browsers;

// //       if (browsers.isEmpty) {
// //         return const Center(
// //           child: Text('No browsers available'),
// //         );
// //       }

// //       return ListView.separated(
// //         padding: const EdgeInsets.all(16),
// //         itemCount: browsers.length,
// //         separatorBuilder: (context, index) => const Divider(height: 1),
// //         itemBuilder: (context, index) {
// //           final browser = browsers[index];
// //           return ListTile(
// //             leading: browser.svgIconPath != null
// //                 ? SvgPicture.asset(
// //                     browser.svgIconPath!,
// //                     width: 28,
// //                     height: 28,
// //                     colorFilter: ColorFilter.mode(
// //                       AppTheme.primaryColor,
// //                       BlendMode.srcIn,
// //                     ),
// //                   )
// //                 : Icon(
// //                     browser.icon,
// //                     color: AppTheme.primaryColor,
// //                     size: 28,
// //                   ),
// //             title: Text(
// //               browser.name,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 18,
// //               ),
// //             ),
// //             contentPadding:
// //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             onTap: () => controller.navigateToCategoryPage(browser.name),
// //           );
// //         },
// //       );
// //     });
// //   }
// // }

// import 'package:keyboard_shortcuts_app/services/pdf_service.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
// import 'package:keyboard_shortcuts_app/controllers/browser_controller.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class BrowserPage extends GetView<BrowserController> {
//   const BrowserPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: Obx(() {
//         final browsers = controller.browsers;

//         if (browsers.isEmpty) {
//           return const Center(
//             child: Text('No browsers available'),
//           );
//         }

//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: browsers.length,
//           separatorBuilder: (context, index) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final browser = browsers[index];
//             return ListTile(
//               leading: browser.svgIconPath != null
//                   ? SvgPicture.asset(
//                       browser.svgIconPath!,
//                       width: 28,
//                       height: 28,
//                       colorFilter: ColorFilter.mode(
//                         AppTheme.primaryColor,
//                         BlendMode.srcIn,
//                       ),
//                     )
//                   : Icon(
//                       browser.icon,
//                       color: AppTheme.primaryColor,
//                       size: 28,
//                     ),
//               title: Text(
//                 browser.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               onTap: () => controller.navigateToCategoryPage(browser.name),
//             );
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showPdfOptions,
//         backgroundColor:
//             isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground,
//         tooltip: 'Export PDF',
//         child: Icon(
//           Icons.picture_as_pdf,
//           color:
//               isDarkMode ? AppTheme.darkPrimaryText : AppTheme.lightPrimaryText,
//         ),
//       ),
//     );
//   }
// }

// void _showPdfOptions() {
//   Get.bottomSheet(
//     Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Get.isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Export PDF',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Get.isDarkMode
//                   ? AppTheme.darkPrimaryText
//                   : AppTheme.lightPrimaryText,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ListTile(
//             leading: const Icon(Icons.share),
//             title: const Text('Generate and Share'),
//             onTap: () {
//               Get.back();
//               _generateAndSharePdf();
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.preview),
//             title: const Text('Preview PDF'),
//             onTap: () {
//               Get.back();
//               _previewPdf();
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Future<void> _generateAndSharePdf() async {
//   try {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Generating PDF...'),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );

//     final pdfService = PdfService();
//     final pdfFile = await pdfService.generateAllBrowsersPdf();

//     Get.back();
//     await pdfService.sharePdf(pdfFile);
//   } catch (e) {
//     Get.back();
//     Get.snackbar(
//       'Error',
//       'Failed to generate or share PDF: $e',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }

// Future<void> _previewPdf() async {
//   try {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Generating PDF...'),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );

//     final pdfService = PdfService();
//     final pdfFile = await pdfService.generateAllBrowsersPdf();

//     Get.back();
//     await pdfService.previewPdf(pdfFile);
//   } catch (e) {
//     Get.back();
//     Get.snackbar(
//       'Error',
//       'Failed to preview PDF: $e',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }

import 'package:keyboard_shortcuts_app/services/pdf_service.dart';
import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'package:keyboard_shortcuts_app/controllers/browser_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrowserPage extends GetView<BrowserController> {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: themeController.isDarkMode
          ? AppTheme.darkBackground
          : AppTheme.lightBackground,
      body: Obx(() {
        final browsers = controller.browsers;

        if (browsers.isEmpty) {
          return _buildEmptyState(themeController);
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeaderSection(themeController),
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
                  (context, index) => TweenAnimationBuilder<double>(
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
                    child: _buildBrowserCard(
                        browsers[index], index, themeController),
                  ),
                  childCount: browsers.length,
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: _buildFloatingActionButton(themeController),
    );
  }

  Widget _buildEmptyState(ThemeController themeController) {
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
              Icons.public_rounded,
              size: 64,
              color: themeController.isDarkMode
                  ? AppTheme.darkSecondaryText
                  : AppTheme.lightSecondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Browsers Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode
                  ? AppTheme.darkPrimaryText
                  : AppTheme.lightPrimaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No browsers are available at the moment',
            textAlign: TextAlign.center,
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

  Widget _buildHeaderSection(ThemeController themeController) {
    // return Container(
    //   margin: const EdgeInsets.fromLTRB(20, 20, 20, 24),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           Container(
    //             padding: const EdgeInsets.all(12),
    //             decoration: BoxDecoration(
    //               gradient: LinearGradient(
    //                 begin: Alignment.topLeft,
    //                 end: Alignment.bottomRight,
    //                 colors: [
    //                   AppTheme.primaryColor,
    //                   AppTheme.primaryColor.withOpacity(0.8),
    //                 ],
    //               ),
    //               borderRadius: BorderRadius.circular(16),
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: AppTheme.primaryColor.withOpacity(0.3),
    //                   blurRadius: 12,
    //                   offset: const Offset(0, 4),
    //                 ),
    //               ],
    //             ),
    //             child: const Icon(
    //               Icons.public_rounded,
    //               color: Colors.white,
    //               size: 28,
    //             ),
    //           ),
    //           const SizedBox(width: 16),
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   'Web Browsers',
    //                   style: TextStyle(
    //                     fontSize: 28,
    //                     fontWeight: FontWeight.bold,
    //                     color: themeController.isDarkMode
    //                         ? AppTheme.darkPrimaryText
    //                         : AppTheme.lightPrimaryText,
    //                     letterSpacing: -0.5,
    //                   ),
    //                 ),
    //                 const SizedBox(height: 4),
    //                 Text(
    //                   'Navigate the web faster with keyboard shortcuts',
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                     color: themeController.isDarkMode
    //                         ? AppTheme.darkSecondaryText
    //                         : AppTheme.lightSecondaryText,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [
        //       AppTheme.primaryColor.withOpacity(0.08),
        //       AppTheme.primaryColor.withOpacity(0.03),
        //     ],
        //   ),
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(
        //     color: AppTheme.primaryColor.withOpacity(0.15),
        //     width: 1,
        //   ),
        // ),
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
                Icons.public_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Navigate the web faster with keyboard shortcuts',
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

  Widget _buildBrowserCard(
      dynamic browser, int index, ThemeController themeController) {
    return GestureDetector(
      onTap: () => controller.navigateToCategoryPage(browser.name),
      child: Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? AppTheme.darkSurface
              : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
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
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            splashColor: AppTheme.primaryColor.withOpacity(0.1),
            highlightColor: AppTheme.primaryColor.withOpacity(0.05),
            onTap: () => controller.navigateToCategoryPage(browser.name),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Browser Icon Container
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
                        child: browser.svgIconPath != null
                            ? SvgPicture.asset(
                                browser.svgIconPath!,
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              )
                            : Icon(
                                browser.icon,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Browser Name
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          browser.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode
                                ? AppTheme.darkPrimaryText
                                : AppTheme.lightPrimaryText,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Browser',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeController themeController) {
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
        onPressed: () => _showPdfOptions(themeController),
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

  void _showPdfOptions(ThemeController themeController) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode
              ? AppTheme.darkSurface
              : AppTheme.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: themeController.isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.lightSecondaryText.withOpacity(0.1),
              blurRadius: 16,
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
                color: themeController.isDarkMode
                    ? AppTheme.darkSecondaryText.withOpacity(0.3)
                    : AppTheme.lightSecondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Export Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeController.isDarkMode
                          ? AppTheme.darkPrimaryText
                          : AppTheme.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPdfOption(
                    icon: Icons.picture_as_pdf_rounded,
                    title: 'Generate PDF and Share',
                    subtitle: 'Create and share PDF of all browser shortcuts',
                    onTap: () {
                      Get.back();
                      _generateAndSharePdf(themeController);
                    },
                    themeController: themeController,
                  ),
                  const SizedBox(height: 12),
                  _buildPdfOption(
                    icon: Icons.preview_rounded,
                    title: 'Preview PDF',
                    subtitle: 'View PDF before sharing',
                    onTap: () {
                      Get.back();
                      _previewPdf(themeController);
                    },
                    themeController: themeController,
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
    required ThemeController themeController,
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
            color: themeController.isDarkMode
                ? AppTheme.darkPrimaryText
                : AppTheme.lightPrimaryText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: themeController.isDarkMode
                ? AppTheme.darkSecondaryText
                : AppTheme.lightSecondaryText,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Future<void> _generateAndSharePdf(ThemeController themeController) async {
    try {
      _showLoadingDialog(themeController);

      final pdfService = Get.find<PdfService>();
      final pdfFile = await pdfService.generateAllBrowsersPdf();
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

  Future<void> _previewPdf(ThemeController themeController) async {
    try {
      _showLoadingDialog(themeController);

      final pdfService = Get.find<PdfService>();
      final pdfFile = await pdfService.generateAllBrowsersPdf();
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

  void _showLoadingDialog(ThemeController themeController) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode
                ? AppTheme.darkSurface
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.picture_as_pdf,
                      size: 28,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Generating PDF',
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
                'Please wait while we create your PDF...',
                style: TextStyle(
                  fontSize: 14,
                  color: themeController.isDarkMode
                      ? AppTheme.darkSecondaryText
                      : AppTheme.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
