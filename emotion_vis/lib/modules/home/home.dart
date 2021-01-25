import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/controllers/visualization_controller.dart';
import 'package:emotion_vis/modules/home/components/settings_view.dart';
import 'package:emotion_vis/modules/home/components/temporal_multi_view.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/routes/project_bindings.dart';
import 'package:emotion_vis/visualizations/non_temporal/projections_plot/projection_plot_ui_controller.dart';
import 'package:emotion_vis/visualizations/single_temporal/cluster_linear_chart/cluster_linear_chart.dart';
import 'package:emotion_vis/widgets/containers/section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/instant_view.dart';
import 'components/temporal_view.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  HomeController controller = Get.find();

  @override
  void initState() {
    controller.playController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    controller.reproduceController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.reproduceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && controller.play) {
        controller.reproduceController.reverse();
        controller.nextWindow();
      } else if (status == AnimationStatus.dismissed && controller.play) {
        controller.reproduceController.forward();
        controller.nextWindow();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.calculateMds();
              },
              icon: Icon(
                Icons.query_builder,
              ))
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          children: [
            // Settings section
            Container(
              width: 320,
              height: double.infinity,
              child: SettingsView(),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  children: [
                    // MultiView temporal section
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: SectionContainer(
                          child: GetBuilder<SeriesController>(
                            builder: (_) => Obx(
                              () => TemporalMultiView(
                                showReducedView:
                                    controller.showReducedView.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // // Overview section
                    // Expanded(
                    //     flex: 1,
                    //     child: Container(
                    //       child: SectionContainer(
                    //         child: Container(),
                    //       ),
                    //     )),
                    // Expanded(
                    //   flex: 6,
                    //   child: Container(
                    //     child: Row(
                    //       children: [
                    //         // Temporal section
                    //         Expanded(
                    //             flex: 3,
                    //             child: Container(
                    //               child: SectionContainer(
                    //                 child: GetBuilder<SeriesController>(
                    //                     builder: (_) => TemporalView()),
                    //               ),
                    //             )),
                    //         // Instant section
                    //         Expanded(
                    //             flex: 2,
                    //             child: Container(
                    //               child: SectionConretainer(
                    //                 child: GetBuilder<SeriesController>(
                    //                     builder: (_) => InstantView()),
                    //               ),
                    //             ))
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: GetBuilder<SeriesController>(
                  builder: (_) => ListView.builder(
                    itemCount: controller.variablesNames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          height: 200,
                          width: 600,
                          child: ClusterLinearChart(
                            personModels: controller.clusteredPersons,
                            variableName: controller.variablesNames[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 120,
        height: 120,
        child: Center(
          child: AnimatedBuilder(
            animation: controller.playController,
            builder: (context, child) {
              return GestureDetector(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withAlpha(0),
                      ),
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  alignment: Alignment.center,
                  child: AnimatedIcon(
                    color: Colors.white,
                    icon: AnimatedIcons.play_pause,
                    size: 36,
                    progress: controller.playController,
                  ),
                ),
                onTap: () {
                  controller.play = !controller.play;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
