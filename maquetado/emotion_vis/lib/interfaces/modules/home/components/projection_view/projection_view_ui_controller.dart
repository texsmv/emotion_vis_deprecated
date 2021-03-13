import 'dart:math';

import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/interfaces/ui_utils.dart';
import 'package:emotion_vis/models/dataset_settings_model.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

enum ClusteringMethod { automatic, manual, byLabel, none }

class ProjectionViewUiController extends GetxController {
  SeriesController _seriesController = Get.find();
  DatasetSettingsModel get datasetSettings => _seriesController.datasetSettings;

  RxInt clusterIdA = RxInt();
  RxInt clusterIdB = RxInt();

  Random rng = Random();

  List<InteractivePoint> points;

  double axisXMaxValue;
  double axisXMinValue;
  double axisYMaxValue;
  double axisYMinValue;

  double windowWidth = 100;
  double windowHeigth = 100;

  List<PersonModel> get blueCluster => _seriesController.blueCluster;
  List<PersonModel> get redCluster => _seriesController.redCluster;
  List<String> get variablesOrdered =>
      _seriesController.variablesNamesOrdered ??
      datasetSettings.emotionsVariablesNames;

  List<int> get clusterIds => _seriesController.clusterIds;
  set clusterIds(List<int> value) => _seriesController.clusterIds = value;

  int maxClusterNumber = 8;

  RxBool _allowSelection = false.obs;
  bool get allowSelection => _allowSelection.value;
  set allowSelection(bool value) => _allowSelection.value = value;

  Rx<Offset> _selectionBeginPosition = Offset(0, 0).obs;
  Offset get selectionBeginPosition => _selectionBeginPosition.value;
  set selectionBeginPosition(Offset value) =>
      _selectionBeginPosition.value = value;
  Rx<Offset> _selectionEndPosition = Offset(10, 10).obs;
  Offset get selectionEndPosition => _selectionEndPosition.value;
  set selectionEndPosition(Offset value) => _selectionEndPosition.value = value;

  RxBool _flipHorizontally = false.obs;
  bool get flipHorizontally => _flipHorizontally.value;
  set flipHorizontally(bool value) => _flipHorizontally.value = value;
  RxBool _flipVertically = false.obs;
  bool get flipVertically => _flipVertically.value;
  set flipVertically(bool value) => _flipVertically.value = value;

  ClusteringMethod clusteringMethod = ClusteringMethod.none;

  @override
  void onInit() {
    createPositions();
    super.onInit();
  }

  double get selectionWidth =>
      (selectionEndPosition.dx - selectionBeginPosition.dx).abs();

  double get selectionHeight =>
      (selectionEndPosition.dy - selectionBeginPosition.dy).abs();

  double get selectionHorizontalStart {
    if (flipHorizontally) {
      return selectionBeginPosition.dx - selectionWidth;
    } else {
      return selectionBeginPosition.dx;
    }
  }

  double get selectionVerticalStart {
    if (flipVertically) {
      return selectionBeginPosition.dy - selectionHeight;
    } else {
      return selectionBeginPosition.dy;
    }
  }

