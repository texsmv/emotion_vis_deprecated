import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/enums/app_enums.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/repositories/projections_repository.dart';
import 'package:get/get.dart';

class ProjectionController extends GetxController {
  SeriesController _seriesController = Get.find();
  List<String> variablesNamesOrdered;

  bool projectionLoaded = false;

  List<PersonModel> get _personModels => _seriesController.persons;
  List<String> get _ids => _seriesController.ids;

  Future<NotifierState> calculateMdsCoordinates() async {
    Map<String, dynamic> coordsMap = await ProjectionsRepository.getMDScoords();

    for (var i = 0; i < _personModels.length; i++) {
      var coord = coordsMap[_personModels[i].id];
      _personModels[i].x = coord[0];
      _personModels[i].y = coord[1];
    }
    projectionLoaded = true;
    update();

    print(coordsMap);
  }

  Future<NotifierState> orderSeriesByRank(
      List<PersonModel> blueCluster, List<PersonModel> redCluster) async {
    if (blueCluster.length == 0 || redCluster.length == 0)
      return NotifierState.ERROR;

    variablesNamesOrdered =
        await ProjectionsRepository.getSubsetsDimensionsRankings(
      List.generate(blueCluster.length, (index) => blueCluster[index].id),
      List.generate(redCluster.length, (index) => redCluster[index].id),
    );
    update();
    return NotifierState.SUCCESS;
  }
}
