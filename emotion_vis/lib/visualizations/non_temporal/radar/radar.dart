import 'package:emotion_vis/controllers/data_fetcher.dart';
import 'package:emotion_vis/controllers/data_settings.dart';
import 'package:emotion_vis/visualizations/non_temporal/radar/radar_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstantRadar extends StatefulWidget {
  String id;
  InstantRadar({Key key, @required this.id}) : super(key: key);

  @override
  _InstantRadarState createState() => _InstantRadarState();
}

class _InstantRadarState extends State<InstantRadar> {
  DataSettings dataSettings = Get.find();
  DataFetcher dataFetcher = Get.find();

  @override
  Widget build(BuildContext context) {
    List<String> emotionsLabels = [];
    List<double> emotionsValues = [];

    for (int i = 0; i < dataSettings.emotionDimensions.length; i++) {
      emotionsLabels.add(dataSettings.emotionDimensions[i].name);
      emotionsValues.add(dataFetcher.queryDataset[widget.id].data[0]
          .data[dataSettings.emotionDimensions[i].name]);
    }

    return CustomPaint(
      painter: InstantRadarPainter(
        emotionsLabels: emotionsLabels,
        emotionsValues: emotionsValues,
      ),
    );
  }
}
