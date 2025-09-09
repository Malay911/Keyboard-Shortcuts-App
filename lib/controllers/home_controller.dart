// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        selectedTabIndex.value = tabController.index;
        update();
      }
    });
  }

  void changeTab(int index) {
    if (tabController.index != index) {
      tabController.animateTo(index);
      selectedTabIndex.value = index;
      update();
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // void showAddShortcutDialog() {
  //   final appController = TextEditingController();
  //   final actionController = TextEditingController();
  //   final keysController = TextEditingController();

  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text('Add New Shortcut'),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: appController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Application/OS',
  //                 hintText: 'e.g., Visual Studio Code, Windows, macOS',
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: actionController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Action',
  //                 hintText: 'e.g., Save File, Copy, Paste',
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             TextField(
  //               controller: keysController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Shortcut Keys',
  //                 hintText: 'e.g., Ctrl+S, Cmd+C',
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Get.back();
  //             Get.snackbar(
  //               'Success',
  //               'Shortcut added successfully!',
  //               snackPosition: SnackPosition.BOTTOM,
  //               duration: const Duration(seconds: 2),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Theme.of(Get.context!).primaryColor,
  //           ),
  //           child: const Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
