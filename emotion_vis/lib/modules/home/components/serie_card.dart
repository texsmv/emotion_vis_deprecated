import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/models/visualization_levels.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/stack_chart/stack_chart.dart';
import 'package:emotion_vis/visualizations/single_temporal/temporal_glyph/temporal_glyph.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_controller.dart';

class SerieCard extends GetView<HomeController> {
  PersonModel personModel;
  SerieCard({Key key, @required this.personModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesController _seriesController = Get.find();
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Get.find<SeriesController>().selectedPerson = personModel;
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: fillColor),
          padding: EdgeInsets.all(20),
          child: IgnorePointer(
            ignoring: true,
            child: Builder(builder: (_) {
              Widget temporalWidget;
              if (controller.emotionModelType == EmotionModelType.DIMENSIONAL) {
                switch (controller.dimensionalTemporalVisualization) {
                  case DimensionalTemporalVisualization.GLYPH:
                    return TemporalGlyph(
                      personModel: personModel,
                      visSettings: VisSettings(
                        colors: Map.fromIterable(_seriesController.dimensions,
                            key: (dimension) => dimension.name,
                            value: (dimension) => dimension.color),
                        lowerLimits: _seriesController.lowerBounds,
                        upperLimits: _seriesController.upperBounds,
                        variablesNames: controller.variablesNames,
                        timeLabels: List.generate(
                            _seriesController.temporalLength,
                            (index) => index.toString()),
                      ),
                    );

                    break;
                  case DimensionalTemporalVisualization.STACK_CHART:
                    return StackChart(
                      personModel: personModel,
                      visSettings: VisSettings(
                        colors: Map.fromIterable(_seriesController.dimensions,
                            key: (dimension) => dimension.name,
                            value: (dimension) => dimension.color),
                        lowerLimits: _seriesController.lowerBounds,
                        upperLimits: _seriesController.upperBounds,
                        variablesNames: controller.variablesNames,
                        timeLabels: List.generate(
                            _seriesController.temporalLength,
                            (index) => index.toString()),
                      ),
                    );

                    break;
                  default:
                }
              } else if (controller.emotionModelType ==
                  EmotionModelType.DISCRETE) {
                switch (controller.discreteTemporalVisualization) {
                  case DiscreteTemporalVisualization.LINEAR:
                    return TemporalLinearChart(
                      personModel: personModel,
                      visSettings: VisSettings(
                        colors: Map.fromIterable(_seriesController.dimensions,
                            key: (dimension) => dimension.name,
                            value: (dimension) => dimension.color),
                        lowerLimits: _seriesController.lowerBounds,
                        upperLimits: _seriesController.upperBounds,
                        variablesNames: controller.variablesNames,
                        timeLabels: List.generate(
                            _seriesController.temporalLength,
                            (index) => index.toString()),
                      ),
                    );
                    break;
                  case DiscreteTemporalVisualization.STACK_CHART:
                    return StackChart(
                      personModel: personModel,
                      visSettings: VisSettings(
                        colors: Map.fromIterable(_seriesController.dimensions,
                            key: (dimension) => dimension.name,
                            value: (dimension) => dimension.color),
                        lowerLimits: _seriesController.lowerBounds,
                        upperLimits: _seriesController.upperBounds,
                        variablesNames: controller.variablesNames,
                        timeLabels: List.generate(
                            _seriesController.temporalLength,
                            (index) => index.toString()),
                      ),
                    );

                    break;
                  default:
                }
              }
              return Container();
            }),
          ),
        ),
      ),
    );
  }

  Color get fillColor {
    if (personModel.clusterId == null)
      return Color.fromARGB(255, 240, 240, 240);
    else if (personModel.clusterId == 0)
      return Colors.blue.withOpacity(0.5);
    else if (personModel.clusterId == 1) return Colors.red.withOpacity(0.5);
  }
}
