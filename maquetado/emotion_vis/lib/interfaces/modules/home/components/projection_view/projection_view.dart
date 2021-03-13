import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/modules/home/components/clusteredView.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/automatic_options.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/bylabel_options.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/clustering_options.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/interactive_projection.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/manual_options.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class ProjectionView extends GetView<ProjectionViewUiController> {
  const ProjectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pColorBackground,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GetBuilder<ProjectionViewUiController>(
                      builder: (_) => _projectionOptions()),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InteractiveProjection(),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        controller.datasetSettings.emotionsVariablesLength,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 100,
                        child: Column(
                          children: [
                            Text(
                              controller.datasetSettings
                                  .emotionsVariablesNames[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: pTextColorPrimary,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: FlutterSlider(
                                values: [
                                  controller.datasetSettings.alphas[controller
                                          .datasetSettings
                                          .emotionsVariablesNames[index]] *
                                      100
                                ],
                                min: 0,
                                max: 100,
                                rtl: true,
                                touchSize: 20,
                                handlerHeight: 20,
                                handlerWidth: 20,
                                onDragCompleted:
                                    (handlerIndex, lowerValue, upperValue) {
                                  double value = lowerValue / 100;
                                  print(upperValue);
                                  print(lowerValue);
                                  controller.datasetSettings.alphas[controller
                                      .datasetSettings
                                      .emotionsVariablesNames[index]] = value;
                                  //     (upperValue - lowerValue) / handlerIndex;
                                  controller.updateProjections();
                                },
                                handler: FlutterSliderHandler(
                                  child: Material(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.orange,
                                    elevation: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                                axis: Axis.vertical,
                                trackBar: FlutterSliderTrackBar(
                                  inactiveTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black12,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  activeTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.orange,
                                  ),
                                ),
                                tooltip: FlutterSliderTooltip(
                                  disabled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
                decoration: BoxDecoration(
                  color: pColorPrimary,
                  border: Border.all(color: pColorPrimary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClusteredView()),
          ),
        ],
      ),
    );
  }

  Widget _projectionOptions() {
    switch (controller.clusteringMethod) {
      case ClusteringMethod.none:
        return const ClusteringOptions();
      case ClusteringMethod.manual:
        return const ManualOptions();
      case ClusteringMethod.byLabel:
        return const BylabelOptions();
      case ClusteringMethod.automatic:
        return const AutomaticOptions();
      default:
        return Container();
    }
  }
}
