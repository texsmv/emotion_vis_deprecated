import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/visualizations/non_temporal/projections_plot/projection_plot_ui_controller.dart';
import 'package:emotion_vis/visualizations/non_temporal/projections_plot/projections_plot_painter.dart';
import 'package:emotion_vis/visualizations/non_temporal/scatter_chart/scatter_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touchable/touchable.dart';

class ProjectionPlot extends StatefulWidget {
  List<PersonModel> personModels;
  List<Function> onTap;
  Offset xlim;
  Offset ylim;
  ProjectionPlot({
    Key key,
    @required this.personModels,
    @required this.xlim,
    @required this.ylim,
    this.onTap,
  }) : super(key: key);

  @override
  _ProjectionPlotState createState() => _ProjectionPlotState();
}

class _ProjectionPlotState extends State<ProjectionPlot>
    with SingleTickerProviderStateMixin {
  Offset selectedAreaStart;
  Offset selectedAreaEnd;
  Offset currentMouseLocation;

  ProjectionPlotUiController controller =
      Get.put(ProjectionPlotUiController(), permanent: true);

  @override
  void initState() {
    controller.animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    controller.initState(
        personModels: widget.personModels,
        xlim: widget.xlim,
        ylim: widget.ylim);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProjectionPlot oldWidget) {
    controller.updateState(widget.personModels);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.blueCluster = true;
              },
              child: Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue,
                ),
                child: Text(
                  "Blue cluster",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.blueCluster = false;
              },
              child: Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red,
                ),
                child: Text(
                  "Red cluster",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerUp: controller.pointerUpEvent,
            onPointerDown: controller.pointerDownEvent,
            child: MouseRegion(
              onHover: controller.pointerHover,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  print(details.localPosition);
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: GetBuilder<ProjectionPlotUiController>(
                    builder: (_) => CanvasTouchDetector(builder: (context) {
                      return CustomPaint(
                        painter: ProjectionPlotPainter(
                          context: context,
                          xlim: widget.xlim,
                          ylim: widget.ylim,
                          positions: controller.currentPositions,
                          personsModels: widget.personModels,
                          onTap: widget.onTap,
                          paintSelectArea: controller.showSelectedArea,
                          selectedAreaStart: controller.selectedAreaStart,
                          selectedAreaEnd: controller.currentMouseLocation,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class ProjectionPlot extends StatelessWidget {
//   // List<List<double>> positions;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       padding: EdgeInsets.all(5),
//       child: CanvasTouchDetector(builder: (context) {
//         return CustomPaint(
//           painter: ProjectionPlotPainter(
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
