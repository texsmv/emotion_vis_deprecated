import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/visualizations/non_temporal/scatter_chart/scatter_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class ScatterChart extends StatefulWidget {
  List<PersonModel> personModels;
  List<double> xlim;
  List<double> ylim;
  List<Function> onTap;
  ScatterChart(
      {Key key,
      @required this.personModels,
      @required this.xlim,
      this.onTap,
      @required this.ylim})
      : super(key: key);

  @override
  _ScatterChartState createState() => _ScatterChartState();
}

class _ScatterChartState extends State<ScatterChart>
    with SingleTickerProviderStateMixin {
  List<double> current_xs;
  List<double> current_ys;

  List<double> temp_xs;
  List<double> temp_ys;

  List<double> offset_xs;
  List<double> offset_ys;

  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    current_xs = List.generate(
        widget.personModels.length, (index) => widget.personModels[index].x);
    current_ys = List.generate(
        widget.personModels.length, (index) => widget.personModels[index].y);
    super.initState();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _animationController.reset();
    });

    _animationController.addListener(() {
      if (_animationController.value != 0) {
        for (var i = 0; i < current_xs.length; i++) {
          current_xs[i] =
              temp_xs[i] + offset_xs[i] * _animationController.value;
          current_ys[i] =
              temp_ys[i] + offset_ys[i] * _animationController.value;
          setState(() {});
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ScatterChart oldWidget) {
    temp_xs = List.from(current_xs);
    temp_ys = List.from(current_ys);

    offset_xs = List.generate(widget.personModels.length, (index) {
      return widget.personModels[index].x - current_xs[index];
    });

    offset_ys = List.generate(widget.personModels.length, (index) {
      return widget.personModels[index].y - current_ys[index];
    });

    _animationController.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(5),
      child: CanvasTouchDetector(builder: (context) {
        return CustomPaint(
          painter: ScatterChartPainter(
              context: context,
              xlim: widget.xlim,
              ylim: widget.ylim,
              x_s: current_xs,
              y_s: current_ys,
              personsModels: widget.personModels,
              // positions: positions,
              onTap: widget.onTap),
        );
      }),
    );
  }
}

// class ScatterChart extends StatelessWidget {
//   // List<List<double>> positions;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       padding: EdgeInsets.all(5),
//       child: CanvasTouchDetector(builder: (context) {
//         return CustomPaint(
//           painter: ScatterChartPainter(
//               context: context,
//               xlim: xlim,
//               ylim: ylim,
//               personsModels: personModels,
//               // positions: positions,
//               onTap: onTap),
//         );
//       }),
//     );
//   }
// }
