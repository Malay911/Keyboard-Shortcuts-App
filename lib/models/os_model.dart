import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class OSModel {
  final String name;
  final IconData icon;
  final List<ShortcutModel> shortcuts;
  final String? svgIconPath;

  OSModel({
    required this.name,
    required this.icon,
    required this.shortcuts,
    this.svgIconPath,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon.codePoint,
        'shortcuts': shortcuts.map((shortcut) => shortcut.toMap()).toList(),
        'svgIconPath': svgIconPath,
      };

  factory OSModel.fromJson(Map<String, dynamic> json) {
    return OSModel(
      name: json['name'] as String,
      icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
      shortcuts: (json['shortcuts'] as List<dynamic>)
          .map((shortcutJson) =>
              ShortcutModel.fromMap(shortcutJson as Map<String, dynamic>))
          .toList(),
      svgIconPath: json['svgIconPath'] as String?,
    );
  }
}
