import 'package:flutter/material.dart';
import 'package:timeseries_charts/models/person_model.dart';
import 'package:graphic/graphic.dart' as graphic;

import '../../vis_settings.dart';

class StackChart extends StatefulWidget {
  PersonModel personModel;
  VisSettings visSettings;
  StackChart({
    Key key,
    @required this.personModel,
    @required this.visSettings,
  }) : super(key: key);

  @override
  _StackChartState createState() => _StackChartState();
}

class _StackChartState extends State<StackChart> {
  List<Map<String, Object>> data = [];
  Widget chart;

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    data.clear();
    for (var i = 0; i < widget.visSettings.variablesNames.length; i++) {
      for (var j = 0; j < widget.personModel.mtSerie.timeLength; j++) {
        Map<String, Object> pointMap = {};
        pointMap["emotionDimension"] = widget.visSettings.variablesNames[i];
        pointMap["label"] = widget.visSettings.timeLabels[j];
        pointMap["value"] = widget.personModel.mtSerie
                .at(j, widget.visSettings.variablesNames[i]) -
            widget.visSettings.lowerLimit;
        data.add(pointMap);
      }
    }

    chart = Container(
      key: UniqueKey(),
      child: graphic.Chart(
        data: data,
        scales: {
          'emotionDimension': graphic.CatScale(
            accessor: (map) => map['emotionDimension'] as String,
          ),
          'label': graphic.CatScale(
            accessor: (map) => map['label'] as String,
          ),
          'value': graphic.LinearScale(
            accessor: (map) => map['value'] as num,
            max: widget.visSettings.limitSize *
                widget.visSettings.variablesNames.length,
          )
        },
        geoms: [
          graphic.AreaGeom(
            position: graphic.PositionAttr(field: 'label*value'),
            color: graphic.ColorAttr(field: 'emotionDimension'),
            shape: graphic.ShapeAttr(
                values: [graphic.BasicAreaShape(smooth: true)]),
            adjust: graphic.StackAdjust(),
          )
        ],
        axes: {
          'label': graphic.Defaults.horizontalAxis,
          'value': graphic.Defaults.verticalAxis,
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant StackChart oldWidget) {
    setData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return chart;
  }
}
