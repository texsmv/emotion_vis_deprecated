import 'package:emotion_vis/interfaces/constants/app_constants.dart';

class DatasetSettingsModel {
  Map<String, double> lowerBounds = {};
  Map<String, double> upperBounds = {};
  Map<String, double> alphas;
  List<String> emotionsVariablesNames = [];
  List<String> metadataVariablesNames = [];
  List<String> get variablesNames =>
      List.from(emotionsVariablesNames)..addAll(metadataVariablesNames);

  int get emotionsVariablesLength => emotionsVariablesNames.length;
  int get metadataVariablesLength => metadataVariablesNames.length;

  DatasetSettingsModel();
}
