import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeSerieTile extends GetView<InitialSettingsUiController> {
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
