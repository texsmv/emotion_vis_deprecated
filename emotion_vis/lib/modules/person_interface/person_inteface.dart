import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/modules/person_interface/person_interface_ui_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/linear_chart/linear_chart.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class PersonInterface extends StatefulWidget {
  final PersonModel personModel;
  const PersonInterface({Key key, this.personModel}) : super(key: key);

  @override
  _PersonInterfaceState createState() => _PersonInterfaceState();
}

class _PersonInterfaceState extends State<PersonInterface> {
  PersonInterfaceUiController controller =
      Get.put(PersonInterfaceUiController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.initState(widget.personModel);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 300,
                child: TemporalLinearChart(
                  personModel: controller.personModel,
                  visSettings: VisSettings(
                    colors: Map.fromIterable(
                        controller.seriesController.dimensions,
                        key: (dimension) => dimension.name,
                        value: (dimension) => dimension.color),
                    lowerLimits: controller.seriesController.lowerBounds,
                    upperLimits: controller.seriesController.upperBounds,
                    variablesNames:
                        controller.seriesController.emotionsVariablesNames,
                    timeLabels: List.generate(
                        controller.seriesController.temporalLength,
                        (index) => index.toString()),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.seriesController.metadataVariablesLength,
                itemBuilder: (context, index) {
                  return Container(
                    height: 300,
                    width: 600,
                    child: TemporalLinearChart(
                      personModel: controller.personModel,
                      visSettings: VisSettings(
                        colors: {
                          controller.seriesController
                              .metadataVariablesNames[index]: Colors.black
                        },
                        lowerLimits: {
                          controller.seriesController
                                  .metadataVariablesNames[index]:
                              controller.seriesController.lowerBounds[controller
                                  .seriesController
                                  .metadataVariablesNames[index]]
                        },
                        upperLimits: {
                          controller.seriesController
                                  .metadataVariablesNames[index]:
                              controller.seriesController.upperBounds[controller
                                  .seriesController
                                  .metadataVariablesNames[index]]
                        },
                        variablesNames: [
                          controller
                              .seriesController.metadataVariablesNames[index]
                        ],
                        timeLabels: List.generate(
                          controller.seriesController.temporalLength,
                          (index) => index.toString(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
