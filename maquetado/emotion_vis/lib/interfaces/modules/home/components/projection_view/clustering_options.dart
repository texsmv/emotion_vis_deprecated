import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClusteringOptions extends GetView<ProjectionViewUiController> {
  const ClusteringOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Clustering:",
          style: TextStyle(
            fontSize: 14,
            color: pTextColorSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 20),
        POutlinedButton(
            onPressed: () {
              controller.changeClusteringMethod(ClusteringMethod.automatic);
            },
            text: "automatic"),
        const SizedBox(width: 10),
        POutlinedButton(
            onPressed: () {
              controller.changeClusteringMethod(ClusteringMethod.manual);
            },
            text: "manually"),
        const SizedBox(width: 10),
        POutlinedButton(
            onPressed: () {
              controller.changeClusteringMethod(ClusteringMethod.byLabel);
            },
            text: "by label"),
      ],
    );
  }
}
