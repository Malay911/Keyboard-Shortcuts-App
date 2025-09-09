import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _pulseController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    _pulseController.repeat(reverse: true);

    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    await _textController.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    await _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    Get.offNamed(StringConstants.homeRoute);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
              AppTheme.darkBackground,
              AppTheme.darkSurface,
              AppTheme.darkSurfaceVariant,
            ]
                : [
              AppTheme.primaryColor,
              AppTheme.primaryLight,
              AppTheme.lightBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _logoController,
                          _pulseController,
                        ]),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value *
                                _pulseAnimation.value,
                            child: Opacity(
                              opacity: _logoOpacityAnimation.value,
                              child: _buildAppLogo(isDarkMode),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _textSlideAnimation,
                            child: Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: _buildAppTitle(isDarkMode),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return _buildProgressSection(isDarkMode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildPoweredByLogo(
                            'assets/images/ASWDC.jpg',
                            height: 70,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: _buildPoweredByLogo(
                            'assets/images/darshan_logo.png',
                            height: 70,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo(bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDarkMode
                  ? [
                AppTheme.primaryColor.withOpacity(0.2),
                Colors.transparent,
              ]
                  : [
                Colors.white.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Logo container
        Container(
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                AppTheme.darkSurface.withOpacity(0.9),
                AppTheme.darkSurface,
              ]
                  : [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (isDarkMode ? AppTheme.primaryColor : Colors.black)
                    .withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color:
                (isDarkMode ? Colors.black : Colors.white).withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/app_logo2.png',
            fit: BoxFit.contain,
          ),
        ),
        // Animated ring
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isDarkMode ? AppTheme.primaryColor : Colors.white)
                        .withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppTitle(bool isDarkMode) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDarkMode
                ? [
              AppTheme.primaryColor,
              AppTheme.primaryLight,
            ]
                : [
              Colors.white,
              Colors.white.withOpacity(0.8),
            ],
          ).createShader(bounds),
          child: Text(
            StringConstants.appTitle,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
              (isDarkMode ? Colors.white : Colors.white).withOpacity(0.2),
            ),
          ),
          child: Text(
            'Master keyboard shortcuts,\nBoost your productivity!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : Colors.white.withOpacity(0.9),
              height: 1.4,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: (isDarkMode ? Colors.white : Colors.white).withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? AppTheme.primaryColor : Colors.white,
                  ),
                ),
                Positioned(
                  left: -50 + (230 * _progressAnimation.value),
                  child: Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: (isDarkMode ? Colors.white : Colors.white).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            'Loading...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? AppTheme.darkSecondaryText
                  : Colors.white.withOpacity(0.9),
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPoweredByLogo(
      String assetPath, {
        required double height,
        required bool isDarkMode,
      }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isDarkMode ? Colors.white : Colors.white).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDarkMode ? Colors.white : Colors.white).withOpacity(0.2),
        ),
      ),
      child: Image.asset(
        assetPath,
        height: height - 12,
        fit: BoxFit.contain,
      ),
    );
  }
}