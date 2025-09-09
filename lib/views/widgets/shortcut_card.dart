// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../theme.dart';
// // import 'key_capsule.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';
// import 'package:keyboard_shortcuts_app/views/widgets/key_capsule.dart';

// class ShortcutCard extends StatelessWidget {
//   final String action;
//   final String keys;
//   final String category;

//   const ShortcutCard({
//     Key? key,
//     required this.action,
//     required this.keys,
//     required this.category,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider,
//           ),
//         ),
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     action,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppTheme.secondaryColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                   child: Text(
//                     category,
//                     style: TextStyle(
//                       color: AppTheme.secondaryColor,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: keys.split('+').map((key) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 6.0),
//                   child: KeyCapsule(keyText: key),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
