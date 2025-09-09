// // import 'package:flutter/material.dart';
// // import 'shortcut_model.dart';
// import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

// class OSModel {
//   final String name;
//   final IconData icon;
//   final List<ShortcutModel> shortcuts;

//   OSModel({
//     required this.name,
//     required this.icon,
//     required this.shortcuts,
//   });

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'icon': icon.codePoint,
//         'shortcuts': shortcuts.map((shortcut) => shortcut.toMap()).toList(),
//       };

//   factory OSModel.fromJson(Map<String, dynamic> json) {
//     return OSModel(
//       name: json['name'] as String,
//       icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
//       shortcuts: (json['shortcuts'] as List<dynamic>)
//           .map((shortcutJson) =>
//               ShortcutModel.fromMap(shortcutJson as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// Update lib/models/os_model.dart
import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class OSModel {
  final String name;
  final IconData icon;
  final List<ShortcutModel> shortcuts;
  final String? svgIconPath; // Add this line

  OSModel({
    required this.name,
    required this.icon,
    required this.shortcuts,
    this.svgIconPath, // Add this line
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon.codePoint,
        'shortcuts': shortcuts.map((shortcut) => shortcut.toMap()).toList(),
        'svgIconPath': svgIconPath, // Add this line
      };

  factory OSModel.fromJson(Map<String, dynamic> json) {
    return OSModel(
      name: json['name'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      shortcuts: (json['shortcuts'] as List<dynamic>)
          .map((shortcutJson) =>
              ShortcutModel.fromMap(shortcutJson as Map<String, dynamic>))
          .toList(),
      svgIconPath: json['svgIconPath'] as String?, // Add this line
    );
  }
}