// import 'package:emotion_vis/controllers/data_procesor.dart';
// import 'package:emotion_vis/models/person_model.dart';
// import 'package:emotion_vis/models/time_unit.dart';
// import 'package:emotion_vis/models/visualization_levels.dart';
// import 'package:emotion_vis/time_series/models/MTSerie.dart';
// import 'package:emotion_vis/utils/utils.dart';
// import 'package:get/get.dart';

// class VisualizationController extends GetxController {
//   DataProcesor dataProcesor = Get.find();

//   /// time window size
//   ///
//   /// this will be use the unit to query in [DataProcesor]
//   Rx<TimeUnit> windowTimeUnit = Rx<TimeUnit>();

//   /// [TimeUnit] quantity to be queried
//   ///
//   /// this will be the quantity of [windowTimeUnit] to
//   /// be queried in [DataProcesor]
//   RxInt windowTimeUnitQuantity = RxInt();

//   /// [TimeUnit] quantity used to iterate on time Windows
//   ///
//   /// this will be the quantity of [windowTimeUnit] to
//   /// be used in queries in [DataProcesor]. It will be multiplied
//   /// by a counter and used to move the queries through time
//   RxInt windowBiasTimeUnitQuantity = RxInt();

//   /// Temporal visualization choosed for emotion model type
//   Rx<DiscreteTemporalVisualization> discreteTemporalVisualization =
//       DiscreteTemporalVisualization.values[0].obs;
//   Rx<DimensionalTemporalVisualization> dimensionalTemporalVisualization =
//       DimensionalTemporalVisualization.values[0].obs;

//   /// Instant visualization choosed for emotion model type
//   Rx<DiscreteInstantVisualization> discreteInstantVisualization =
//       DiscreteInstantVisualization.values[0].obs;
//   Rx<DimensionalInstantVisualization> dimensionalInstantVisualization =
//       DimensionalInstantVisualization.values[0].obs;

//   /// Window queries
//   Map<String, PersonModel> queries = {};

//   /// selected person mtserie
//   PersonModel personMtSerie;

//   /// selected person mtpoint
//   MTPoint personMTPoint;

//   RxInt windowPosition = RxInt();

//   DateTime firstDateTime;

//   Rx<DateTime> currentWindowDate = Rx<DateTime>();

//   List<PersonModel> get persons => dataProcesor.persons;

//   List<String> get personIds => queries.keys.toList();

//   String _selectedPersonId;

//   String get selectedPersonId => _selectedPersonId;

//   set selectedPersonId(String value) {
//     _selectedPersonId = value;
//     getMtSerie();
//     getMtPoint();
//     update();
//   }

//   void getWindow() {
//     // print("---------------------");
//     for (int i = 0; i < dataProcesor.persons.length; i++) {
//       String id = dataProcesor.persons[i].id;
//       DateTime begin = currentWindowDate.value.subtract(Duration(hours: 1));
//       DateTime end = currentWindowDate.value
//           .add(durationFromTimeUnits(
//               windowTimeUnit.value, windowTimeUnitQuantity.value))
//           .add(Duration(hours: 1));
//       queries[id] = PersonModel(
//           id: id, mtSerie: dataProcesor.personDataInRange(i, begin, end));
//     }
//     getMtSerie();
//     getMtPoint();
//     update();
//   }

//   void initializeSelectedPerson() {
//     _selectedPersonId = persons[0].id;
//   }

//   void getMtSerie() {
//     personMtSerie = queries[selectedPersonId];
//   }

//   void getMtPoint() {
//     personMTPoint = personMtSerie.mtSerie
//         .getDataAtPos(personMtSerie.mtSerie.lengths[0] - 1);
//   }

//   void nextWindow() {
//     if (currentWindowDate.value == null)
//       currentWindowDate.value = firstDateTime;
//     else
//       currentWindowDate.value = currentWindowDate.value.add(
//           durationFromTimeUnits(
//               windowTimeUnit.value, windowBiasTimeUnitQuantity.value));
//     getWindow();
//   }

//   void calculateFirstDate() {
//     firstDateTime = persons[0].mtSerie.firstDateTime;
//     // print(persons[0].mtSerie.firstDateTime);
//     // print(persons[0].mtSerie.lastDateTime);
//   }
// }
