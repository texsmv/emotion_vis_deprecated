import 'dart:io';
import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/models/emotions_models.dart';
import 'package:emotion_vis/models/time_unit.dart';
import 'package:emotion_vis/repositories/series_repository.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:emotion_vis/widgets/buttons/app_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class InitialSettingsController extends GetxController {
  // * updated code
  SeriesController _seriesController = Get.find();

  List<String> get variablesNames => _seriesController.variablesNames;
  int get variablesLength => _seriesController.variablesLength;

  EmotionModelType get emotionModelType => _seriesController.modelType;
  List<DownsampleRule> get allowedDownsampleRules => List.generate(
      _seriesController.allowedDownsampleRules.length,
      (index) => Utils.str2downsampleRule(
          _seriesController.allowedDownsampleRules[index]));
  bool get showDateOptions => _seriesController.isDataDated;

  Map<String, double> localLowerBounds = {};
  Map<String, double> localUpperBounds = {};

  TextEditingController windowLengthController;
  // ! deprecated code

  RxInt stackIndex = 0.obs;

  RxInt personsNumber = 0.obs;
  RxInt currentNumber = 0.obs;

  TextEditingController lowerBoundController;
  TextEditingController upperBoundController;

  int get emotionDimensionLength => _seriesController.emotionDimensionLength;

  EmotionModelType get modelType => _seriesController.modelType;

  Rx<DownsampleRule> selectedRule = DownsampleRule.NONE.obs;

  List<TimeSerieItem> timeSeriesItems = [];

  void onModelTypeChanged(int index) {
    if (index == 0)
      _seriesController.modelType = EmotionModelType.DISCRETE;
    else
      _seriesController.modelType = EmotionModelType.DIMENSIONAL;
  }

  InitialSettingsController() {
    windowLengthController =
        TextEditingController(text: _seriesController.windowLength.toString());
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
      if (windowLengthController.text.length == 0) {
        Get.snackbar("Data upload", "insert the window unit quantity.");
        return false;
      } else if (!isNumeric(windowLengthController.text)) {
        Get.snackbar(
            "Data upload", "error, insert numbers as window unit quantity.");
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

  Future<void> applyTimeSeriesOptions() async {
    List<String> emotionsVariables = [];
    List<Color> emotionsColors = [];
    List<DimensionalDimension> emotionsVariablesDimensionalDimension = [];
    List<String> metadataVariables = [];
    List<String> toRemoveVariables = [];

    for (var i = 0; i < timeSeriesItems.length; i++) {
      if (timeSeriesItems[i].option == TimeSerieOption.IGNORE) {
        toRemoveVariables.add(timeSeriesItems[i].name);
      } else if (timeSeriesItems[i].option == TimeSerieOption.METADATA) {
        metadataVariables.add(timeSeriesItems[i].name);
      } else {
        emotionsVariables.add(timeSeriesItems[i].name);
        emotionsColors.add(timeSeriesItems[i].color);
        if (timeSeriesItems[i].option == TimeSerieOption.EMOTION_AROUSAL) {
          emotionsVariablesDimensionalDimension
              .add(DimensionalDimension.AROUSAL);
        } else if (timeSeriesItems[i].option ==
            TimeSerieOption.EMOTION_DOMINANCE) {
          emotionsVariablesDimensionalDimension
              .add(DimensionalDimension.DOMINANCE);
        } else if (timeSeriesItems[i].option ==
            TimeSerieOption.EMOTION_VALENCE) {
          emotionsVariablesDimensionalDimension
              .add(DimensionalDimension.VALENCE);
        }
      }
    }

    if (emotionModelType == EmotionModelType.DIMENSIONAL) {
      await _seriesController.initEmotionsVariables(
          names: emotionsVariables,
          colors: emotionsColors,
          dimensionalDimensions: emotionsVariablesDimensionalDimension);
    } else {
      await _seriesController.initEmotionsVariables(
        names: emotionsVariables,
        colors: emotionsColors,
      );
    }
    if (toRemoveVariables.length != 0)
      await _seriesController.removeMarkedVariables(toRemoveVariables);

    await _seriesController.setVariablesNames(
        emotionsNames: emotionsVariables,
        metadataNames: metadataVariables,
        notify: true);
    await _seriesController.initDataInfo();
  }

  Future<void> applyViewChanges(int index) async {
    if (index == 0) {
      await applyTimeSeriesOptions();
      await _seriesController.initSettings();
      localLowerBounds =
          Map<String, double>.from(_seriesController.lowerBounds);
      localUpperBounds =
          Map<String, double>.from(_seriesController.upperBounds);
    }
    if (index == 1) {
      await _seriesController.updateSettings(
        lowerBounds: localLowerBounds,
        upperBounds: localUpperBounds,
      );
      if (_seriesController.isDataDated &&
          selectedRule.value != DownsampleRule.NONE) {
        await _seriesController.downsampleData(selectedRule.value);
        await _seriesController.initDataInfo();
        print("New!!!");
        print(_seriesController.timeLength);
        print("Downsampled");
      }
    } else if (index == 2) {
      _seriesController.updateLocalSettings(
          windowLength: double.parse(windowLengthController.text).toInt(),
          windowPosition: 0);
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
      List<File> files = result.paths.map((path) => File(path)).toList();
      for (int i = 0; i < result.files.length; i++) {
        String xmlString = String.fromCharCodes(await files[i].readAsBytes());
        // String xmlString = String.fromCharCodes(result.files[i].bytes);
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
      await _seriesController.initDataInfo();
      await _initializeTimeSeriesItems();
    }
  }

  Future<void> _initializeTimeSeriesItems() async {
    timeSeriesItems = List.generate(
      variablesLength,
      (index) => TimeSerieItem(
        name: variablesNames[index],
        color: RandomColor().randomColor(),
      ),
    );
  }

  List<TimeSerieOption> getAvailableOptions() {
    if (modelType == EmotionModelType.DIMENSIONAL)
      return [
        TimeSerieOption.EMOTION_AROUSAL,
        TimeSerieOption.EMOTION_DOMINANCE,
        TimeSerieOption.EMOTION_VALENCE,
        TimeSerieOption.METADATA,
        TimeSerieOption.IGNORE,
      ];
    else
      return [
        TimeSerieOption.EMOTION,
        TimeSerieOption.METADATA,
        TimeSerieOption.IGNORE,
      ];
  }

  void editTimeSerieItem(TimeSerieItem timeSerieItem) async {
    Color newColor = timeSerieItem.color;
    Rx<TimeSerieOption> newOption = Rx<TimeSerieOption>();
    newOption.value = timeSerieItem.option;
    await showDialog(
      context: Get.context,
      builder: (_) => AlertDialog(
        actions: [
          AppButton(
            text: "Done",
            onPressed: () {
              Get.back();
            },
          )
        ],
        content: Container(
          height: 500,
          child: Column(
            children: [
              Container(
                height: 250,
                child: Column(
                  children: List.generate(
                    getAvailableOptions().length,
                    (index) => Obx(
                      () => RadioListTile<TimeSerieOption>(
                        value: getAvailableOptions()[index],
                        groupValue: newOption.value,
                        title: Text(optionString(getAvailableOptions()[index])),
                        onChanged: (val) {
                          newOption.value = val;
                        },
                        selected:
                            getAvailableOptions()[index] == newOption.value,
                      ),
                    ),
                  ),
                ),
              ),
              ColorPicker(
                pickerColor: newColor,
                onColorChanged: (Color val) {
                  newColor = val;
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ],
          ),
        ),
      ),
    );
    timeSerieItem.option = newOption.value;
    timeSerieItem.color = newColor;
    update();
  }

  String optionString(TimeSerieOption option) {
    switch (option) {
      case TimeSerieOption.EMOTION:
        return "emotion";
      case TimeSerieOption.EMOTION_AROUSAL:
        return "emotion[arousal]";
      case TimeSerieOption.EMOTION_DOMINANCE:
        return "emotion[dominance]";
      case TimeSerieOption.EMOTION_VALENCE:
        return "emotion[valence]";
      case TimeSerieOption.METADATA:
        return "metadata";
      case TimeSerieOption.IGNORE:
        return "none";

      default:
        return "error";
    }
  }

  double get uploadPercentage => (personsNumber.value != 0)
      ? (currentNumber.value + 1) / personsNumber.value
      : 0;
}

class TimeSerieItem {
  String name;
  Color color;

  TimeSerieOption option = TimeSerieOption.IGNORE;
  TimeSerieItem({this.name, this.color});
}
