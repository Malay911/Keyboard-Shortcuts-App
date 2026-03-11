import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
import 'dart:io' show Platform;
import 'dart:convert' show json, Encoding;
import 'dart:math' show sin, pi;
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  late AnimationController _floatingController;
  late AnimationController _fadeController;
  bool _isLoading = false;
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _getAppVersion();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _fadeController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = packageInfo.version;
        });
      }
    } catch (e) {
      debugPrint('Error getting app version: $e');
    }
  }

  Future<void> _sendFeedback() async {
    if (_nameController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      _showSnackBar(StringConstants.fillAllFieldsMessage);
      return;
    }

    if (!_isValidName(_nameController.text)) {
      _showSnackBar(StringConstants.invalidNameMessage);
      return;
    }

    if (!_isValidMobile(_mobileController.text)) {
      _showSnackBar(StringConstants.invalidMobileMessage);
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showSnackBar(StringConstants.invalidEmailMessage);
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final String platform = Platform.isAndroid 
          ? StringConstants.platformAndroid 
          : StringConstants.platformIOS;

      final Map<String, String> formData = {
        'AppName': StringConstants.appNameFeedback,
        'VersionNo': _version,
        'Platform': platform,
        'PersonName': _nameController.text,
        'Mobile': _mobileController.text,
        'Email': _emailController.text,
        'Message': _messageController.text,
        'Remarks': '',
      };

      final response = await http.post(
        Uri.parse(StringConstants.feedbackApiUrl),
        headers: {
          'API_KEY': StringConstants.apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
        encoding: Encoding.getByName('utf-8'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['IsResult'] == 1) {
          _showSnackBar(StringConstants.successMessage, isSuccess: true);
          _clearForm();
        } else {
          _showSnackBar('${StringConstants.errorPrefix}${jsonResponse['Message']}');
        }
      } else {
        _showSnackBar('${StringConstants.failedToSendPrefix}${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('${StringConstants.errorPrefix}$e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^\d{10}$').hasMatch(mobile);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _clearForm() {
    _nameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? Colors.green.shade600 : AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
               colors: isDarkMode
                  ? [
                      const Color(0xFF1A237E).withOpacity(0.9),
                      const Color(0xFF3949AB).withOpacity(0.8),
                    ]
                  : [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            title: const Text(
              StringConstants.feedbackTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: FadeTransition(
        opacity: _fadeController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Header
              Container(
                width: size.width,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                     colors: isDarkMode
                        ? [
                            AppTheme.darkSurface,
                            AppTheme.darkSurface.withOpacity(0.8),
                          ]
                        : [
                            AppTheme.primaryColor,
                            const Color(0xFF5C6BC0),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (isDarkMode ? Colors.black : AppTheme.primaryColor).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, sin(_floatingController.value * 2 * pi) * 8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.feedback_outlined,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            StringConstants.shareFeedback,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${StringConstants.feedbackVersionPrefix} $_version',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form Card
              Container(
                 decoration: BoxDecoration(
                   color: isDarkMode ? AppTheme.darkSurface : Colors.white,
                   borderRadius: BorderRadius.circular(24),
                   boxShadow: [
                     BoxShadow(
                       color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                       blurRadius: 20,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 padding: const EdgeInsets.all(24),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildInputField(
                       controller: _nameController,
                       label: StringConstants.nameLabel,
                       keyboardType: TextInputType.name,
                       inputFormatters: [
                         FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                       ],
                       validator: _isValidName,
                       errorMessage: StringConstants.invalidNameMessage,
                       isDarkMode: isDarkMode,
                     ),
                     const SizedBox(height: 20),
                     _buildInputField(
                       controller: _mobileController,
                       label: StringConstants.mobileLabel,
                       keyboardType: TextInputType.number,
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly,
                         LengthLimitingTextInputFormatter(10),
                       ],
                       validator: _isValidMobile,
                       errorMessage: StringConstants.invalidMobileMessage,
                       isDarkMode: isDarkMode,
                     ),
                     const SizedBox(height: 20),
                     _buildInputField(
                       controller: _emailController,
                       label: StringConstants.emailLabel,
                       keyboardType: TextInputType.emailAddress,
                       validator: _isValidEmail,
                       errorMessage: StringConstants.invalidEmailMessage,
                       isDarkMode: isDarkMode,
                     ),
                     const SizedBox(height: 20),
                     _buildInputField(
                       controller: _messageController,
                       label: StringConstants.feedbackLabel,
                       keyboardType: TextInputType.multiline,
                       maxLines: 6,
                       validator: (value) => value != null && value.isNotEmpty,
                       errorMessage: StringConstants.emptyFeedbackMessage,
                       isDarkMode: isDarkMode,
                     ),
                     const SizedBox(height: 32),
                     Row(
                       children: [
                         Expanded(
                           child: ElevatedButton(
                             onPressed: _isLoading ? null : _sendFeedback,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: AppTheme.primaryColor,
                               foregroundColor: Colors.white,
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(16),
                               ),
                               elevation: 2,
                             ),
                             child: _isLoading
                                 ? const SizedBox(
                                     width: 24,
                                     height: 24,
                                     child: CircularProgressIndicator(
                                       strokeWidth: 2,
                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                     ),
                                   )
                                 : const Text(
                                     StringConstants.submitButtonText,
                                     style: TextStyle(
                                       fontSize: 16,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                           ),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: ElevatedButton(
                             onPressed: _clearForm,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: isDarkMode ? AppTheme.darkSurface.withOpacity(0.8) : Colors.grey.shade200,
                               foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(16),
                               ),
                               elevation: 0,
                             ),
                             child: const Text(
                               StringConstants.clearButtonText,
                               style: TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    bool Function(String)? validator,
    String? errorMessage,
    required bool isDarkMode,
  }) {
    final hasError = controller.text.isNotEmpty && validator != null && !validator(controller.text);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.errorColor,
            width: 2,
          ),
        ),
        errorText: hasError ? errorMessage : null,
        errorStyle: TextStyle(
          color: AppTheme.errorColor,
          fontSize: 12,
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      onChanged: (value) => setState(() {}),
    );
  }
}
