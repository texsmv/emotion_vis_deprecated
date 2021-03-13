import 'package:emotion_vis/controllers/projection_controller.dart';
import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/cluster_linear_chart/cluster_linear_chart.dart';
import 'package:emotion_vis/visualizations/vis_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

class ClusteredView extends GetView<HomeController> {
  const ClusteredView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SeriesController _seriesController = Get.find();
    return Container(
      child: Column(
        children: [
          Text("Comparison"),
          Container(
            height: 50,
            child: GetBuilder<SeriesController>(
              builder: (_) => Row(
                children: [
                  Obx(
                    () => MenuButton<String>(
                      child: Container(
                        width: 120,
                        height: 30,
                        color: Get.theme.primaryColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          controller.clusterIdA.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      items: controller.clusterLabels,
                      topDivider: true,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      onItemSelected: (value) {
                        controller.clusterIdA.value = value;
                      },
                      onMenuButtonToggle: (isToggle) {},
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withAlpha(0)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white.withAlpha(0),
                      ),
                      divider: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      toggledChild: Container(
                        height: 30,
                      ),
                      itemBuilder: (String value) => Container(
                        width: 80,
                        height: 30,
                        color: Colors.white,
                        alignment: Alignment.centerLeft,
                        child: Text(value),
                      ),
                    ),
                  ),
                  Obx(
                    () => MenuButton<String>(
                      child: Container(
                        width: 120,
                        height: 30,
                        color: Get.theme.primaryColor,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          controller.clusterIdB.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      items: controller.clusterLabels,
                      topDivider: true,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      onItemSelected: (value) {
                        controller.clusterIdB.value = value;
                      },
                      onMenuButtonToggle: (isToggle) {},
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withAlpha(0)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.white.withAlpha(0),
                      ),
                      divider: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      toggledChild: Container(
                        height: 30,
                      ),
                      itemBuilder: (String value) => Container(
                          width: 80,
                          height: 30,
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: Text(value)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<SeriesController>(builder: (_) {
              print("BUILDER!");
              print(_seriesController.blueCluster);
              print(_seriesController.blueCluster.length);
              return ListView.builder(
                itemCount: controller.variablesOrdered.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          child: Text(controller.variablesOrdered[index]),
                        ),
                        Container(
                          height: 200,
                          width: 600,
                          child: ClusterLinearChart(
                            visSettings: VisSettings(
                              upperLimits: _seriesController.upperBounds,
                              lowerLimits: _seriesController.lowerBounds,
                              variablesNames:
                                  _seriesController.emotionsVariablesNames,
                            ),
                            blueCluster: controller.blueCluster,
                            redCluster: controller.redCluster,
                            variableName: controller.variablesOrdered[index],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
