import 'package:flutter/material.dart';
import "utility_math.dart";
import "dart:math";

class Line extends CustomPainter {
  late Offset nodeA;
  late Offset nodeB;

  late double parallelPart = 0.5;
  late double perpendicularPart = 0.0;

  Line({
    required this.nodeA,
    required this.nodeB,
  });

  //aOrB is TRUE for A, and FALSE for B
  List<double> closestPointOnCircle(bool aOrB, double x, double y) {
    double dx;
    double dy;
    double finalX;
    double finalY;

    if (aOrB) {
      dx = x - nodeA.dx;
      dy = y - nodeA.dy;
      double scale = sqrt(dx * dx + dy * dy);
      finalX = nodeA.dx + dx * 50 / scale;
      finalY = nodeA.dy + dy * 50 / scale;
    } else {
      dx = x - nodeB.dx;
      dy = y - nodeB.dy;
      double scale = sqrt(dx * dx + dy * dy);
      finalX = nodeB.dx + dx * 50 / scale;
      finalY = nodeB.dy + dy * 50 / scale;
    }
    return [finalX, finalY];
  }

  late bool hasCircle = false;
  late double startX;
  late double startY;
  late double endX;
  late double endY;

  late double startAngle;
  late double endAngle;
  late double circleX;
  late double circleY;
  late double circleRadius;
  late double reverseScale;
  late bool isReversed;

  Offset getAnchorPoint() {
    double dx = nodeB.dx - nodeA.dx;
    double dy = nodeB.dy - nodeA.dy;
    double scale = sqrt(dx * dx + dy * dy);

    double x = nodeA.dx + dx * parallelPart - dy * perpendicularPart / scale;
    double y = nodeA.dy + dy * parallelPart + dx * perpendicularPart / scale;

    return Offset(x, y);
  }

  void getEndPointsAndCircle() {
    if (perpendicularPart == 0.0) {
      double midX = (nodeA.dx + nodeB.dx) / 2;
      double midY = (nodeA.dy + nodeB.dy) / 2;
      List<double> start = closestPointOnCircle(true, midX, midY);
      List<double> end = closestPointOnCircle(false, midX, midY);

      hasCircle = false;
      startX = start[0];
      startY = start[1];
      endX = end[0];
      endY = end[1];
    } else {
      Offset anchor = getAnchorPoint();
      List<double> circle = circleFromThreePoints(nodeA.dx, nodeA.dy, nodeB.dx,
          nodeB.dy, anchor.dx, anchor.dy);
      isReversed = (perpendicularPart > 0);

      reverseScale = isReversed ? 1 : -1;
      startAngle = atan2(nodeA.dy - circle[1], nodeA.dx - circle[0])
          - reverseScale * 50 / circle[2];

      endAngle = atan2(nodeB.dy - circle[1], nodeB.dx - circle[0])
          + reverseScale * 50 / circle[2];

      startX = circle[0] + circle[2] * cos(startAngle);
      startY = circle[1] + circle[2] * sin(startAngle);

      endX = circle[0] + circle[2] * cos(endAngle);
      endY = circle[1] + circle[2] * sin(endAngle);
      hasCircle = true;
      circleX = circle[0];
      circleY = circle[1];
      circleRadius = circle[2];
    }
  }

  void drawArrow(Canvas canvas, double x, double y, double angle) {
    Path path = Path();
    Paint fillPaint = Paint()
      .. color = Colors.black
      .. style = PaintingStyle.fill;
    double dx = cos(angle);
    double dy = sin(angle);

    int num1 = 15;
    int num2 = 9;
    path.moveTo(x, y);
    path.lineTo(x - num1 * dx + num2 * dy, y - num1 * dy - num2 * dx);
    path.lineTo(x - num1 * dx - num2 * dy, y - num1 * dy + num2 * dx);
    canvas.drawPath(path, fillPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    getEndPointsAndCircle();
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 4.0;

    if (hasCircle) {
      double sweepAngle = 0;
      if (isReversed) {
        sweepAngle = -(startAngle - endAngle);
      } else {
        sweepAngle = startAngle - endAngle;
      }
      canvas.drawArc(Rect.fromCircle(
          center: Offset(circleX, circleY),
          radius: circleRadius),
          startAngle, sweepAngle, false, paint);

      drawArrow(canvas, endX, endY, endAngle - reverseScale * (pi / 2));
    } else {
      canvas.drawLine(nodeA, nodeB, paint);
      drawArrow(canvas, endX, endY, atan2(endY - startY, endX - startX));
    }
  }

  @override
  shouldRepaint(covariant CustomPainter oldPainter) {
    return false;
  }
}