import 'package:flutter/material.dart';

class RoadArtwork extends StatelessWidget {
  const RoadArtwork({super.key});

  @override
  Widget build(BuildContext context) => const CustomPaint(
        painter: _RoadArtworkPainter(),
        child: SizedBox.expand(),
      );
}

class _RoadArtworkPainter extends CustomPainter {
  const _RoadArtworkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF526064), Color(0xFF273135), Color(0xFF182126)],
          stops: [0, 0.45, 1],
        ).createShader(bounds),
    );

    final horizon = size.height * 0.42;
    final road = Path()
      ..moveTo(size.width * 0.42, horizon)
      ..lineTo(size.width * 0.58, horizon)
      ..lineTo(size.width * 0.91, size.height)
      ..lineTo(size.width * 0.09, size.height)
      ..close();
    canvas.drawPath(road, Paint()..color = const Color(0xFF20282B));

    final centerLine = Paint()
      ..color = const Color(0xFFD8CC98).withValues(alpha: 0.78)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = (size.width * 0.008).clamp(1.0, 4.0);
    for (var index = 0; index < 5; index++) {
      final progress = index / 5;
      final y = horizon + (size.height - horizon) * progress;
      final lineWidth = size.width * (0.008 + progress * 0.022);
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + size.height * (0.035 + progress * 0.05)),
        centerLine..strokeWidth = lineWidth.clamp(1.0, 7.0),
      );
    }

    final shoulder = Paint()
      ..color = const Color(0xFF8A9690).withValues(alpha: 0.35)
      ..strokeWidth = (size.width * 0.006).clamp(1.0, 3.0)
      ..style = PaintingStyle.stroke;
    final edge = Path()
      ..moveTo(size.width * 0.42, horizon)
      ..lineTo(size.width * 0.09, size.height);
    edge.moveTo(size.width * 0.58, horizon);
    edge.lineTo(size.width * 0.91, size.height);
    canvas.drawPath(edge, shoulder);
  }

  @override
  bool shouldRepaint(covariant _RoadArtworkPainter oldDelegate) => false;
}