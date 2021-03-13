import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/modules/initial_settings/components/emotion_dimension_tile.dart';
import 'package:emotion_vis/modules/initial_settings/components/time_serie_tile.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_controller.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/widgets/buttons/app_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DataUploadView extends GetView<InitialSettingsController> {
  const DataUploadView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Emotion model:"),
                  GetBuilder<SeriesController>(
                    builder: (_) => ToggleButtons(
                      children: [
                        Container(
                            width: 90,
                            alignment: Alignment.center,
                            child: Text("Discrete")),
                        Container(
                            width: 90,
                            alignment: Alignment.center,
                            child: Text("Dimensional")),
                      ],
                      isSelected: [
                        controller.modelType == EmotionModelType.DISCRETE,
                        controller.modelType != EmotionModelType.DISCRETE
                      ],
                      onPressed: controller.onModelTypeChanged,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Get.theme.accentColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upload the persons emotion files"),
                AppButton(
                    onPressed: () {
                      controller.pickEmotionFiles(0);
                    },
                    text: "select")
              ],
            ),
            Container(
              height: 60,
              width: 300,
              child: Obx(
                () => Visibility(
                  visible: controller.personsNumber.value != 0,
                  child: Container(
                    height: 60,
                    width: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "File: ${controller.currentNumber.value + 1} / ${controller.personsNumber.value}"),
                          LinearPercentIndicator(
                            progressColor: Get.theme.accentColor,
                            width: 250,
                            animation: false,
                            animationDuration: 200,
                            lineHeight: 20,
                            percent: controller.uploadPercentage,
                            center: Text(
                              "${(controller.uploadPercentage * 100).toInt().toString()}%",
                              style: new TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: GetBuilder<SeriesController>(
                builder: (_) => GetBuilder<InitialSettingsController>(
                  builder: (_) => Column(
                    children: List.generate(
                      controller.timeSeriesItems.length,
                      (tIndex) => TimeSerieTile(
                        timeSerieItem: controller.timeSeriesItems[tIndex],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Get.theme.accentColor,
              thickness: 1,
            ),
            // Column(
            //   children: [
            //     Container(
            //       height: 50,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Lower bound:"),
            //           Container(
            //               width: 30,
            //               child: GetBuilder<SeriesController>(
            //                   builder: (seriesController) {
            //                 if (seriesController.lowerBound != null)
            //                   controller.lowerBoundController.text =
            //                       seriesController.lowerBound
            //                           .toStringAsFixed(1);
            //                 return TextField(
            //                     textAlign: TextAlign.center,
            //                     controller: controller.lowerBoundController);
            //               })),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 50,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text("Upper bound:"),
            //           Container(
            //               width: 30,
            //               child: GetBuilder<SeriesController>(
            //                   builder: (seriesController) {
            //                 if (seriesController.upperBound != null)
            //                   controller.upperBoundController.text =
            //                       seriesController.upperBound
            //                           .toStringAsFixed(1);
            //                 return TextField(
            //                     textAlign: TextAlign.center,
            //                     controller: controller.upperBoundController);
            //               })),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            Divider(
              color: Get.theme.accentColor,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
