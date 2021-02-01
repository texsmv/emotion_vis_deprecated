import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/modules/initial_settings/initial_settings_controller.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

class PreprocessingView extends GetView<InitialSettingsController> {
  const PreprocessingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Divider(
            color: Get.theme.accentColor,
          ),
          Container(
            height: 80,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Unidad de tiempo:"),
                    Obx(
                      () => MenuButton(
                        child: Container(
                          width: 120,
                          height: 30,
                          color: Get.theme.primaryColor,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            timeUnit2Str(controller.timeUnit.value),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        items: TimeUnit.values,
                        topDivider: true,
                        scrollPhysics: AlwaysScrollableScrollPhysics(),
                        onItemSelected: controller.onTimeUnitChanged,
                        onMenuButtonToggle: (isToggle) {},
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withAlpha(0)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3.0)),
                          color: Colors.white.withAlpha(0),
                        ),
                        divider: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        toggledChild: Container(
                          height: 30,
                        ),
                        itemBuilder: (TimeUnit timeUnit) => Container(
                            width: 80,
                            height: 30,
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: Text(timeUnit2Str(timeUnit))),
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("cantidad de unidades de tiempo:"),
                //     Container(
                //         width: 80,
                //         child: TextField(
                //             controller: controller.timeUnitQuantity)),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
