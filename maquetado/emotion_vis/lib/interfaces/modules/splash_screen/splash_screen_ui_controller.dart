import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:get/get.dart';

class SplashScreenUiController extends GetxController {
  @override
  void onReady() {
    startSettings();
    super.onReady();
  }

  Future<void> startSettings() async {
    // todo: remove this
    await Future.delayed(const Duration(milliseconds: 300));
    SeriesController seriesController = Get.find();
    await seriesController.getDatasetsInfo();
    print(seriesController.loadedDatasetsIds);
    print(seriesController.localDatasetsIds);

    route();
  }

  void route() {
    Get.offNamed(routePrincipalMenu);
  }
}
