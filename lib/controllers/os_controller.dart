// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/os_model.dart';
// import '../utils/constants/string_constants.dart';
import 'package:keyboard_shortcuts_app/models/os_model.dart';
import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class OSController extends GetxController {
  final RxList<OSModel> operatingSystems = <OSModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOperatingSystems();
  }

  // void loadOperatingSystems() {
  //   final osList = [
  //     OSModel(
  //       name: StringConstants.windows,
  //       icon: Icons.window,
  //       shortcuts: [],
  //     ),
  //     OSModel(
  //       name: StringConstants.macOS,
  //       icon: Icons.laptop_mac,
  //       shortcuts: [],
  //     ),
  //     OSModel(
  //       name: StringConstants.linux,
  //       icon: Icons.laptop,
  //       shortcuts: [],
  //     ),
  //   ];

  //   operatingSystems.assignAll(osList);
  // }

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

  // void navigateToCategoryPage(String osName) {
  //   Get.toNamed('/categories', arguments: osName);
  // }
  // void navigateToCategoryPage(String osName) {
  //   Get.toNamed(
  //     StringConstants.categoriesRoute,
  //     arguments: {
  //       'parentName': osName,
  //       'osType': osName.toLowerCase(), // windows / mac / linux
  //       'isApp': false, // This is an OS category
  //     },
  //   );
  // }
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
