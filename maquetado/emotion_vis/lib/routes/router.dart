import 'package:emotion_vis/interfaces/modules/home/home_ui.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui.dart';
import 'package:emotion_vis/interfaces/modules/principal_menu/principal_menu_ui.dart';
import 'package:emotion_vis/interfaces/modules/splash_screen/splash_screen_ui.dart';
import 'package:emotion_vis/routes/route_bindings.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:get/get.dart';

List<GetPage> routePages = [
  GetPage(
    name: routeSplashScreen,
    page: () => const SplashScreen(),
    binding: SplashScreenBinding(),
  ),
  GetPage(
    name: routeHome,
    page: () => const HomeUi(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: routePrincipalMenu,
    page: () => const PrincipalMenuUi(),
    binding: PrincipalMenuBinding(),
  ),
  GetPage(
    name: routeInitialSettings,
    page: () => const InitialSettingsUi(),
    binding: InitialSettingsBinding(),
  ),
];
