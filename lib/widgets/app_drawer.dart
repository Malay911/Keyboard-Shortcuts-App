import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Drawer(
              width: MediaQuery.of(context).size.width * 0.85,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.darkSurface,
                            AppTheme.darkSurface.withOpacity(0.95),
                            Colors.black.withOpacity(0.8),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.grey.shade50,
                            Colors.grey.shade100,
                          ],
                        ),
                ),
                child: Column(
                  children: [
                    _buildEnhancedHeader(isDarkMode),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            _buildAnimatedMenuItem(
                              icon: themeController.isDarkMode
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              title: 'Theme Mode',
                              isDarkMode: isDarkMode,
                              delay: 200,
                              trailing: _buildThemeSwitch(
                                  themeController, isDarkMode),
                            ),
                            _buildDivider(isDarkMode),
                            _buildAnimatedMenuItem(
                              icon: Icons.info_outline_rounded,
                              title: 'About Us',
                              isDarkMode: isDarkMode,
                              delay: 400,
                              onTap: () {
                                Get.back();
                                Get.to(
                                  () => const AboutUsPage(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                            ),
                            _buildAnimatedMenuItem(
                              icon: Icons.star_rounded,
                              title: 'Rate App',
                              isDarkMode: isDarkMode,
                              delay: 600,
                              onTap: _rateApp,
                            ),
                            _buildAnimatedMenuItem(
                              icon: Icons.share_rounded,
                              title: 'Share App',
                              isDarkMode: isDarkMode,
                              delay: 800,
                              onTap: _shareApp,
                            ),
                            const Spacer(),
                            _buildFooter(isDarkMode),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader(bool isDarkMode) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1A237E).withOpacity(0.9),
                  const Color(0xFF3949AB).withOpacity(0.8),
                  AppTheme.darkSurface,
                ]
              : [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withOpacity(0.8),
                  const Color(0xFF5C6BC0),
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : AppTheme.primaryColor)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: PatternPainter(isDarkMode: isDarkMode),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/app_logo2.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TweenAnimationBuilder<int>(
                    duration: const Duration(milliseconds: 1500),
                    tween: IntTween(
                        begin: 0, end: StringConstants.appTitle.length),
                    builder: (context, value, child) {
                      return Text(
                        StringConstants.appTitle.substring(0, value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: const Interval(0.5, 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: FutureBuilder<PackageInfo>(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text(
                                  'Version ...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }

                              final info = snapshot.data!;
                              return Text(
                                'Version ${info.version}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuItem({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    required int delay,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 50, 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isDarkMode
                        ? AppTheme.primaryColor.withOpacity(0.8)
                        : AppTheme.primaryColor,
                    size: 22,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color:
                        isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: trailing,
                onTap: onTap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSwitch(ThemeController themeController, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Switch(
        value: themeController.isDarkMode,
        onChanged: (value) => themeController.toggleTheme(),
        activeColor: AppTheme.primaryColor,
        inactiveThumbColor: Colors.grey,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (isDarkMode ? Colors.white : Colors.grey).withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: const Interval(0.3, 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: isDarkMode
                          ? AppTheme.primaryColor.withOpacity(0.8)
                          : AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '© ${DateTime.now().year} Darshan University',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkPrimaryText.withOpacity(0.8)
                            : Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'All Rights Reserved',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkPrimaryText.withOpacity(0.6)
                            : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkPrimaryText.withOpacity(0.6)
                            : Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    InkWell(
                      onTap: () => launchUrl(
                        Uri.parse(
                            'https://www.darshan.ac.in/DIET/ASWDC-Mobile-Apps/Privacy-Policy-General'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Made with ',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkPrimaryText.withOpacity(0.7)
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween(begin: 0.8, end: 1.2),
                      curve: Curves.easeInOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                        );
                      },
                    ),
                    Text(
                      ' in India',
                      style: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkPrimaryText.withOpacity(0.7)
                            : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.white, Colors.green],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🇮🇳',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _shareApp() async {
    const String appLink =
        'https://play.google.com/store/apps/details?id=in.ac.darshan.keyboardshortcuts';
    const String message =
        'Check out Keyboard Shortcuts App by Darshan University!\n\n$appLink';
    await Share.share(message);
  }

  Future<void> _rateApp() async {
    const String packageName = 'in.ac.darshan.keyboardshortcuts';
    final Uri playStoreUri = Uri.parse('market://details?id=$packageName');
    final Uri webPlayStoreUri =
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName');

    try {
      bool canLaunch = await canLaunchUrl(playStoreUri);
      if (canLaunch) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webPlayStoreUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open Play Store. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    }
  }
}

class PatternPainter extends CustomPainter {
  final bool isDarkMode;

  PatternPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isDarkMode ? 0.1 : 0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.15), size.height * 0.3),
        8,
        paint,
      );
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(isDarkMode ? 0.05 : 0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 10),
        Offset(size.width, size.height * i / 10),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
