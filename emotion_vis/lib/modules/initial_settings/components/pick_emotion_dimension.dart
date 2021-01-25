import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<DimensionalDimension> pickDimensionalDimension(
    int discreteEmotionIndex) async {
  SeriesController seriesController = Get.find();

  await showDialog(
    context: Get.context,
    child: AlertDialog(
      title: const Text('Pick a dimension'),
      content: Container(
          width: 300,
          height: 300,
          child: ListView.builder(
              itemCount: DimensionalDimension.values.length,
              itemBuilder: (_, index) {
                return FlatButton(
                    onPressed: () {
                      for (var i = 0;
                          i < seriesController.emotionDimensionLength;
                          i++) {
                        if (seriesController
                                .dimensions[i].dimensionalDimension ==
                            DimensionalDimension.values[index]) {
                          seriesController.dimensions[i].dimensionalDimension =
                              DimensionalDimension.NONE;
                        }
                      }
                      seriesController.dimensions[discreteEmotionIndex]
                              .dimensionalDimension =
                          DimensionalDimension.values[index];
                      print(seriesController.dimensions[discreteEmotionIndex]
                          .dimensionalDimension);

                      Get.back();
                    },
                    child: Text(
                        dimension2Str(DimensionalDimension.values[index])));
              })),
    ),
  );
}
