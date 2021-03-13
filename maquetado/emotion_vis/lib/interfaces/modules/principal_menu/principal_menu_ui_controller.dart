import 'dart:io';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/constants/colors.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/interfaces/general_widgets/fields/ptext_field.dart';
import 'package:emotion_vis/interfaces/ui_utils.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emotion_vis/enums/app_enums.dart';

class PrincipalMenuUiController extends GetxController {
  SeriesController _seriesController = Get.find();
  TextEditingController datasetNameController = TextEditingController();
  List<String> get loadedDatasetsIds => _seriesController.loadedDatasetsIds;
  List<String> get localDatasetsIds => _seriesController.localDatasetsIds;

  Future<void> selectDataset(String datasetId) async {
    _seriesController.selectedDatasetId = datasetId;
    await _seriesController.getDatasetInfo(false);
    Get.toNamed(routeInitialSettings);
  }

  void addDataset() {
    uiUtilDialog(
      Container(
        height: 200,
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const Text(
              "Insert an id for your dataset",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: pColorPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: PTextField(
                label: "name",
                controller: datasetNameController,
              ),
            ),
            Expanded(child: SizedBox()),
            POutlinedButton(
              text: "Pick files",
              onPressed: () async {
                if (datasetNameController.text == "") {
                  Get.snackbar("Dataset", "Insert a name");
                } else {
                  final NotifierState state = await _seriesController
                      .initializeDataset(datasetNameController.text);
                  if (state == NotifierState.SUCCESS) {
                    await pickEmotionFiles();
                    await _seriesController.getDatasetsInfo();
                    Get.back();
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> removeDataset(String datasetId) async {
    await _seriesController.removeDataset(datasetId);
    await _seriesController.getDatasetsInfo();
  }

  Future<void> pickEmotionFiles() async {
    final FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result.files.isNotEmpty) {
      // await _seriesController.initializeDataset();
      // personsNumber.value = result.files.length;
      await Future.delayed(const Duration(milliseconds: 500));
      final List<File> files = result.paths.map((path) => File(path)).toList();
      for (int i = 0; i < result.files.length; i++) {
        final String xmlString =
            String.fromCharCodes(await files[i].readAsBytes());
        // String xmlString = String.fromCharCodes(result.files[i].bytes);
        final bool isCategorical =
            _seriesController.modelType == EmotionModelType.DISCRETE;

        await _seriesController.addEml(datasetNameController.text, xmlString);
        // currentNumber.value = i;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // await _seriesController.initDataInfo();
      // await _initializeTimeSeriesItems();
    }
  }

  void openLocalDataset() {
    uiUtilDialog(
      Container(
        height: 400,
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const Text(
              "Open:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: pColorPrimary,
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 10),
                itemCount: localDatasetsIds.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      NotifierState state = await _seriesController
                          .loadLocalDataset(localDatasetsIds[index]);
                      if (state == NotifierState.SUCCESS) {
                        await _seriesController.getDatasetsInfo();
                        Get.back();
                      }

                      print(state);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(localDatasetsIds[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
