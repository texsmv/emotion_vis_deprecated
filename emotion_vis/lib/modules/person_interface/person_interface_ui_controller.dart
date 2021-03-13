import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:get/get.dart';

class PersonInterfaceUiController extends GetxController {
  PersonModel personModel;
  SeriesController seriesController = Get.find();

  void initState(PersonModel personModel) {
    this.personModel = personModel;
  }
}
