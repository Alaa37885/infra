import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DetectedBox {
  const DetectedBox({
    required this.label,
    required this.className,
    required this.confidence,
    required this.ymin,
    required this.xmin,
    required this.ymax,
    required this.xmax,
    required this.severity,
  });

  final String label;
  final String className;
  final double confidence;
  final double ymin; // 0.0 to 1.0
  final double xmin;
  final double ymax;
  final double xmax;
  final String severity; // 'high', 'medium', 'low'

  factory DetectedBox.fromJson(Map<String, dynamic> json) {
    return DetectedBox(
      label: json['label'] ?? json['tag'] ?? 'Pothole (D00)',
      className: json['class_name'] ?? json['tag'] ?? 'D00',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.85,
      ymin: (json['ymin'] as num?)?.toDouble() ?? 0.3,
      xmin: (json['xmin'] as num?)?.toDouble() ?? 0.2,
      ymax: (json['ymax'] as num?)?.toDouble() ?? 0.5,
      xmax: (json['xmax'] as num?)?.toDouble() ?? 0.5,
      severity: json['severity'] ?? 'high',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'class_name': className,
        'confidence': confidence,
        'ymin': ymin,
        'xmin': xmin,
        'ymax': ymax,
        'xmax': xmax,
        'severity': severity,
      };
}

class AiInferenceService {
  final http.Client client;

  AiInferenceService({required this.client});

  /// Simulates real-time AI detections locally for frontend-only preparation.
  Future<List<DetectedBox>> detectRoadIssues(CameraImage image, {double lat = 30.0444, double lng = 31.2357}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _getSimulatedDetections();
  }

  List<DetectedBox> _getSimulatedDetections() {
    return [
      const DetectedBox(
        label: 'حفرة رئيسية (D00 Pothole)',
        className: 'D00',
        confidence: 0.93,
        ymin: 0.32,
        xmin: 0.20,
        ymax: 0.50,
        xmax: 0.45,
        severity: 'high',
      ),
      const DetectedBox(
        label: 'شق طولي (D10 Crack)',
        className: 'D10',
        confidence: 0.88,
        ymin: 0.55,
        xmin: 0.55,
        ymax: 0.72,
        xmax: 0.85,
        severity: 'medium',
      ),
    ];
  }

  /// Save road observation report (Frontend-only mock implementation)
  Future<bool> saveRoadObservation({
    required List<DetectedBox> detections,
    required double lat,
    required double lng,
    required String address,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('Road observation saved locally successfully (Frontend-only mock mode).');
      return true;
    } catch (e) {
      debugPrint('Error saving road observation locally: $e');
      return true;
    }
  }

  void dispose() {
    // Cleanup if needed
  }
}
