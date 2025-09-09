1. Primary Color (Accent)
Hex: #4CAF50 (Green) or #2196F3 (Blue)

Used for: buttons, active tabs, highlight, icons, FAB

Reason: Professional, soothing, and contrasts well in both themes

2. Secondary Color
Hex: #FFC107 (Amber) or #FF5722 (Deep Orange)

Used for: highlights, toggle switches, category badges

3. Light Theme
Element	Color	Description
Background	#FFFFFF	Pure white for clean UI
Surface / Card	#F5F5F5	Light grey for components
Primary Text	#212121	Dark grey/black for good readability
Secondary Text	#616161	Medium grey
Border/Divider	#E0E0E0	Subtle separation

4. Dark Theme
Element	Color	Description
Background	#121212	Standard Material dark background
Surface / Card	#1E1E1E	Slightly lighter than background
Primary Text	#FFFFFF	High contrast white text
Secondary Text	#BDBDBD	Light grey
Border/Divider	#2C2C2C	Subtle division without being too bright

🔄 Dynamic Theme Approach in Flutter
Use ThemeData and ThemeMode.system to enable auto-switching:

dart
Copy
Edit
MaterialApp(
  themeMode: ThemeMode.system,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF4CAF50),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Color(0xFFF5F5F5),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4CAF50),
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF1E1E1E),
    textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  ),
);
🖌️ Optional Additions
Use GoogleFonts.inter() or GoogleFonts.robotoMono() for clean typography.

Include a subtle glow or shadow around shortcut keys for visual hierarchy.

Icons should have a uniform color and size (white in dark mode, black or grey in light mode).

