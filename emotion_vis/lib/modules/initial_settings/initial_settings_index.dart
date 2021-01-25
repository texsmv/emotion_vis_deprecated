import 'package:emotion_vis/modules/initial_settings/components/data_upload_view.dart';
import 'package:emotion_vis/modules/initial_settings/components/visual_settings_view.dart';
import 'package:emotion_vis/modules/initial_settings/components/preprocessing_view.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class InitialSettingsIndex extends GetView<InitialSettingsController> {
  InitialSettingsIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "EmotionVis",
                style: GoogleFonts.lobster(
                    fontSize: 48, color: Get.theme.primaryColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<InitialSettingsController>(
                  builder: (_) => Container(
                    width: 200,
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Settings:",
                            style: GoogleFonts.quicksand(
                                fontSize: 24,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500)),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.changeView(0);
                                },
                                child: InitialSettingsTab(
                                  title: "Data upload",
                                  tabIndex: 0,
                                  canVisit:
                                      controller.canVisitIndexPage[0].value,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.changeView(1);
                                },
                                child: InitialSettingsTab(
                                  title: "Preprocessing",
                                  tabIndex: 1,
                                  canVisit:
                                      controller.canVisitIndexPage[1].value,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.changeView(2);
                                },
                                child: InitialSettingsTab(
                                  title: "Visualizations",
                                  tabIndex: 2,
                                  canVisit:
                                      controller.canVisitIndexPage[2].value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 700,
                  height: 600,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(
                      () => IndexedStack(
                        index: controller.stackIndex.value,
                        children: [
                          DataUploadView(),
                          PreprocessingView(),
                          VisualSettingsView()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Get.theme.primaryColor,
          heroTag: "float",
          onPressed: controller.onNextButtom,
          label: Text(
            "Next",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class InitialSettingsTab extends StatelessWidget {
  final String title;
  final int tabIndex;
  final bool canVisit;
  InitialSettingsTab({Key key, this.title, this.tabIndex, this.canVisit})
      : super(key: key);

  InitialSettingsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getSelectedStyle(tabIndex, canVisit),
    );
  }

  TextStyle getSelectedStyle(int index, bool canVisit) {
    if (index == controller.stackIndex.value) {
      return GoogleFonts.quicksand(
          fontSize: 15,
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.w600);
    } else {
      if (canVisit)
        return GoogleFonts.quicksand(
            fontSize: 15,
            color: Get.theme.accentColor,
            fontWeight: FontWeight.w400);
      else
        return GoogleFonts.quicksand(
            fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400);
    }
  }
}
