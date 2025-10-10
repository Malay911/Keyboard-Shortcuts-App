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
}
