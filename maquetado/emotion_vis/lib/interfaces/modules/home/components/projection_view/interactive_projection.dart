import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/general_widgets/others/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InteractiveProjection extends GetView<ProjectionViewUiController> {
  const InteractiveProjection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        controller.windowWidth = size.width;
        controller.windowHeigth = size.height;
        controller.projectPointsToPlot();
        controller.update();
      },
      child: Listener(
        onPointerUp: controller.onPointerUp,
        onPointerDown: controller.onPointerDown,
        onPointerMove: controller.onPointerMove,
        child: Container(
          color: Colors.white,
          child: GetBuilder<SeriesController>(
            builder: (_) => GetBuilder<ProjectionViewUiController>(
              builder: (_) => Stack(
                children: List.generate(
                  controller.points.length,
                  (index) => AnimatedPositioned(
                    duration: const Duration(seconds: 2),
                    left: controller.points[index].plotCoordinates.item1,
                    top: controller.points[index].plotCoordinates.item2,
                    child: Icon(
                      controller.points[index].iconData,
                      size: 13,
                    ),
                  ),
                )..addAll(
                    [
                      Obx(
                        () => Positioned(
                          left: controller.selectionHorizontalStart,
                          top: controller.selectionVerticalStart,
                          child: Visibility(
                            visible: controller.allowSelection,
                            child: Container(
                              color: Colors.blue.withAlpha(120),
                              width: controller.selectionWidth,
                              height: controller.selectionHeight,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Icon(
                                    InteractivePoint.clusterIcons[
                                        controller.clusterIds[index]],
                                    size: 13,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                      "cluster ${controller.clusterIds[index]}")
                                ],
                              );
                            },
                            itemCount: controller.clusterIds.length,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
