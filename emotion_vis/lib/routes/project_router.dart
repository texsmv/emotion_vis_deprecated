import 'package:emotion_vis/modules/home/home.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_index.dart';
import 'package:emotion_vis/modules/splashScreen.dart';
import 'package:emotion_vis/routes/project_bindings.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:get/route_manager.dart';

class EmotionVisRouter {
  static List<GetPage> getPages = [
    GetPage(name: RouteNames.SPLASH_ROUTE, page: () => SplashScreen()),
    GetPage(
        name: RouteNames.INITIAL_SETTINGS,
        page: () => InitialSettingsIndex(),
        binding: InitialSettingsBindings()),
    GetPage(name: RouteNames.HOME, page: () => Home(), binding: HomeBindings()),
  ];
}
