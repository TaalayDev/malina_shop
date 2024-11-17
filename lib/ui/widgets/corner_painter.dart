import 'dart:math' as math;

import 'package:flutter/material.dart';

class CornerColor {
  final Color leftTop;
  final Color rightTop;
  final Color rightBottom;
  final Color leftBottom;

  const CornerColor({
    required this.leftTop,
    required this.rightTop,
    required this.rightBottom,
    required this.leftBottom,
  });

  factory CornerColor.fromColor(Color color) {
    return CornerColor(
      leftTop: color,
      rightTop: color,
      rightBottom: color,
      leftBottom: color,
    );
  }

  factory CornerColor.all(Color color) {
    return CornerColor(
      leftTop: color,
      rightTop: color,
      rightBottom: color,
      leftBottom: color,
    );
  }
}

class CornerLineLength {
  final double leftTop;
  final double rightTop;
  final double rightBottom;
  final double leftBottom;

  const CornerLineLength({
    required this.leftTop,
    required this.rightTop,
    required this.rightBottom,
    required this.leftBottom,
  });

  const factory CornerLineLength.all(double length) = CornerLineLengthAll;
}

class CornerLineLengthAll extends CornerLineLength {
  const CornerLineLengthAll(double length)
      : super(
          leftTop: length,
          rightTop: length,
          rightBottom: length,
          leftBottom: length,
        );
}

class CornersPainter extends CustomPainter {
  CornersPainter({
    required this.color,
    this.width = 1,
    this.radius = BorderRadius.zero,
    this.lineLength = const CornerLineLength.all(20),
  });

  final CornerColor color;
  final double width;
  final BorderRadius radius;
  final CornerLineLength lineLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    paint.color = color.leftTop;
    final leftTopR = radius.topLeft;
    canvas.drawLine(
      Offset(0, lineLength.leftTop + leftTopR.y),
      Offset(0, leftTopR.y),
      paint,
    );
    canvas.drawLine(
      Offset(lineLength.leftTop + leftTopR.x, 0),
      Offset(leftTopR.x, 0),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, leftTopR.x * 2, leftTopR.y * 2),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );

    paint.color = color.rightTop;
    final rightTopR = radius.topRight;
    canvas.drawLine(
      Offset(size.width - lineLength.rightTop - rightTopR.x, 0),
      Offset(size.width - rightTopR.x, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, lineLength.rightTop + rightTopR.y),
      Offset(size.width, rightTopR.y),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width - rightTopR.x * 2,
        0,
        rightTopR.x * 2,
        rightTopR.y * 2,
      ),
      -math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );

    paint.color = color.rightBottom;
    final rightBottomR = radius.bottomRight;
    canvas.drawLine(
      Offset(size.width, size.height - lineLength.rightBottom - rightBottomR.y),
      Offset(size.width, size.height - rightBottomR.y),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - lineLength.rightBottom - rightBottomR.x, size.height),
      Offset(size.width - rightBottomR.x, size.height),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        size.width - rightBottomR.x * 2,
        size.height - rightBottomR.y * 2,
        rightBottomR.x * 2,
        rightBottomR.y * 2,
      ),
      0,
      math.pi / 2,
      false,
      paint,
    );

    paint.color = color.leftBottom;
    final leftBottomR = radius.bottomLeft;
    canvas.drawLine(
      Offset(lineLength.leftBottom + leftBottomR.x, size.height),
      Offset(leftBottomR.x, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height - lineLength.leftBottom - leftBottomR.y),
      Offset(0, size.height - leftBottomR.y),
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(
        0,
        size.height - leftBottomR.y * 2,
        leftBottomR.x * 2,
        leftBottomR.y * 2,
      ),
      math.pi / 2,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
