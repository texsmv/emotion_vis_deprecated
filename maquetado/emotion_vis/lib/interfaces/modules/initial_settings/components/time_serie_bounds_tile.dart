import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSerieBoundsTile extends StatefulWidget {
  String variableName;
  TimeSerieBoundsTile({Key key, this.variableName}) : super(key: key);

  @override
  _TimeSerieBoundsTileState createState() => _TimeSerieBoundsTileState();
}

class _TimeSerieBoundsTileState extends State<TimeSerieBoundsTile> {
  InitialSettingsUiController controller = Get.find();
  SeriesController _seriesController = Get.find();
  TextEditingController lowerBoundController = TextEditingController();
  TextEditingController upperBoundController = TextEditingController();

  @override
  void initState() {
    lowerBoundController = TextEditingController(
        text: _seriesController.datasetSettings.lowerBounds[widget.variableName]
            .toString());
    upperBoundController = TextEditingController(
        text: _seriesController.datasetSettings.upperBounds[widget.variableName]
            .toString());

    lowerBoundController.addListener(() {
      _seriesController.datasetSettings.lowerBounds[widget.variableName] =
          double.parse(lowerBoundController.text, (String text) {
        return _seriesController
            .datasetSettings.lowerBounds[widget.variableName];
      });
    });
    upperBoundController.addListener(() {
      _seriesController.datasetSettings.lowerBounds[widget.variableName] =
          double.parse(upperBoundController.text, (String text) {
        return _seriesController
            .datasetSettings.lowerBounds[widget.variableName];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.variableName),
          SizedBox(
            width: 100,
            child: TextField(
              controller: lowerBoundController,
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: upperBoundController,
            ),
          )
        ],
      ),
    );
  }
}

class TimeSerieTile extends GetView<InitialSettingsUiController> {
  final TimeSerieItem timeSerieItem;
  const TimeSerieTile({Key key, this.timeSerieItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(timeSerieItem.name),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withAlpha(0),
              ),
              color: timeSerieItem.color,
              shape: BoxShape.circle,
            ),
            height: 20,
            width: 20,
          ),
          Text(optionString(timeSerieItem.option)),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              controller.editTimeSerieItem(timeSerieItem);
            },
          )
        ],
      ),
    );
  }
}