  void onPointerDown(PointerDownEvent event) {
    if (allowSelection) {
      selectionBeginPosition = event.localPosition;
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (allowSelection) {
      selectionEndPosition = event.localPosition;
      if ((selectionEndPosition.dx - selectionBeginPosition.dx).isNegative) {
        flipHorizontally = true;
      } else {
        flipHorizontally = false;
      }
      if ((selectionEndPosition.dy - selectionBeginPosition.dy).isNegative) {
        flipVertically = true;
      } else {
        flipVertically = false;
      }
    }
  }

  void onPointerUp(PointerUpEvent event) {
    if (allowSelection) {
      List<InteractivePoint> selectedPoints = getSelectedPoints();
      if (selectedPoints.length != 0 && clusterIds.length != maxClusterNumber) {
        int clusterId = clusterIds.length;
        clusterIds.add(clusterId);
        for (int i = 0; i < selectedPoints.length; i++) {
          selectedPoints[i].clusterId = clusterId;
        }
        update();
      }

      selectionBeginPosition = Offset(0, 0);
      selectionEndPosition = Offset(0, 0);
      allowSelection = false;
    }
  }

  void addNewCluster() {
    allowSelection = true;
  }

  double mapToAxisX(double value) {
    return uiUtilRangeConverter(
        value, axisXMinValue, axisXMaxValue, 0, windowWidth);
  }

  List<InteractivePoint> getSelectedPoints() {
    List<InteractivePoint> selected = [];
    for (var i = 0; i < points.length; i++) {
      double x = points[i].plotCoordinates.item1;
      double y = points[i].plotCoordinates.item2;
      if ((x >
              min(selectionHorizontalStart,
                  selectionHorizontalStart + selectionWidth)) &&
          (x <
              max(selectionHorizontalStart,
                  selectionHorizontalStart + selectionWidth)) &&
          (y >
              min(selectionVerticalStart,
                  selectionVerticalStart + selectionHeight)) &&
          (y <
              max(selectionVerticalStart,
                  selectionVerticalStart + selectionHeight))) {
        selected.add(points[i]);
      }
    }
    return selected;
  }

  double mapToAxisY(double value) {
    return uiUtilRangeConverter(
        value, axisYMinValue, axisYMaxValue, 0, windowHeigth);
  }

  void changeClusteringMethod(ClusteringMethod method) {
    clusteringMethod = method;
    if (clusteringMethod == ClusteringMethod.none) {
      clusterIds = [];
      for (var i = 0; i < points.length; i++) {
        points[i].clusterId = null;
      }
    } else if (clusteringMethod == ClusteringMethod.automatic) {
      _seriesController.doClustering();
    }

    update();
  }

  void createPositions() {
    points = [];
    for (var i = 0; i < _seriesController.persons.length; i++) {
      points.add(
        InteractivePoint(
          personModel: _seriesController.persons[i],
          // coordinates: Tuple2(uiUtilRandomDoubleInRange(rng, 5, 15),
          // uiUtilRandomDoubleInRange(rng, 5, 15)),
        ),
      );
    }
    axisXMaxValue = points
        .reduce((a, b) => a.coordinates.item1 > b.coordinates.item1 ? a : b)
        .coordinates
        .item1;
    axisXMinValue = points
        .reduce((a, b) => a.coordinates.item1 < b.coordinates.item1 ? a : b)
        .coordinates
        .item1;
    axisYMaxValue = points
        .reduce((a, b) => a.coordinates.item2 > b.coordinates.item2 ? a : b)
        .coordinates
        .item2;
    axisYMinValue = points
        .reduce((a, b) => a.coordinates.item2 < b.coordinates.item2 ? a : b)
        .coordinates
        .item2;

    projectPointsToPlot();
  }

  void projectPointsToPlot() {
    for (var i = 0; i < points.length; i++) {
      points[i].plotCoordinates = Tuple2(
        mapToAxisX(points[i].coordinates.item1),
        mapToAxisY(points[i].coordinates.item2),
      );
    }
  }

  void updateProjections() async {
    await _seriesController.getDatasetProjection();
    // print(_seriesController.pro)
    projectPointsToPlot();
  }

  void orderSeriesByRank() async {
    print(await _seriesController.getFishersDiscriminantRanking(
        clusterIdA.value, clusterIdB.value));
  }
}

class InteractivePoint {
  PersonModel personModel;
  Tuple2<double, double> get coordinates =>
      Tuple2(personModel.x, personModel.y);
  Tuple2<double, double> plotCoordinates;
  int get clusterId => personModel.clusterId;
  set clusterId(int value) => personModel.clusterId = value;
  IconData get iconData {
    if (clusterId == null) {
      return MaterialCommunityIcons.circle_outline;
    } else {
      return clusterIcons[clusterId];
    }
  }

  static const List<IconData> clusterIcons = [
    MaterialCommunityIcons.checkbox_blank_circle,
    Entypo.star,
    MaterialCommunityIcons.triangle,
    MaterialCommunityIcons.square,
    Ionicons.md_water,
    MaterialIcons.filter_vintage,
    Ionicons.md_key,
    Ionicons.md_heart,
  ];
  InteractivePoint({this.personModel});
}
