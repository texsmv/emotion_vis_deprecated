import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view.dart';
import 'package:emotion_vis/interfaces/modules/home/components/projection_view/projection_view_ui_controller.dart';
import 'package:emotion_vis/interfaces/modules/home/components/settings_view.dart';
import 'package:emotion_vis/interfaces/modules/home/components/stack_tab_bar.dart';
import 'package:emotion_vis/interfaces/modules/home/components/summary_view.dart';
import 'package:emotion_vis/interfaces/modules/home/components/summary_visualization_view.dart';
import 'package:emotion_vis/interfaces/modules/home/components/visualizations_view/visualizations_view.dart';
import 'package:emotion_vis/interfaces/modules/home/home_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeUi extends GetView<HomeUiController> {
  const HomeUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // controller.calculateMds();
            },
            icon: Icon(
              Icons.query_builder,
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          children: [
            // * Settings view
            // const SizedBox(
            //   width: 320,
            //   height: double.infinity,
            //   child: SettingsView(),
            // ),
            // * Main view
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(
                  () => Column(
                    children: [
                      const SummaryVisualizationView(),
                      const StackTabBar(),
                      Expanded(
                        child: IndexedStack(
                          index: controller.stackIndex.value,
                          children: const [
                            VisualizationsView(),
                            ProjectionView(),
                            SummaryView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // child: Column(
                //   children: [
                //     // MultiView temporal section
                //     Expanded(
                //       flex: 6,
                //       child: Container(
                //         child: SectionContainer(
                //           child: GetBuilder<SeriesController>(
                //             builder: (_) => Obx(
                //               () => TemporalMultiView(
                //                 showReducedView:
                //                     controller.showReducedView.value,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),

                //     // // Overview section
                //     // Expanded(
                //     //     flex: 1,
                //     //     child: Container(
                //     //       child: SectionContainer(
                //     //         child: Container(),
                //     //       ),
                //     //     )),
                //     SelectedPersonView(),
                //   ],
                // ),
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
          Get.find<ProjectionViewUiController>().orderSeriesByRank();
        },
        label: Text("press"),
      ),
    );
  }
}
