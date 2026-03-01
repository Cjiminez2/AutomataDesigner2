import 'package:flutter/material.dart';
import "utility_math.dart";
import "dart:math";

class Line extends CustomPainter {
  late double topA;
  late double leftA;

  late double topB;
  late double leftB;

  late double parallelPart = 0.5;
  late double perpendicularPart = 0.0;

  Line({
    required this.topA,
    required this.leftA,
    required this.topB,
    required this.leftB,
  });

  //aOrB is TRUE for A, and FALSE for B
  List<double> closestPointOnCircle(bool aOrB, double x, double y) {
    double dx;
    double dy;
    double finalX;
    double finalY;

    if (aOrB) {
      dx = x - leftA;
      dy = y - topA;
      double scale = sqrt(dx * dx + dy * dy);
      finalX = leftA + dx * 50 / scale;
      finalY = topA + dy * 50 / scale;
    } else {
      dx = x - leftB;
      dy = y - topB;
      double scale = sqrt(dx * dx + dy * dy);
      finalX = leftB + dx * 50 / scale;
      finalY = topB + dy * 50 / scale;
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

  List<double> getAnchorPoint() {
    double dx = leftB - leftA;
    double dy = topB - topA;
    double scale = sqrt(dx * dx + dy * dy);

    double x = leftA + dx * parallelPart - dy * perpendicularPart / scale;
    double y = topA + dy * parallelPart + dx * perpendicularPart / scale;

    return [x, y];
  }

  void getEndPointsAndCircle() {
    if (perpendicularPart == 0.0) {
      double midX = (leftA + leftB) / 2;
      double midY = (topA + topB) / 2;
      List<double> start = closestPointOnCircle(true, midX, midY);
      List<double> end = closestPointOnCircle(false, midX, midY);

      hasCircle = false;
      startX = start[0];
      startY = start[1];
      endX = end[0];
      endY = end[1];
    }

    List<double> anchor = getAnchorPoint();
    List<double> circle = circleFromThreePoints(leftA, topA, leftB,
        topB, anchor[0], anchor[1]);
    if (perpendicularPart > 0.0) {
      isReversed = true;
    } else {
      isReversed = false;
    }

    reverseScale = isReversed ? 1 : -1;
    startAngle = atan2(topA - circle[1], leftA - circle[0])
        - reverseScale * 50 / circle[2];

    endAngle = atan2(topB - circle[1], leftB - circle[0])
        - reverseScale * 50 / circle[2];

    startX = circle[0] + circle[2] * cos(startAngle);
    startY = circle[1] + circle[2] * sin(startAngle);

    endX = circle[0] + circle[2] * cos(endAngle);
    endY = circle[1] + circle[2] * sin(endAngle);
  }

  @override
  void paint(Canvas canvas, Size size) {
    getEndPointsAndCircle();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 4.0;
    double sweepAngle;
    if (isReversed) {
      sweepAngle = -(startAngle - endAngle);
    } else {
      sweepAngle = startAngle - endAngle;
    }

    if (hasCircle) {
      canvas.drawArc(Rect.fromCircle(
          center: Offset(circleX, circleY),
          radius: circleRadius),

          startAngle, sweepAngle, false, paint);
    } else {
      canvas.drawLine(Offset(leftA, topA), Offset(leftB, topB), paint);
    }
  }
  @override
  shouldRepaint(covariant CustomPainter oldPainter) {
    return false;
  }
}