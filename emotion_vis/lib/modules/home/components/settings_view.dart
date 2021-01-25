import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/modules/home/home_controller.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/widgets/dialogs/number_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsView extends GetView<HomeController> {
  const SettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Get.theme.accentColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "Processing settings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  )),
              Divider(
                color: Colors.white10,
                thickness: 1,
              ),
              Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Text(
                          "Visualization settings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text("Emotions alphas:"),
                        GetBuilder<SeriesController>(
                          builder: (seriesController) => ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(seriesController.dimensions[index].name),
                                  SizedBox(
                                    width: 150,
                                    child: Obx(
                                      () => Slider(
                                        value: seriesController
                                            .dimensions[index].alpha,
                                        min: 0,
                                        max: 1,
                                        divisions: 50,
                                        label: seriesController
                                            .dimensions[index].alpha
                                            .toStringAsFixed(2),
                                        onChanged: (double value) {
                                          seriesController
                                              .dimensions[index].alpha = value;
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            itemCount: seriesController.dimensions.length,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Numerical alphas:"),
                        GetBuilder<SeriesController>(
                          builder: (seriesController) => ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(seriesController
                                      .numericalFeatures[index].name),
                                  SizedBox(
                                    width: 150,
                                    child: Obx(
                                      () => Slider(
                                        value: seriesController
                                            .numericalFeatures[index].alpha,
                                        min: 0,
                                        max: 1,
                                        divisions: 50,
                                        label: seriesController
                                            .numericalFeatures[index].alpha
                                            .toStringAsFixed(2),
                                        onChanged: (double value) {
                                          seriesController
                                              .numericalFeatures[index]
                                              .alpha = value;
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            itemCount:
                                seriesController.numericalFeatures.length,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 120,
                          child: FlatButton(
                            color: Get.theme.primaryColor,
                            onPressed: controller.calculateMds,
                            child: Text("Project to 2D"),
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("Window size:"),
                        //     Row(
                        //       children: [
                        //         Obx(
                        //           () => FlatButton(
                        //             onPressed: () {
                        //               Get.dialog(IntegerPickerDialog())
                        //                   .then((value) {
                        //                 if (value != null)
                        //                   controller.windowSize = value;
                        //               });
                        //             },
                        //             child:
                        //                 Text(controller.windowSize.toString()),
                        //           ),
                        //         ),
                        //         Obx(
                        //           () => MenuButton(
                        //             child: Container(
                        //                 width: 80,
                        //                 height: 30,
                        //                 alignment: Alignment.centerLeft,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 16),
                        //                 child: Text(timeUnit2Str(
                        //                     controller.windowTimeUnit))),
                        //             items: TimeUnit.values,
                        //             topDivider: true,
                        //             scrollPhysics:
                        //                 AlwaysScrollableScrollPhysics(),
                        //             onItemSelected:
                        //                 controller.onWindowTimeUnitChanged,
                        //             onMenuButtonToggle: (isToggle) {},
                        //             decoration: BoxDecoration(
                        //                 border: Border.all(
                        //                     color: Colors.white.withAlpha(0)),
                        //                 borderRadius: const BorderRadius.all(
                        //                     Radius.circular(3.0)),
                        //                 color: Colors.white.withAlpha(0)),
                        //             divider: Container(
                        //               height: 1,
                        //               color: Colors.grey,
                        //             ),
                        //             toggledChild: Container(
                        //               height: 40,
                        //             ),
                        //             itemBuilder: (TimeUnit timeUnit) =>
                        //                 Container(
                        //                     width: 80,
                        //                     height: 30,
                        //                     color: Colors.white,
                        //                     alignment: Alignment.centerLeft,
                        //                     child:
                        //                         Text(timeUnit2Str(timeUnit))),
                        //           ),
                        //         ),
                        //       ],
                        //     )
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("Window step size:"),
                        //     Obx(() => Row(
                        //           children: [
                        //             FlatButton(
                        //               onPressed: () {
                        //                 Get.dialog(IntegerPickerDialog())
                        //                     .then((value) {
                        //                   if (value != null)
                        //                     controller.windowStepSize = value;
                        //                 });
                        //               },
                        //               child: Text(
                        //                   controller.windowStepSize.toString()),
                        //             ),
                        //             Container(
                        //                 width: 80,
                        //                 height: 30,
                        //                 alignment: Alignment.centerLeft,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 16),
                        //                 child: Text(timeUnit2Str(
                        //                     controller.windowTimeUnit))),
                        //           ],
                        //         ))
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Show reduced view:"),
                            Obx(
                              () => Switch(
                                value: controller.showReducedView.value,
                                onChanged: (value) {
                                  controller.showReducedView.value = value;
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              FloatingActionButton.extended(
                backgroundColor: Get.theme.primaryColor,
                label: Text(
                  "Next window",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  controller.nextWindow();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
