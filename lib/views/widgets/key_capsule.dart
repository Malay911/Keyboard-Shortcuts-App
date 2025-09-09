// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../theme.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

// class KeyCapsule extends StatelessWidget {
//   final String keyText;

//   const KeyCapsule({
//     Key? key,
//     required this.keyText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final theme = Theme.of(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? Color(0xFF2D3748)
//             : Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
//             offset: const Offset(0, 2),
//             blurRadius: 3,
//             spreadRadius: isDarkMode ? 0 : 1,
//           ),
//         ],
//         border: Border.all(
//           color: isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider,
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       margin: const EdgeInsets.only(right: 8),
//       child: Text(
//         keyText,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontFamily: 'monospace',
//           fontSize: 14,
//           color:
//               isDarkMode ? AppTheme.darkPrimaryText : AppTheme.lightPrimaryText,
//         ),
//       ),
//     );
//   }
// }
