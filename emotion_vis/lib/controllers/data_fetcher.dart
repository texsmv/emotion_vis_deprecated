import 'package:emotion_vis/models/temporal_edata.dart';
import 'package:get/state_manager.dart';

class DataFetcher extends GetxController {
  DataFetcher();

  List<String> ids = [];
  Map<String, TemporalEData> dataset = {};

  Map<String, TemporalEData> queryDataset = {};
}
