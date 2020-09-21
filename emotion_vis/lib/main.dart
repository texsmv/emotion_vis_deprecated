import 'package:device_preview/device_preview.dart';
import 'package:emotion_vis/controllers/data_fetcher.dart';
import 'package:emotion_vis/controllers/data_settings.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/routes/emotion_vis_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // * if true then it use [devicePreview] and you'll have
  // * to specify the device dimensions manually
  final bool preview = false;
  WidgetsFlutterBinding.ensureInitialized();

  Widget emoVisApp = GetMaterialApp(
    onInit: loadInitialControllers(),
    getPages: EmotionVisRouter.getPages,
    initialRoute: RouteNames.SPLASH_ROUTE,
    // theme: ThemeData(
    //     primaryColor: Color.fromARGB(255, 143, 82, 147),
    //     accentColor: Color.fromARGB(255, 81, 163, 130)),
  );

  if (preview) {
    runApp(DevicePreview(builder: (context) => emoVisApp));
  } else {
    runApp(emoVisApp);
  }
}

loadInitialControllers() {
  Get.put(DataSettings(), permanent: true);
  Get.put(DataFetcher(), permanent: true);
}
