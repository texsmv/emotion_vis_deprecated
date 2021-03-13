import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSerieBoundsTile extends StatefulWidget {
  String variableName;
  TimeSerieBoundsTile({Key key, @required this.variableName}) : super(key: key);

  @override
  _TimeSerieBoundsTileState createState() => _TimeSerieBoundsTileState();
}

class _TimeSerieBoundsTileState extends State<TimeSerieBoundsTile> {
  InitialSettingsController controller = Get.find();
  TextEditingController lowerBoundController;
  TextEditingController upperBoundController;

  @override
  void initState() {
    lowerBoundController = TextEditingController(
        text: controller.localLowerBounds[widget.variableName].toString());
    upperBoundController = TextEditingController(
        text: controller.localUpperBounds[widget.variableName].toString());

    lowerBoundController.addListener(() {
      controller.localLowerBounds[widget.variableName] =
          double.parse(lowerBoundController.text, (String text) {
        return controller.localLowerBounds[widget.variableName];
      });
    });
    upperBoundController.addListener(() {
      controller.localUpperBounds[widget.variableName] =
          double.parse(upperBoundController.text, (String text) {
        return controller.localUpperBounds[widget.variableName];
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

class TimeSerieTile extends GetView<InitialSettingsController> {
  final TimeSerieItem timeSerieItem;
  const TimeSerieTile({Key key, @required this.timeSerieItem})
      : super(key: key);

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
          Text(controller.optionString(timeSerieItem.option)),
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
