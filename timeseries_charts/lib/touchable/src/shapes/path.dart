import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:timeseries_charts/touchable/src/shapes/shape.dart';
import 'package:timeseries_charts/touchable/src/types/types.dart';

class PathShape extends Shape {
  final Path path;

  PathShape(this.path,
      {Map<GestureType, Function> gestureMap,
      Paint paint,
      HitTestBehavior hitTestBehavior,
      PaintingStyle paintStyleForTouch})
      : super(
            hitTestBehavior: hitTestBehavior,
            paint: paint,
            gestureCallbackMap: gestureMap);

  @override
  bool isInside(Offset p) {
    return path.contains(p);
  }
}
