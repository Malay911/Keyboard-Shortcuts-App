import 'package:get/get.dart';
import 'pdf_service.dart';
import '../utils/theme_utils.dart';

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
