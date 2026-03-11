class StringConstants {
  // App Titles
  static const String appTitle = 'Keyboard Shortcuts';

  // Tab Titles
  static const String tabApps = 'IDE';
  static const String tabOS = 'Operating System';
  static const String tabBrowsers = 'Browsers';

  // Search
  static const String searchHint = 'Search shortcuts...';
  static const String searchCategoryHint = 'Search Category';

  // Add Shortcut Dialog
  static const String addShortcut = 'Add New Shortcut';
  static const String addShortcutApp = 'Application/OS';
  static const String addShortcutAppHint =
      'e.g., Visual Studio Code, Windows, macOS';
  static const String addShortcutAction = 'Action';
  static const String addShortcutActionHint = 'e.g., Save File, Copy, Paste';
  static const String addShortcutKeys = 'Shortcut Keys';
  static const String addShortcutKeysHint = 'e.g., Ctrl+S, Cmd+C';

  // Button Labels
  static const String cancel = 'Cancel';
  static const String save = 'Save';

  // Messages
  static const String shortcutAdded = 'Shortcut added successfully!';
  static const String noShortcutsFound =
      'No shortcuts found. Try a different search term.';
  static const String noAppsAvailable = 'No apps available';
  static const String noOsAvailable = 'No operating systems available';
  static const String noCategoriesFound = 'No categories found';
  static const String noShortcutsAvailable =
      'No shortcuts available for this category';

  // App Names
  static const String vsCode = 'Visual Studio Code';
  static const String photoshop = 'Adobe Photoshop';
  static const String intellijIdea = 'IntelliJ IDEA';
  static const String word = 'Microsoft Word';
  static const String androidStudio = 'Android Studio';

  // Browser Names
  static const String chrome = 'Google Chrome';
  static const String edge = 'Microsoft Edge';
  static const String brave = 'Brave';
  static const String safari = 'Safari';

  // OS Names
  static const String windows = 'Windows';
  static const String macOS = 'macOS';
  static const String linux = 'Linux';

  // Categories
  static const String categoryFile = 'File';
  static const String categoryEdit = 'Edit';
  static const String categoryView = 'View';
  static const String categoryTools = 'Tools';
  static const String categoryFormatting = 'Formatting';
  static const String categorySystem = 'System';
  static const String categoryApps = 'Apps';
  static const String categoryGeneral = 'General';
  static const String categoryNavigation = 'Navigation';
  static const String categoryAccessibility = 'Accessibility';
  static const String categoryTaskbar = 'Taskbar';
  static const String categoryWindowManagement = 'Window Management';

  // Feedback Screen
  static const String feedbackTitle = 'Feedback';
  static const String shareFeedback = 'Share Your Feedback';
  static const String feedbackVersionPrefix = 'Version';
  static const String nameLabel = 'Name';
  static const String mobileLabel = 'Mobile Number';
  static const String emailLabel = 'Email';
  static const String feedbackLabel = 'Feedback';
  static const String submitButtonText = 'Submit';
  static const String clearButtonText = 'Clear';
  static const String successMessage = 'Feedback sent successfully!';
  static const String fillAllFieldsMessage = 'Please fill all fields';
  static const String invalidNameMessage = 'Name should contain only letters and spaces';
  static const String invalidMobileMessage = 'Mobile number must be exactly 10 digits';
  static const String invalidEmailMessage = 'Please enter a valid email address';
  static const String emptyFeedbackMessage = 'Feedback cannot be empty';
  static const String errorPrefix = 'Error: ';
  static const String failedToSendPrefix = 'Failed to send feedback: ';
  static const String platformAndroid = 'Android';
  static const String platformIOS = 'iOS';
  static const String feedbackApiUrl = 'http://api.aswdc.in/Api/MST_AppVersions/PostAppFeedback/AppPostFeedback';
  static const String appNameFeedback = 'keyboard_shortcuts_app';
  static const String apiKey = '1234';

  // Routes
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String categoriesRoute = '/categories';
  static const String categoryDetailsRoute = '/category-details';

  // Play Store Links
  static const String appPackageName = 'com.aswdc_keyboardshortcuts';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$appPackageName&hl=en_IN';
  static const String marketUrl = 'market://details?id=$appPackageName';
  static const String moreAppsUrl =
      'https://play.google.com/store/apps/developer?id=Darshan+University';
  static const String shareMessage =
      '⌨️ *Keyboard Shortcuts* - Your Ultimate Productivity Booster!\n\n'
      '🚀 Master 1000+ shortcuts for Windows, Mac, Linux, VS Code, Chrome, Excel & more!\n\n'
      '✅ Works offline\n'
      '✅ Clean & simple UI\n'
      '✅ Dark mode supported\n'
      '✅ Share as PDF\n\n'
      '💡 Stop clicking, start shortcutting! Download now 👇\n'
      '$playStoreUrl';
}
