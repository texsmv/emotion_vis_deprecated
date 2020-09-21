import 'package:emotion_vis/interfaces/splashScreen.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:get/route_manager.dart';

class EmotionVisRouter {
  static List<GetPage> getPages = [
    GetPage(name: RouteNames.SPLASH_ROUTE, page: () => SplashScreen()),
  ];
}
