import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BylabelOptions extends GetView<ProjectionViewUiController> {
  const BylabelOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(child: SizedBox()),
          POutlinedButton(
            text: "Undo",
            onPressed: () {
              controller.changeClusteringMethod(ClusteringMethod.none);
            },
          ),
        ],
      ),
    );
  }
}
