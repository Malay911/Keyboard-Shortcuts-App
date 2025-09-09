class ShortcutModel {
  final int id;
  final String action;
  final String keys;
  final String description;
  final String category;
  final String osType;
  final String? appName;

  ShortcutModel({
    required this.id,
    required this.action,
    required this.keys,
    this.description = '',
    required this.category,
    required this.osType,
    this.appName = 'system',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': action,
      'keys': keys,
      'description': description,
      'category': category,
      'os_type': osType,
      'app_name': appName,
    };
  }

  factory ShortcutModel.fromMap(Map<String, dynamic> map) {
    return ShortcutModel(
      id: map['id'],
      action: map['title'],
      keys: map['keys'] ?? '',
      description: map['description'] ?? '',
      category: map['category'],
      osType: map['os_type'] ?? 'windows',
      appName: map['app_name'] ?? 'system',
    );
  }
}
