import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/components/time_serie_bounds_tile.dart';
import 'package:emotion_vis/interfaces/modules/initial_settings/initial_settings_ui_controller.dart';
import 'package:emotion_vis/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_button/menu_button.dart';

class PreprocessingView extends GetView<InitialSettingsUiController> {
  const PreprocessingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Divider(
            color: pColorAccent,
          ),
          // downsampling
          Visibility(
            visible: controller.showDateOptions,
            child: Container(
              height: 80,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Allowed downsample rules:"),
                      Obx(
                        () => MenuButton<DownsampleRule>(
                          child: Container(
                            width: 120,
                            height: 30,
                            color: pColorPrimary,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              Utils.downsampleRule2Str(
                                  controller.selectedRule.value),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          items: controller.allowedDownsampleRules,
                          topDivider: true,
                          scrollPhysics: AlwaysScrollableScrollPhysics(),
                          onItemSelected: (DownsampleRule value) {
                            controller.selectedRule.value = value;
                          },
                          onMenuButtonToggle: (isToggle) {},
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white.withAlpha(0)),
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
                          itemBuilder: (DownsampleRule value) => Container(
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              alignment: Alignment.centerLeft,
                              child: Text(Utils.downsampleRule2Str(value))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: pColorAccent,
          ),
          Expanded(
            child: GetBuilder<InitialSettingsUiController>(
              builder: (_) => ListView.builder(
                itemCount: controller.datasetSettings.variablesNames.length,
                itemBuilder: (context, index) => TimeSerieBoundsTile(
                  variableName:
                      controller.datasetSettings.variablesNames[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
