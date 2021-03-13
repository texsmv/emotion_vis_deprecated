import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/time_serie_tile.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DataUploadView extends GetView<InitialSettingsUiController> {
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
                        controller.emotionModelType ==
                            EmotionModelType.DISCRETE,
                        controller.emotionModelType != EmotionModelType.DISCRETE
                      ],
                      onPressed: controller.onModelTypeChanged,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: pColorAccent,
              thickness: 1,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("Upload the persons emotion files"),
            //     POutlinedButton(
            //       onPressed: () {
            //         controller.pickEmotionFiles(0);
            //       },
            //       text: "select",
            //     )
            //   ],
            // ),
            // Container(
            //   height: 60,
            //   width: 300,
            //   child: Obx(
            //     () => Visibility(
            //       visible: controller.personsNumber.value != 0,
            //       child: SizedBox(
            //         height: 60,
            //         width: 300,
            //         child: Center(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //             children: [
            //               Text(
            //                   "File: ${controller.currentNumber.value + 1} / ${controller.personsNumber.value}"),
            //               LinearPercentIndicator(
            //                 progressColor: pColorAccent,
            //                 width: 250,
            //                 animationDuration: 200,
            //                 lineHeight: 20,
            //                 percent: controller.uploadPercentage,
            //                 center: Text(
            //                   "${(controller.uploadPercentage * 100).toInt().toString()}%",
            //                   style: const TextStyle(fontSize: 12.0),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: GetBuilder<SeriesController>(
                builder: (_) => GetBuilder<InitialSettingsUiController>(
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
              color: pColorAccent,
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
              color: pColorAccent,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
