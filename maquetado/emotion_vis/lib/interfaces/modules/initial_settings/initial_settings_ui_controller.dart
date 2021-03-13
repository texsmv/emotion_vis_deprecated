import 'dart:io';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/general_widgets/buttons/poutlined_button.dart';
import 'package:emotion_vis/models/dataset_info_model.dart';
import 'package:emotion_vis/models/dataset_settings_model.dart';
import 'package:emotion_vis/models/emotion_dimension.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/routes/route_names.dart';
import 'package:emotion_vis/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:random_color/random_color.dart';

class InitialSettingsUiController extends GetxController {
  final SeriesController _seriesController = Get.find();

  DatasetInfoModel get originalDatasetInfo =>
      _seriesController.originalDatasetInfo;

  DatasetInfoModel get procesedDatasetInfo =>
      _seriesController.procesedDatasetInfo;
  DatasetSettingsModel get datasetSettings => _seriesController.datasetSettings;

  RxInt stackIndex = 0.obs;
  RxInt personsNumber = 0.obs;
  RxInt currentNumber = 0.obs;
  RxList<RxBool> canVisitIndexPage = [true.obs, false.obs, false.obs].obs;
  Rx<DownsampleRule> selectedRule = DownsampleRule.NONE.obs;
  TextEditingController windowLengthController = TextEditingController();
  List<TimeSerieItem> timeSeriesItems = [];

  // ----------------  getters and setters --------------------------
  List<String> get variablesNames =>
      _seriesController.originalDatasetInfo.variablesNames;
  int get variablesLength =>
      _seriesController.originalDatasetInfo.variablesLength;

  bool get showDateOptions => _seriesController.originalDatasetInfo.isDated;
  double get uploadPercentage => (personsNumber.value != 0)
      ? (currentNumber.value + 1) / personsNumber.value
      : 0;
  List<DownsampleRule> get allowedDownsampleRules => List.generate(
      _seriesController.originalDatasetInfo.downsampleRules.length,
      (index) => Utils.str2downsampleRule(
          _seriesController.originalDatasetInfo.downsampleRules[index]));
  EmotionModelType get emotionModelType => _seriesController.modelType;
  set emotionModelType(EmotionModelType value) =>
      _seriesController.modelType = value;

  @override
  void onInit() {
    _initializeTimeSeriesItems();
    super.onInit();
  }

  InitialSettingsController() {
    windowLengthController =
        TextEditingController(text: _seriesController.windowLength.toString());
  }

  void changeView(int newIndex) {
    if (!canVisitIndexPage[newIndex].value) return;
    if (validateStackView(stackIndex.value)) {
      applyViewChanges(stackIndex.value);
      stackIndex.value = newIndex;
    }
    update();
  }

  void onModelTypeChanged(int index) {
    if (index == 0) {
      emotionModelType = EmotionModelType.DISCRETE;
    } else {
      emotionModelType = EmotionModelType.DIMENSIONAL;
    }
  }

  Future<void> _initializeTimeSeriesItems() async {
    timeSeriesItems = List.generate(
      originalDatasetInfo.variablesNames.length,
      (index) => TimeSerieItem(
        name: originalDatasetInfo.variablesNames[index],
        color: RandomColor().randomColor(),
      ),
    );
  }

  Future<void> applyViewChanges(int index) async {
    if (index == 0) {
      await applyTimeSeriesOptions();
      await _seriesController.initSettings();
      update();
    }
    if (index == 1) {
      if (_seriesController.originalDatasetInfo.isDated &&
          selectedRule.value != DownsampleRule.NONE) {
        await _seriesController.downsampleData(selectedRule.value);
      }
    } else if (index == 2) {
      _seriesController.updateLocalSettings(
          windowLength: double.parse(windowLengthController.text).toInt(),
          windowPosition: 0);
      await _seriesController.getDatasetInfo(true);
      await _seriesController.getMTSeries(
          _seriesController.originalDatasetInfo.ids,
          _seriesController.windowPosition,
          _seriesController.windowPosition + _seriesController.windowLength);
      await _seriesController.compute_d_k(true);
      await _seriesController.getDatasetProjection();
    }
    return;
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

    _seriesController.setVariablesNames(
        emotionsNames: emotionsVariables,
        metadataNames: metadataVariables,
        notify: true);
  }

  bool validateStackView(int index) {
    if (index == 0) {
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
        Get.toNamed(routeHome);
      }
    }

    update();
  }

  void editTimeSerieItem(TimeSerieItem timeSerieItem) async {
    Color newColor = timeSerieItem.color;
    Rx<TimeSerieOption> newOption = Rx<TimeSerieOption>();
    newOption.value = timeSerieItem.option;
    await showDialog(
      context: Get.context,
      builder: (_) => AlertDialog(
        actions: [
          POutlinedButton(
            text: "Done",
            onPressed: () {
              Get.back();
            },
          )
        ],
        content: SizedBox(
          height: 500,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Column(
                  children: List.generate(
                    getAvailableOptions(emotionModelType).length,
                    (index) => Obx(
                      () => RadioListTile<TimeSerieOption>(
                        value: getAvailableOptions(emotionModelType)[index],
                        groupValue: newOption.value,
                        title: Text(optionString(
                            getAvailableOptions(emotionModelType)[index])),
                        onChanged: (val) {
                          newOption.value = val;
                        },
                        selected:
                            getAvailableOptions(emotionModelType)[index] ==
                                newOption.value,
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

List<TimeSerieOption> getAvailableOptions(EmotionModelType modelType) {
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

class TimeSerieItem {
  String name;
  Color color;

  TimeSerieOption option = TimeSerieOption.IGNORE;
  TimeSerieItem({this.name = "", this.color = Colors.black});
}
