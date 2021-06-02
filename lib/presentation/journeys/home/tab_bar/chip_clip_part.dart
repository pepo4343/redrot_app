import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';

class CustomClipPath extends CustomClipper<Path> {
  final double barHeight;
  final double barWidth;
  final double chipOffset;
  final double padding = 3;
  final double parentMargin = Sizes.dimen_8;

  CustomClipPath({
    required this.barHeight,
    required this.barWidth,
    required this.chipOffset,
  });

  @override
  Path getClip(Size size) {
    final double parentRadius = barHeight / 2;
    final double radius = parentRadius - padding;
    final double chipWidth = (barWidth - 2 * padding) / 3;
    final double chipLineWidth = chipWidth - radius * 2;
    final double offset = chipOffset * chipWidth;
    final p1 = Point(offset + parentRadius, parentMargin + padding);
    final p2 = Point(offset + radius + chipLineWidth, parentMargin + padding);
    final p4 =
        Point(offset + parentRadius, parentMargin + padding + radius * 2);

    final c1 =
        Point(offset + radius + chipLineWidth, parentMargin + padding + radius);
    final c2 = Point(offset + parentRadius, parentMargin + padding + radius);
    Path path = Path()
      ..moveTo(p1.x, p1.y)
      ..lineTo(p2.x, p2.y)
      ..arcTo(
        Rect.fromCircle(center: Offset(c1.x, c1.y), radius: radius),
        1.5 * pi,
        pi,
        false,
      )
      ..lineTo(p4.x, p4.y)
      ..arcTo(
        Rect.fromCircle(center: Offset(c2.x, c2.y), radius: radius),
        0.5 * pi,
        pi,
        false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Point {
  final double x;
  final double y;
  Point(this.x, this.y);
}
