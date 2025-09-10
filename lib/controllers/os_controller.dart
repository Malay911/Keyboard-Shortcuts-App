import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class OSController extends GetxController {
  final RxList<OSModel> operatingSystems = <OSModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOperatingSystems();
  }

  void loadOperatingSystems() {
    final osList = [
      OSModel(
        name: StringConstants.windows,
        icon: Icons.window,
        shortcuts: [],
        svgIconPath: 'assets/icons/windows-brands-solid-full.svg',
      ),
      OSModel(
        name: StringConstants.macOS,
        icon: Icons.laptop_mac,
        shortcuts: [],
        svgIconPath: 'assets/icons/apple-brands-solid-full.svg',
      ),
      OSModel(
        name: StringConstants.linux,
        icon: Icons.laptop,
        shortcuts: [],
        svgIconPath: 'assets/icons/linux-brands-solid-full.svg',
      ),
    ];

    operatingSystems.assignAll(osList);
  }

  String getOSType(String osName) {
    switch (osName.toLowerCase()) {
      case 'windows':
        return 'windows';
      case 'macos':
        return 'mac';
      case 'linux':
        return 'linux';
      default:
        return osName.toLowerCase();
    }
  }

  void navigateToCategoryPage(String osName) {
    String osType = getOSType(osName);

    Get.toNamed(
      StringConstants.categoriesRoute,
      arguments: {
        'parentName': osName,
        'osType': osType,
        'isApp': false,
      },
    );
  }
}
