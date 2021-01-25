import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/tests/linear_chart_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'initial_settings/initial_settings_index.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SeriesController seriesController = Get.find();
  @override
  void initState() {
    super.initState();

    /// This function calls [startSetting] after first [build]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'By Kusisqa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
            ],
          ),
          Center(
            // child: Image.asset(
            //   "assets/images/logoSplash.png",
            //   width: MediaQuery.of(context).size.width * 0.6,
            // ),
            child: Icon(
              Icons.ac_unit,
              size: 96,
            ),
          ),
        ],
      ),
    );
  }

  /// Initial settings and configurations should be called here
  void startSettings() async {
    // Here gets the initial data
    await seriesController.loadValuesInRange(0, seriesController.windowSize);
    await seriesController.loadFeatures();
    // await seriesController.setEmotionAlphas([0.5, 0.5, 0.5, 0.5, 0.5]);

    await Future.delayed(Duration(milliseconds: 900));
    route();
  }

  // * Here you can define where to route after the splashScreen
  void route() {
    // Get.to(LinearChartTest());
    // Get.toNamed(RouteNames.INITIAL_SETTINGS);
    Get.toNamed(RouteNames.HOME);
  }
}
