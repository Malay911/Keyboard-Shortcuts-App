import 'package:keyboard_shortcuts_app/utils/import_exports.dart';

class PdfServiceBinding extends Bindings {
  @override
  void dependencies() {
    ThemeUtils.init();

    final service = PdfService();
    service.init().then((_) {
      Get.put<PdfService>(service, permanent: true);
    });
  }
}
