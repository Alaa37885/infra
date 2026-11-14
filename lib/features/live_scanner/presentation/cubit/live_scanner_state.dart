import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inframind/features/live_scanner/data/services/ai_inference_service.dart';

abstract class LiveScannerState {
  const LiveScannerState({
    required this.isScanning,
    required this.isPaused,
    required this.isAutoSaving,
    required this.controller,
    required this.detections,
    required this.currentPosition,
    required this.currentAddress,
    required this.sessionDetectionsCount,
    required this.avgConfidence,
    required this.isSaving,
    this.errorMessage,
  });

  final bool isScanning;
  final bool isPaused;
  final bool isAutoSaving;
  final CameraController? controller;
  final List<DetectedBox> detections;
  final Position? currentPosition;
  final String currentAddress;
  final int sessionDetectionsCount;
  final double avgConfidence;
  final bool isSaving;
  final String? errorMessage;

  LiveScannerState copyWith({
    bool? isScanning,
    bool? isPaused,
    bool? isAutoSaving,
    CameraController? controller,
    List<DetectedBox>? detections,
    Position? currentPosition,
    String? currentAddress,
    int? sessionDetectionsCount,
    double? avgConfidence,
    bool? isSaving,
    String? errorMessage,
  });
}

class LiveScannerInitial extends LiveScannerState {
  const LiveScannerInitial()
      : super(
          isScanning: false,
          isPaused: false,
          isAutoSaving: true,
          controller: null,
          detections: const [],
          currentPosition: null,
          currentAddress: 'جاري تحديد الموقع...',
          sessionDetectionsCount: 0,
          avgConfidence: 0.0,
          isSaving: false,
        );

  @override
  LiveScannerInitial copyWith({
    bool? isScanning,
    bool? isPaused,
    bool? isAutoSaving,
    CameraController? controller,
    List<DetectedBox>? detections,
    Position? currentPosition,
    String? currentAddress,
    int? sessionDetectionsCount,
    double? avgConfidence,
    bool? isSaving,
    String? errorMessage,
  }) {
    return LiveScannerInitial();
  }
}

class LiveScannerActive extends LiveScannerState {
  const LiveScannerActive({
    required super.isScanning,
    required super.isPaused,
    required super.isAutoSaving,
    required super.controller,
    required super.detections,
    required super.currentPosition,
    required super.currentAddress,
    required super.sessionDetectionsCount,
    required super.avgConfidence,
    required super.isSaving,
    super.errorMessage,
  });

  @override
  LiveScannerActive copyWith({
    bool? isScanning,
    bool? isPaused,
    bool? isAutoSaving,
    CameraController? controller,
    List<DetectedBox>? detections,
    Position? currentPosition,
    String? currentAddress,
    int? sessionDetectionsCount,
    double? avgConfidence,
    bool? isSaving,
    String? errorMessage,
  }) {
    return LiveScannerActive(
      isScanning: isScanning ?? this.isScanning,
      isPaused: isPaused ?? this.isPaused,
      isAutoSaving: isAutoSaving ?? this.isAutoSaving,
      controller: controller ?? this.controller,
      detections: detections ?? this.detections,
      currentPosition: currentPosition ?? this.currentPosition,
      currentAddress: currentAddress ?? this.currentAddress,
      sessionDetectionsCount: sessionDetectionsCount ?? this.sessionDetectionsCount,
      avgConfidence: avgConfidence ?? this.avgConfidence,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
