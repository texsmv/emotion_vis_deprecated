import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/components/visualizations_view/visualization_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/home_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/principal_menu/principal_menu_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/splash_screen/splash_screen_ui_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenUiController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeUiController());
    Get.lazyPut(() => ProjectionViewUiController());
    Get.lazyPut(() => VisualizationsViewUiController());
  }
}

class InitialSettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitialSettingsUiController());
  }
}

class PrincipalMenuBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrincipalMenuUiController());
  }
}
