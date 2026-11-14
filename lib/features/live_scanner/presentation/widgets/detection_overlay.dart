import 'package:flutter/material.dart';
import 'package:inframind/features/live_scanner/data/services/ai_inference_service.dart';
import 'package:inframind/theme/app_theme.dart';

class DetectionOverlay extends StatelessWidget {
  const DetectionOverlay({super.key, required this.detections});

  final List<DetectedBox> detections;

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppColors.red;
      case 'medium':
        return AppColors.gold;
      case 'low':
      default:
        return AppColors.greenLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DetectionPainter(detections: detections, getSeverityColor: _getSeverityColor),
      size: Size.infinite,
    );
  }
}

class _DetectionPainter extends CustomPainter {
  _DetectionPainter({required this.detections, required this.getSeverityColor});

  final List<DetectedBox> detections;
  final Color Function(String) getSeverityColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (final box in detections) {
      final color = getSeverityColor(box.severity);

      final rect = Rect.fromLTRB(
        box.xmin * size.width,
        box.ymin * size.height,
        box.xmax * size.width,
        box.ymax * size.height,
      );

      // Paint Box Border
      final borderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Paint Box Fill (semi-transparent)
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;

      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
      canvas.drawRRect(rRect, fillPaint);
      canvas.drawRRect(rRect, borderPaint);

      // Draw Label Background & Text
      final textSpan = TextSpan(
        text: '${box.label} (${(box.confidence * 100).toStringAsFixed(0)}%)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.rtl,
      )..layout();

      final labelRect = Rect.fromLTWH(
        rect.left,
        rect.top - 24 > 0 ? rect.top - 24 : rect.top,
        textPainter.width + 12,
        22,
      );

      final labelBgPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawRRect(RRect.fromRectAndRadius(labelRect, const Radius.circular(4)), labelBgPaint);
      textPainter.paint(canvas, Offset(labelRect.left + 6, labelRect.top + 3));
    }
  }

  @override
  bool shouldRepaint(covariant _DetectionPainter oldDelegate) {
    return oldDelegate.detections != detections;
  }
}
