import 'package:emotion_vis/interfaces/constants/app_constants.dart';

class DatasetInfoModel {
  List<String> ids = [];
  Map<String, double> minValues = {};
  Map<String, double> maxValues = {};
  List<String> variablesNames = [];
  int timeLength = 0;
  int instanceLength = 0;
  int variablesLength = 0;
  List<String> dates = []; // * only available if [isDated]
  bool isDated = false;
  List<String> downsampleRules = [];

  DatasetInfoModel();

  DatasetInfoModel.fromMap({Map<String, dynamic> info}) {
    ids = List<String>.from(info[INFO_IDS]);
    minValues = Map<String, double>.from(info[INFO_MIN_VALUES]);
    maxValues = Map<String, double>.from(info[INFO_MAX_VALUES]);
    variablesNames = List<String>.from(info[INFO_SERIES_LABELS]);
    timeLength = info[INFO_LEN_INSTANCE];
    instanceLength = info[INFO_LEN_INSTANCE];
    variablesLength = info[INFO_LEN_VARIABLES];
    isDated = info[INFO_IS_DATED];
    if (isDated) {
      dates = List<String>.from(info[INFO_DATES]);
      downsampleRules = List<String>.from(info[INFO_DOWNSAMPLE_RULES]);
    } else {
      dates = List.generate(timeLength, (index) => index.toString());
    }
  }
}
