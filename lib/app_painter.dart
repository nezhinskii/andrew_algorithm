import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RelativePointPosition {
  left,
  right,
  collinear,
}


class AppPainter extends CustomPainter{
  final List<Offset> points;
  final bool drawHull;

  const AppPainter({
    required this.points,
    required this.drawHull
  });

  RelativePointPosition _pointRelativeToLine(Offset point1, Offset point2, Offset point3) {
    final b = point2 - point1;
    final a = point3 - point1;
    final sa = a.dx * b.dy - b.dx * a.dy;

    return sa == 0
        ? RelativePointPosition.collinear
        : sa > 0
        ? RelativePointPosition.left
        : RelativePointPosition.right;
  }

  List<Offset> _andrewAlgorithm(List<Offset> points){
    var res = <Offset>[];
    if (points.length < 4){
      if (points.length == 3){
        return [...points, points.first];
      }
      return points;
    }
    points.sort((p1, p2) {
      var res = p1.dx.compareTo(p2.dx);
      if (res == 0){
        res = p1.dy.compareTo(p2.dy);
      }
      return res;
    });
    List<Offset> up = [points.first], down = [points.first];
    for(int i = 1; i < points.length; ++i){
      if (i == points.length - 1 ||
        _pointRelativeToLine(points.first, points[i], points.last) == RelativePointPosition.right){
        while(up.length >= 2 &&
          _pointRelativeToLine(up[up.length - 2], up.last, points[i]) != RelativePointPosition.right){
          up.removeLast();
        }
        up.add(points[i]);
      }
      if (i == points.length - 1 ||
        _pointRelativeToLine(points.first, points[i], points.last) == RelativePointPosition.left){
        while(down.length >= 2 &&
            _pointRelativeToLine(down[down.length - 2], down.last, points[i]) != RelativePointPosition.left){
          down.removeLast();
        }
        down.add(points[i]);
      }
    }
    res.addAll(up);
    for (var i = down.length - 2; i >= 0; --i){
      res.add(down[i]);
    }
    return res;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var pointStyle = Paint()..color = Colors.black..strokeWidth = 8..strokeCap = StrokeCap.round;
    var lineStyle = Paint()..color = Colors.black..strokeWidth = 2..strokeCap = StrokeCap.round;
    var hullPointsStyle = Paint()..color = Colors.red..strokeWidth = 8..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.points, points, pointStyle);
    if (drawHull){
      final hullPoints = _andrewAlgorithm(points);
      canvas.drawPoints(PointMode.polygon, hullPoints, lineStyle);
      canvas.drawPoints(PointMode.points, hullPoints, hullPointsStyle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


}