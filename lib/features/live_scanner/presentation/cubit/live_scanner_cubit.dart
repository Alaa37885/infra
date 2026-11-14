import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inframind/features/live_scanner/data/services/ai_inference_service.dart';
import 'package:inframind/features/live_scanner/data/services/camera_service.dart';
import 'package:inframind/features/live_scanner/data/services/scanner_location_service.dart';
import 'package:inframind/features/live_scanner/presentation/cubit/live_scanner_state.dart';

class LiveScannerCubit extends Cubit<LiveScannerState> {
  LiveScannerCubit({
    required CameraService cameraService,
    required AiInferenceService aiInferenceService,
    required ScannerLocationService locationService,
  })  : _cameraService = cameraService,
        _aiInferenceService = aiInferenceService,
        _locationService = locationService,
        super(const LiveScannerInitial());

  final CameraService _cameraService;
  final AiInferenceService _aiInferenceService;
  final ScannerLocationService _locationService;

  DateTime _lastInferenceTime = DateTime.now();
  bool _isProcessingFrame = false;

  Future<void> initializeScanner() async {
    try {
      emit(state.copyWith(errorMessage: null));

      // Initialize camera and location in parallel
      await Future.wait([
        _cameraService.initialize(),
        _locationService.startTracking(
          onLocationUpdate: (position, address) {
            if (!isClosed) {
              emit(state.copyWith(currentPosition: position, currentAddress: address));
            }
          },
        ),
      ]);

      emit(LiveScannerActive(
        isScanning: true,
        isPaused: false,
        isAutoSaving: true,
        controller: _cameraService.controller,
        detections: const [],
        currentPosition: _locationService.currentPosition,
        currentAddress: _locationService.currentAddress,
        sessionDetectionsCount: 0,
        avgConfidence: 0.0,
        isSaving: false,
      ));

      // Start image stream for AI inference
      await _cameraService.startImageStream(_onCameraImage);
    } catch (e) {
      debugPrint('Failed to initialize live scanner: $e');
      emit(state.copyWith(errorMessage: 'تعذر تشغيل الكاميرا أو نظام تحديد الموقع: $e'));
    }
  }

  void _onCameraImage(CameraImage image) async {
    if (state.isPaused || !state.isScanning || _isProcessingFrame) return;

    final now = DateTime.now();
    // Throttle inference: 400ms interval
    if (now.difference(_lastInferenceTime).inMilliseconds < 400) return;
    _lastInferenceTime = now;
    _isProcessingFrame = true;

    try {
      final lat = state.currentPosition?.latitude ?? 30.0444;
      final lng = state.currentPosition?.longitude ?? 31.2357;

      final detections = await _aiInferenceService.detectRoadIssues(image, lat: lat, lng: lng);

      if (!isClosed && state.isScanning && !state.isPaused) {
        int newCount = state.sessionDetectionsCount;
        double avgConf = state.avgConfidence;

        if (detections.isNotEmpty) {
          newCount += detections.length;
          final totalConf = detections.fold<double>(0.0, (sum, d) => sum + d.confidence);
          avgConf = totalConf / detections.length;

          // Auto-save observation if enabled
          if (state.isAutoSaving) {
            _aiInferenceService.saveRoadObservation(
              detections: detections,
              lat: lat,
              lng: lng,
              address: state.currentAddress,
            );
          }
        }

        emit(state.copyWith(
          detections: detections,
          sessionDetectionsCount: newCount,
          avgConfidence: avgConf,
        ));
      }
    } catch (e) {
      debugPrint('Error during frame inference: $e');
    } finally {
      _isProcessingFrame = false;
    }
  }

  void togglePause() {
    final paused = !state.isPaused;
    if (paused) {
      _cameraService.stopImageStream();
    } else {
      _cameraService.startImageStream(_onCameraImage);
    }
    emit(state.copyWith(isPaused: paused));
  }

  void toggleAutoSave() {
    emit(state.copyWith(isAutoSaving: !state.isAutoSaving));
  }

  Future<void> saveObservation() async {
    if (state.detections.isEmpty) return;
    emit(state.copyWith(isSaving: true));

    try {
      final lat = state.currentPosition?.latitude ?? 30.0444;
      final lng = state.currentPosition?.longitude ?? 31.2357;

      await _aiInferenceService.saveRoadObservation(
        detections: state.detections,
        lat: lat,
        lng: lng,
        address: state.currentAddress,
      );

      emit(state.copyWith(isSaving: false, sessionDetectionsCount: state.sessionDetectionsCount + 1));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: 'فشل حفظ البلاغ: $e'));
    }
  }

  @override
  Future<void> close() async {
    _aiInferenceService.dispose();
    await _cameraService.dispose();
    await _locationService.stopTracking();
    return super.close();
  }
}
