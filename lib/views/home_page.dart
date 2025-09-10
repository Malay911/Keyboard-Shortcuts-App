import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        endDrawer: const AppDrawer(),
        extendBodyBehindAppBar: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
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
                  color:
                      (isDarkMode ? AppTheme.darkSurface : AppTheme.primaryColor)
                          .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [
                            AppTheme.darkSurface,
                            AppTheme.darkSurface.withOpacity(0.9),
                          ]
                        : [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.9),
                          ],
                  ),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isDarkMode
                                ? AppTheme.darkPrimaryText
                                : Colors.white)
                            .withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard,
                      color:
                          isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.appTitle,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppTheme.darkPrimaryText
                              : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Manage your shortcuts',
                        style: TextStyle(
                          color: (isDarkMode
                                  ? AppTheme.darkPrimaryText
                                  : Colors.white)
                              .withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Builder(
                  builder: (context) => Container(
                    margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                              .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (isDarkMode
                                ? AppTheme.darkPrimaryText
                                : Colors.white)
                            .withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      color:
                          isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                            .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (isDarkMode
                              ? AppTheme.darkPrimaryText
                              : Colors.white)
                          .withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: TabBar(
                      controller: controller.tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: (isDarkMode
                                ? AppTheme.darkPrimaryText
                                : Colors.white)
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tabs: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 2),
                          child: const Tab(
                            height: 32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.apps_rounded, size: 16),
                                SizedBox(height: 2),
                                Text(
                                  StringConstants.tabApps,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 2),
                          child: Tab(
                            height: 32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.computer_rounded, size: 16),
                                const SizedBox(height: 2),
                                SizedBox(
                                  width: 50,
                                  height: 14,
                                  child: Marquee(
                                    text: StringConstants.tabOS,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    blankSpace: 15.0,
                                    velocity: 20.0,
                                    pauseAfterRound:
                                        const Duration(seconds: 1),
                                    startPadding: 3.0,
                                    accelerationDuration:
                                        const Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        const Duration(milliseconds: 500),
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 2),
                          child: const Tab(
                            height: 32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.public_rounded, size: 16),
                                SizedBox(height: 2),
                                Text(
                                  StringConstants.tabBrowsers,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      indicatorColor: Colors.transparent,
                      labelColor: isDarkMode
                          ? AppTheme.darkPrimaryText
                          : Colors.white,
                      unselectedLabelColor:
                          (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                              .withOpacity(0.8),
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.w600),
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w500),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
          child: GetBuilder<HomeController>(
            builder: (_) => Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppTheme.darkBackground
                    : AppTheme.lightBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    _buildTabContent(AppsPage()),
                    _buildTabContent(OSPage()),
                    _buildTabContent(BrowserPage()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
  }
}
