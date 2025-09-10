import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class CategoryModel {
  final String name;
  final String description;
  final IconData icon;
  final List<ShortcutModel> shortcuts;
  final String? svgIconPath;

  CategoryModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.shortcuts,
    this.svgIconPath,
  });
}