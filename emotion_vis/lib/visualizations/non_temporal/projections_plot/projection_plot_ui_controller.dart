import 'package:emotion_vis/controllers/series_controller.dart';
import 'package:emotion_vis/models/person_model.dart';
import 'package:emotion_vis/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'dart:math';

class ProjectionPlotUiController extends GetxController {
  SeriesController _seriesController = Get.find();

  List<PersonModel> personModels;
  List<Offset> currentPositions;
  List<Offset> temporalPositions;
  List<Offset> positionsOffset;

  Offset selectedAreaStart;
  Offset selectedAreaEnd;
  Offset currentMouseLocation;
  bool showSelectedArea = false;
  bool _blueCluster = true;
  bool get blueCluster => _blueCluster;
  set blueCluster(bool value) => _blueCluster = value;

  Offset xlim;
  Offset ylim;

  double canvasWidth;
  double canvasHeight;

  AnimationController animationController;

  bool _isFirstBuild = true;

  void initState({List<PersonModel> personModels, Offset xlim, Offset ylim}) {
    if (!_isFirstBuild) return;
    _isFirstBuild = false;

    this.personModels = personModels;
    this.currentPositions = List.generate(personModels.length,
        (index) => Offset(personModels[index].x, personModels[index].y));

    this.xlim = xlim;
    this.ylim = ylim;

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) animationController.reset();
    });

    animationController.addListener(() {
      if (animationController.value != 0) {
        for (var i = 0; i < currentPositions.length; i++) {
          currentPositions[i] = Offset(
              temporalPositions[i].dx +
                  positionsOffset[i].dx * animationController.value,
              temporalPositions[i].dy +
                  positionsOffset[i].dy * animationController.value);
        }
      }
      update();
    });
  }

  void updateState(List<PersonModel> newPersonModels) {
    temporalPositions = List.from(currentPositions);

    positionsOffset = List.generate(
      personModels.length,
      (index) => Offset(
        newPersonModels[index].x - currentPositions[index].dx,
        newPersonModels[index].y - currentPositions[index].dy,
      ),
    );

    animationController.forward();
    this.personModels = newPersonModels;
    update();
  }

  void pointerHover(PointerHoverEvent event) {
    currentMouseLocation = event.localPosition;
    update();
  }

  void pointerUpEvent(PointerUpEvent event) {
    // selectedAreaEnd = event.localPosition;
    // print("Pointer up");
    // print(selectedAreaEnd);
    // showSelectedArea = false;
    // update();
  }

  void pointerDownEvent(PointerDownEvent event) {
    // if (!showSelectedArea)
    //   selectedAreaStart = event.localPosition;
    // else
    //   selectedAreaEnd = event.localPosition;
    // showSelectedArea = !showSelectedArea;

    // if (!showSelectedArea) {
    //   if (blueCluster)
    //     _seriesController.blueCluster = [];
    //   else
    //     _seriesController.redCluster = [];

    //   for (var i = 0; i < personModels.length; i++) {
    //     double x =
    //         rangeConverter(personModels[i].x, xlim.dx, xlim.dy, 0, canvasWidth);
    //     double y = rangeConverter(
    //         personModels[i].y, ylim.dx, ylim.dy, 0, canvasHeight);
    //     if ((x > min(selectedAreaEnd.dx, selectedAreaStart.dx)) &&
    //         (x < max(selectedAreaEnd.dx, selectedAreaStart.dx)) &&
    //         (y > min(selectedAreaEnd.dy, selectedAreaStart.dy)) &&
    //         (y < max(selectedAreaEnd.dy, selectedAreaStart.dy))) {
    //       if (blueCluster) {
    //         personModels[i].clusterId = 0;
    //         _seriesController.blueCluster.add(personModels[i]);
    //       } else {
    //         _seriesController.redCluster.add(personModels[i]);
    //         personModels[i].clusterId = 1;
    //       }
    //     } else {
    //       if (blueCluster && personModels[i].clusterId == 0) {
    //         personModels[i].clusterId = null;
    //       } else if (!blueCluster && personModels[i].clusterId == 1) {
    //         personModels[i].clusterId = null;
    //       }
    //     }
    //   }
    // }
    // _seriesController.notify();
    // update();
  }
}
