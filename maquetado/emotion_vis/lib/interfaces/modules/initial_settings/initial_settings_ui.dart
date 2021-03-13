import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/data_upload_view.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/preprocessing_view.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/settings_tab.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/visual_settings_view.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialSettingsUi extends GetView<InitialSettingsUiController> {
  const InitialSettingsUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "EmotionVis",
                  style:
                      GoogleFonts.lobster(fontSize: 48, color: pColorPrimary),
                ),
              ),
              GetBuilder<InitialSettingsUiController>(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                    SizedBox(
                      width: 700,
                      height: 600,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(
                          () => IndexedStack(
                            index: controller.stackIndex.value,
                            children: const [
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Get.theme.primaryColor,
        heroTag: "float",
        onPressed: controller.onNextButtom,
        label: Text(
          "Next",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
