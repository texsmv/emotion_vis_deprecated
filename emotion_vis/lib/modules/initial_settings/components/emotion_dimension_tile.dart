import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/modules/initial_settings/components/pick_emotion_dimension.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmotionDimensionTile extends StatefulWidget {
  final int emotionDimensionIndex;
  const EmotionDimensionTile({Key key, this.emotionDimensionIndex});

  @override
  _EmotionDimensionTileState createState() => _EmotionDimensionTileState();
}

class _EmotionDimensionTileState extends State<EmotionDimensionTile> {
  SeriesController seriesController = Get.find();

  @override
  Widget build(BuildContext context) {
    EmotionDimension emotionDimension =
        seriesController.dimensions[widget.emotionDimensionIndex];
    return GetBuilder<SeriesController>(
      builder: (_) => Container(
        height: 60,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Dimension name:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(seriesController
                        .dimensions[widget.emotionDimensionIndex].name),
                  ],
                ),
              ),
            ),
            Container(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Color:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Color tempColor = await pickColor(seriesController
                          .dimensions[widget.emotionDimensionIndex].color);
                      if (tempColor != null) {
                        setState(() {
                          seriesController
                              .dimensions[widget.emotionDimensionIndex]
                              .color = tempColor;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withAlpha(0),
                          ),
                          color: seriesController
                              .dimensions[widget.emotionDimensionIndex].color,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 20,
                      width: 20,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible:
                  seriesController.modelType == EmotionModelType.DIMENSIONAL,
              child: Container(
                width: 180,
                child: Row(
                  children: [
                    Text(
                      "dimension:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    FlatButton(
                      child: Text(dimension2Str(seriesController
                          .dimensions[widget.emotionDimensionIndex]
                          .dimensionalDimension)),
                      onPressed: () async {
                        await pickDimensionalDimension(
                            widget.emotionDimensionIndex);
                        setState(() {
                          if (emotionDimension.dimensionalDimension !=
                              DimensionalDimension.NONE)
                            emotionDimension.remove = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: seriesController.modelType == EmotionModelType.DISCRETE,
              child: Container(
                width: 110,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Keep:",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Obx(
                      () => Switch(
                        value: !emotionDimension.remove,
                        onChanged: (value) {
                          emotionDimension.remove = !value;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
