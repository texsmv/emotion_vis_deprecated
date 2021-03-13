import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisualSettingsView extends GetView<InitialSettingsUiController> {
  const VisualSettingsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            height: 80,
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Window time unit:"),
                //     Obx(
                //       () => MenuButton(
                //         child: Container(
                //             width: 120,
                //             height: 30,
                //             color: Get.theme.primaryColor,
                //             alignment: Alignment.center,
                //             padding: const EdgeInsets.symmetric(horizontal: 16),
                //             child: Text(
                //               timeUnit2Str(controller.windowTimeUnit.value),
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.w400),
                //             )),
                //         items: TimeUnit.values,
                //         topDivider: true,
                //         scrollPhysics: AlwaysScrollableScrollPhysics(),
                //         onItemSelected: controller.onWindowTimeUnitChanged,
                //         onMenuButtonToggle: (isToggle) {},
                //         decoration: BoxDecoration(
                //             border:
                //                 Border.all(color: Colors.white.withAlpha(0)),
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(3.0)),
                //             color: Colors.white.withAlpha(0)),
                //         divider: Container(
                //           height: 1,
                //           color: Colors.grey,
                //         ),
                //         toggledChild: Container(
                //           height: 30,
                //         ),
                //         itemBuilder: (TimeUnit timeUnit) => Container(
                //             width: 80,
                //             height: 30,
                //             color: Colors.white,
                //             alignment: Alignment.centerLeft,
                //             child: Text(timeUnit2Str(timeUnit))),
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Window length:"),
                    Container(
                      width: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: controller.windowLengthController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider(
          //   color: Get.theme.accentColor,
          //   thickness: 1,
          // ),
          // Container(
          //   height: 50,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Window step size:"),
          //       Container(
          //           width: 30,
          //           child: TextField(
          //               textAlign: TextAlign.center,
          //               controller: controller.windowBiasUnitQuantity)),
          //     ],
          //   ),
          // ),
          Divider(
            color: pColorAccent,
            thickness: 1,
          ),
        ])));
  }
}
