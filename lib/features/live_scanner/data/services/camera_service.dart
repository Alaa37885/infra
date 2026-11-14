import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isStreaming = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isStreaming => _isStreaming;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available on this device.');
      }

      // Select back camera if available
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      rethrow;
    }
  }

  Future<void> startImageStream(void Function(CameraImage image) onImage) async {
    if (_controller == null || !_isInitialized || _isStreaming) return;
    try {
      await _controller!.startImageStream((image) {
        onImage(image);
      });
      _isStreaming = true;
    } catch (e) {
      debugPrint('Error starting image stream: $e');
    }
  }

  Future<void> stopImageStream() async {
    if (_controller == null || !_isStreaming) return;
    try {
      if (_controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }
      _isStreaming = false;
    } catch (e) {
      debugPrint('Error stopping image stream: $e');
    }
  }

  Future<void> dispose() async {
    await stopImageStream();
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}
