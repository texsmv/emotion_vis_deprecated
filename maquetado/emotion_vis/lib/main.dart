import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(GetMaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: pColorPrimary,
      accentColor: pColorAccent,
      textTheme: GoogleFonts.ralewayTextTheme(
        Get.textTheme,
      ),
    ),
    onInit: loadInitialControllers(),
    getPages: routePages,
    initialRoute: routeSplashScreen,
    // initialRoute: routeHome,
    // initialRoute: routePrincipalMenu,
  ));
}

dynamic loadInitialControllers() {
  Get.put(SeriesController(), permanent: true);
}
