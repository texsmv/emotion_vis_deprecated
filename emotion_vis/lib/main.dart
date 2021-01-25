import 'package:device_preview/device_preview.dart';
import 'package:emotion_vis/controllers/dimension_reduction_controller.dart';
import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/controllers/visualization_controller.dart';
import 'package:emotion_vis/modules/visualization_settings/visualizationSettingsIndex.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/routes/project_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // * if true then it use [devicePreview] and you'll have
  // * to specify the device dimensions manually
  final bool preview = false;
  WidgetsFlutterBinding.ensureInitialized();

  Widget emoVisApp = GetMaterialApp(
    theme: ThemeData(
      primaryColor: Color.fromARGB(255, 97, 132, 236),
      accentColor: Color.fromARGB(255, 170, 188, 240),
      textTheme: GoogleFonts.ralewayTextTheme(
        Get.textTheme,
      ),
    ),
    onInit: loadInitialControllers(),
    getPages: EmotionVisRouter.getPages,
    initialRoute: RouteNames.INITIAL_SETTINGS,
  );

  if (preview) {
    runApp(DevicePreview(builder: (context) => emoVisApp));
  } else {
    runApp(emoVisApp);
  }
}

loadInitialControllers() {
  // Get.put(DataFetcher(), permanent: true);
  // Get.put(DataProcesor(), permanent: true);
  // Get.put(VisualizationController(), permanent: true);
  // Get.put(DimensionReductionController(), permanent: true);

  Get.put(SeriesController(), permanent: true);
  Get.put(ProjectionController(), permanent: true);
}
