import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  Future<void> _shareApp() async {
    await Share.share(StringConstants.shareMessage);
  }

  Future<void> _launchPlayStore(
      {String errorMessage =
          'Could not open Play Store. Please try again later.'}) async {
    final Uri marketUri = Uri.parse(StringConstants.marketUrl);
    final Uri webUri = Uri.parse(StringConstants.playStoreUrl);

    try {
      bool canLaunch = await canLaunchUrl(marketUri);
      if (canLaunch) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _rateApp() async {
    await _launchPlayStore();
  }

  Future<void> _showMoreApps() async {
    await launchUrl(Uri.parse(StringConstants.moreAppsUrl),
        mode: LaunchMode.externalApplication);
  }

  Future<void> _checkUpdates() async {
    await _launchPlayStore(
        errorMessage: 'Could not check for updates. Please try again later.');
  }

  Widget _buildAboutSection(bool isDarkMode) {
    final size = Get.size;
    final logoHeight = size.width * 0.25;

    return _buildSection(
      isDarkMode: isDarkMode,
      icon: Icons.info_outline_rounded,
      title: 'About ASWDC',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: logoHeight,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(
                    //   color: Colors.grey.withOpacity(0.2),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/darshan_logo2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Container(
                  height: logoHeight,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    // border: Border.all(
                    //   color: Colors.grey.withOpacity(0.2),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/ASWDC.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.justify,
                  'ASWDC is Application, Software and Website Development Center at Darshan University operated by Students and faculty of Computer Engineering Department.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: isDarkMode
                //         ? AppTheme.primaryColor.withOpacity(0.1)
                //         : AppTheme.primaryColor.withOpacity(0.05),
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //       color: AppTheme.primaryColor.withOpacity(0.2),
                //     ),
                //   ),
                //   child: Text(
                //     textAlign: TextAlign.justify,
                //     'The sole purpose of ASWDC is to bridge the gap between university curriculum and industry demands. Students learn cutting-edge technologies,develop real-world applications, gain professional experience under the guidance of industry experts and faculty members.',
                //     style: TextStyle(
                //       fontSize: 14,
                //       height: 1.5,
                //       color: AppTheme.primaryColor,
                //     ),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Our Purpose',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        textAlign: TextAlign.justify,
                        'The sole purpose of ASWDC is to bridge the gap between university curriculum and industry demands. Students learn cutting-edge technologies,develop real-world applications, gain professional experience under the guidance of industry experts and faculty members.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppTheme.primaryColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
            backgroundColor:
                isDarkMode ? AppTheme.darkSurface : AppTheme.primaryColor,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                iconSize: 20,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Get.back(),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'About Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              Container(
                width: 48,
                margin: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppTheme.darkSurface : AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/app_logo2.png',
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keyboard Shortcuts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? AppTheme.darkPrimaryText : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Text(
                  //   'Version 1.0.0',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color:
                  //     (isDarkMode ? AppTheme.darkPrimaryText : Colors.white)
                  //         .withOpacity(0.9),
                  //   ),
                  // ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final isDarkMode =
                          Theme.of(context).brightness == Brightness.dark;

                      if (!snapshot.hasData) {
                        return Text(
                          'Version ...',
                          style: TextStyle(
                            fontSize: 14,
                            color: (isDarkMode
                                    ? AppTheme.darkPrimaryText
                                    : Colors.white)
                                .withOpacity(0.9),
                          ),
                        );
                      }

                      final info = snapshot.data!;
                      return Text(
                        'Version ${info.version}',
                        style: TextStyle(
                          fontSize: 14,
                          color: (isDarkMode
                                  ? AppTheme.darkPrimaryText
                                  : Colors.white)
                              .withOpacity(0.9),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSection(
                    isDarkMode: isDarkMode,
                    icon: Icons.people_alt_rounded,
                    title: 'Team',
                    child: Column(
                      children: [
                        _buildTeamMember(
                          label: 'Developed by',
                          name: 'Malay Panara(23010101184)',
                          description: 'Computer Science',
                          isDarkMode: isDarkMode,
                        ),
                        const Divider(height: 24),
                        _buildTeamMember(
                          label: 'Mentored by',
                          name: 'Prof. Mehul Bhundiya',
                          description: 'ASWDC • School Of Computer Science',
                          isDarkMode: isDarkMode,
                        ),
                        const Divider(height: 24),
                        _buildTeamMember(
                          label: 'Explored by',
                          name: 'Computer Science',
                          description: 'School Of Computer Science',
                          isDarkMode: isDarkMode,
                        ),
                        const Divider(height: 24),
                        _buildTeamMember(
                          label: 'Eulogized by',
                          name: 'Darshan University',
                          description: 'Rajkot • Gujarat • INDIA',
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAboutSection(isDarkMode),
                  const SizedBox(height: 20),
                  _buildSection(
                    isDarkMode: isDarkMode,
                    icon: Icons.contact_support_rounded,
                    title: 'Contact Us',
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => launchUrl(
                              Uri.parse('mailto:aswdc@darshan.ac.in')),
                          child: _buildContactItem(
                            icon: Icons.email_rounded,
                            label: 'Email',
                            text: 'aswdc@darshan.ac.in',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(),
                        ),
                        InkWell(
                          onTap: () =>
                              launchUrl(Uri.parse('tel:+919727747317')),
                          child: _buildContactItem(
                            icon: Icons.phone_rounded,
                            label: 'Phone',
                            text: '+91-9727747317',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(),
                        ),
                        InkWell(
                          onTap: () =>
                              launchUrl(Uri.parse('https://www.darshan.ac.in')),
                          child: _buildContactItem(
                            icon: Icons.language_rounded,
                            label: 'Website',
                            text: 'www.darshan.ac.in',
                            isDarkMode: isDarkMode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    isDarkMode: isDarkMode,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.share_rounded,
                                label: 'Share App',
                                onTap: _shareApp,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.star_rounded,
                                label: 'Rate Us',
                                onTap: _rateApp,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.apps_rounded,
                                label: 'More Apps',
                                onTap: _showMoreApps,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.system_update_rounded,
                                label: 'Check Updates',
                                onTap: _checkUpdates,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: size.width,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
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
                                  colors: [
                                    Colors.orange,
                                    Colors.white,
                                    Colors.green
                                  ],
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDarkMode,
    IconData? icon,
    String? title,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null && title != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppTheme.primaryColor.withOpacity(0.2)
                : AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
              ),
            ),
          ],
        ),
        const Spacer(),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDarkMode ? Colors.white38 : Colors.black38,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? AppTheme.primaryColor.withOpacity(0.3)
                : AppTheme.primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String label,
    required String name,
    required String description,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? AppTheme.darkPrimaryText : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isDarkMode ? Colors.white38 : Colors.black38,
        ),
      ],
    );
  }
}
