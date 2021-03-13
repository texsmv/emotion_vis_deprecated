import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/modules/principal_menu/principal_menu_ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrincipalMenuUi extends GetView<PrincipalMenuUiController> {
  const PrincipalMenuUi({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select one dataset",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: pColorPrimary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: GetBuilder<SeriesController>(
                  builder: (_) => ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectDataset(
                                    controller.loadedDatasetsIds[index]);
                              },
                              child: Container(
                                height: 40,
                                color: pColorAccent.withAlpha(100),
                                alignment: Alignment.center,
                                child:
                                    Text(controller.loadedDatasetsIds[index]),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              controller.removeDataset(
                                  controller.loadedDatasetsIds[index]);
                            },
                          )
                        ],
                      );
                    },
                    itemCount: controller.loadedDatasetsIds.length,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: POutlinedButton(
                      text: "Add dataset",
                      onPressed: controller.addDataset,
                    ),
                  ),
                  Expanded(
                    child: POutlinedButton(
                      text: "open local dataset",
                      onPressed: controller.openLocalDataset,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
