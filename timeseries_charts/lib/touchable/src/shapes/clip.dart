import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:timeseries_charts/touchable/src/shapes/shape.dart';

abstract class ClipShape extends Shape {}

class ClipRectShape extends ClipShape {
  final Rect rect;
  final ClipOp clipOp;
  ClipRectShape(this.rect, {this.clipOp = ClipOp.intersect, bool doAntiAlias});

  @override
  bool isInside(Offset p) {
    if (clipOp == ClipOp.intersect) {
      return rect.contains(p);
    } else if (clipOp == ClipOp.difference) {
      return !rect.contains(p);
    }
    return true;
  }
}

class ClipRRectShape extends ClipShape {
  final RRect rrect;
  ClipRRectShape(this.rrect, {bool doAntiAlias});
  @override
  bool isInside(Offset p) {
    return rrect.contains(p);
  }
}

class ClipPathShape extends ClipShape {
  final Path path;
  ClipPathShape(this.path, {bool doAntiAlias});

  @override
  bool isInside(Offset p) {
    return path.contains(p);
  }
}
