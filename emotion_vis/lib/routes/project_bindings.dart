import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_controller.dart';
import 'package:get/get.dart';

class InitialSettingsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitialSettingsController());
  }
}

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
