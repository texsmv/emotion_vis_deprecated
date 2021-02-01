import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialSettingsController extends GetxController {
  SeriesController _seriesController = Get.find();

  RxInt stackIndex = 0.obs;

  RxInt personsNumber = 0.obs;
  RxInt currentNumber = 0.obs;

  TextEditingController lowerBoundController;
  TextEditingController upperBoundController;

  int get emotionDimensionLength => _seriesController.emotionDimensionLength;

  EmotionModelType get modelType => _seriesController.modelType;

  TextEditingController windowUnitQuantity;
  TextEditingController windowBiasUnitQuantity;

  Rx<TimeUnit> timeUnit = TimeUnit.DAY.obs;
  Rx<TimeUnit> windowTimeUnit = TimeUnit.DAY.obs;

  void onTimeUnitChanged(TimeUnit newTimeUnit) {
    timeUnit.value = newTimeUnit;
  }

  void onWindowTimeUnitChanged(TimeUnit newTimeUnit) {
    windowTimeUnit.value = newTimeUnit;
  }

  void onModelTypeChanged(int index) {
    if (index == 0)
      _seriesController.modelType = EmotionModelType.DISCRETE;
    else
      _seriesController.modelType = EmotionModelType.DIMENSIONAL;
  }

  InitialSettingsController() {
    lowerBoundController =
        TextEditingController(text: _seriesController.lowerBound.toString());
    upperBoundController =
        TextEditingController(text: _seriesController.upperBound.toString());

    windowUnitQuantity =
        TextEditingController(text: _seriesController.windowSize.toString());
    windowBiasUnitQuantity =
        TextEditingController(text: _seriesController.windowStep.toString());
  }

  // * Main view data is here
  RxList<RxBool> canVisitIndexPage = [true.obs, false.obs, false.obs].obs;

  bool validateStackView(int index) {
    if (index == 0) {
      if (personsNumber.value == 0) {
        Get.snackbar("Data upload", "upload the emotion files first.");
        return false;
      } else if (personsNumber.value == currentNumber.value) {
        Get.snackbar("Data upload", "wait until all the data is uploaded.");
        return false;
      }
      // if (timeUnitQuantity.text.length == 0) {
      //   Get.snackbar("Data upload", "insert the time unit quantity.");
      //   return false;
      // } else if (!isNumeric(timeUnitQuantity.text)) {
      //   Get.snackbar(
      //       "Data upload", "error, insert numbers as time unit quantity.");
      //   return false;
      // }
      return true;
    } else if (index == 2) {
      /// validation of [windowUnitQuantity]
      if (windowUnitQuantity.text.length == 0) {
        Get.snackbar("Data upload", "insert the window unit quantity.");
        return false;
      } else if (!isNumeric(windowUnitQuantity.text)) {
        Get.snackbar(
            "Data upload", "error, insert numbers as window unit quantity.");
        return false;
      }

      /// validation of [windowBiasUnitQuantity]
      if (windowBiasUnitQuantity.text.length == 0) {
        Get.snackbar("Data upload", "insert the window bias unit quantity.");
        return false;
      } else if (!isNumeric(windowBiasUnitQuantity.text)) {
        Get.snackbar("Data upload",
            "error, insert numbers as window bias unit quantity.");
        return false;
      }

      return true;
    }
    // TODO validate
    return true;
  }

  void changeView(int newIndex) {
    if (!canVisitIndexPage[newIndex].value) return;
    if (validateStackView(stackIndex.value)) {
      applyViewChanges(stackIndex.value);
      stackIndex.value = newIndex;
    }
    update();
  }

  Future<void> applyViewChanges(int index) async {
    if (index == 0) {
      await _seriesController.setBounds(double.parse(lowerBoundController.text),
          double.parse(upperBoundController.text));
      await _seriesController.removeMarkedVariables();
    }
    if (index == 1) {
      // TODO: process without reference copy
    } else if (index == 2) {
      _seriesController.updateLocalSettings(
          newWindowSize: double.parse(windowUnitQuantity.text).toInt(),
          newWindowStep: double.parse(windowBiasUnitQuantity.text).toInt());
      // TODO choose the initial visualizations
    }
    return;
  }

  void onNextButtom() async {
    if (stackIndex.value < 2) {
      int newIndex = stackIndex.value + 1;
      if (validateStackView(stackIndex.value)) {
        await applyViewChanges(stackIndex.value);
        canVisitIndexPage[newIndex].value = true;
        stackIndex.value = newIndex;
      }
    } else if (stackIndex.value == 2) {
      if (validateStackView(stackIndex.value)) {
        await applyViewChanges(stackIndex.value);
        // Get.toNamed(RouteNames.HOME);
        Get.toNamed(RouteNames.SPLASH_ROUTE);
      }
    }

    update();
  }

  void pickEmotionFiles(int _) async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      await _seriesController.initializeDataset();
      personsNumber.value = result.files.length;
      print("Number of files: ${result.files.length}");
      await Future.delayed(Duration(milliseconds: 500));
      for (int i = 0; i < result.files.length; i++) {
        String xmlString = String.fromCharCodes(result.files[i].bytes);
        bool isCategorical =
            _seriesController.modelType == EmotionModelType.DISCRETE
                ? true
                : false;

        NotifierState state =
            await _seriesController.addEml(xmlString, isCategorical);
        print(state);
        currentNumber.value = i;
        await Future.delayed(Duration(milliseconds: 100));
      }

      await _seriesController.initBounds();
      await _seriesController.initDimensions();
      await _seriesController.initLengths();
    }
  }

  double get uploadPercentage => (personsNumber.value != 0)
      ? (currentNumber.value + 1) / personsNumber.value
      : 0;
}
