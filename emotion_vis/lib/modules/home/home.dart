import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/modules/home/components/clusteredView.dart';
import 'package:emotion_vis/modules/home/components/projection_view.dart';
import 'package:emotion_vis/modules/home/components/selected_person_view.dart';
import 'package:emotion_vis/modules/home/components/settings_view.dart';
import 'package:emotion_vis/modules/home/components/stack_tab_bar.dart';
import 'package:emotion_vis/modules/home/components/summary_view.dart';
import 'package:emotion_vis/modules/home/components/temporal_multi_view.dart';
import 'package:emotion_vis/modules/home/components/visualizations_view.dart';
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
            // * Settings view
            Container(
              width: 320,
              height: double.infinity,
              child: SettingsView(),
            ),
            // * Main view
            Expanded(
              child: Container(
                color: Colors.white,
                // child: Column(
                //   children: [
                //     StackTabBar(),
                //     Expanded(
                //       child: IndexedStack(
                //         index: controller.stackIndex.value,
                //         children: [
                //           VisualizationsView(),
                //           ProjectionView(),
                //           SummaryView(),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
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
                    SelectedPersonView(),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: ClusteredView(),
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.doClustering();
        },
        label: Text("asd"),
      ),
    );
  }
}
