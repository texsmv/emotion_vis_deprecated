import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/home/components/clusteredView.dart';
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
    // controller.reproduceController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed && controller.play) {
    //     controller.reproduceController.reverse();
    //     controller.nextWindow();
    //   } else if (status == AnimationStatus.dismissed && controller.play) {
    //     controller.reproduceController.forward();
    //     controller.nextWindow();
    //   }
    // });

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
                    GetBuilder<SeriesController>(
                      builder: (_) => Visibility(
                        visible: controller.queriedPersonData != null,
                        child: Container(
                          height: 400,
                          width: double.infinity,
                          child: SectionContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 72,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Categorical features:",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          Text(
                                            "Numerical features:",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                child: controller
                                                            .queriedPersonData !=
                                                        null
                                                    ? ListView.separated(
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                SizedBox(
                                                                    width: 10),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: controller
                                                            .queriedPersonData
                                                            .categoricalLabels
                                                            .length,
                                                        itemBuilder:
                                                            (context, pindex) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        30),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  controller
                                                                          .queriedPersonData
                                                                          .categoricalLabels[pindex] +
                                                                      ":",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  controller
                                                                      .queriedPersonData
                                                                      .categoricalValues[pindex],
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                child: controller
                                                            .queriedPersonData !=
                                                        null
                                                    ? ListView.separated(
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                SizedBox(
                                                                    width: 10),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount: controller
                                                            .queriedPersonData
                                                            .numericalLabels
                                                            .length,
                                                        itemBuilder:
                                                            (context, pindex) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        30),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  controller
                                                                          .queriedPersonData
                                                                          .numericalLabels[pindex] +
                                                                      ":",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  controller
                                                                      .queriedPersonData
                                                                      .numericalValues[
                                                                          pindex]
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          Get.find<SeriesController>()
                                              .selectedPerson = null;
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      // Temporal section
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Temporal view"),
                                              Expanded(
                                                child: GetBuilder<
                                                        SeriesController>(
                                                    builder: (_) =>
                                                        TemporalView()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Instant section
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text("Instant view"),
                                              Expanded(
                                                child: GetBuilder<
                                                        SeriesController>(
                                                    builder: (_) =>
                                                        InstantView()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ClusteredView(),
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
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
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
