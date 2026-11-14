import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ScannerLocationService {
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  String _currentAddress = 'القاهرة، مصر (جاري تحديد الموقع...)';

  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;

  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking location permissions: $e');
      return false;
    }
  }

  Future<void> startTracking({required void Function(Position position, String address) onLocationUpdate}) async {
    final hasPermission = await checkAndRequestPermissions();
    if (!hasPermission) {
      // Fallback default position (Cairo)
      _currentPosition = Position(
        latitude: 30.0444,
        longitude: 31.2357,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 1.0,
      );
      onLocationUpdate(_currentPosition!, 'القاهرة، شارع التحرير (GPS افتراضي)');
      return;
    }

    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update every 5 meters
      );

      _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position position) {
          _currentPosition = position;
          _currentAddress = 'خط عرض: ${position.latitude.toStringAsFixed(4)}, خط طول: ${position.longitude.toStringAsFixed(4)}';
          onLocationUpdate(position, _currentAddress);
        },
        onError: (error) {
          debugPrint('Location stream error: $error');
        },
      );

      // Get initial position immediately
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _currentPosition = initialPosition;
      _currentAddress = 'خط عرض: ${initialPosition.latitude.toStringAsFixed(4)}, خط طول: ${initialPosition.longitude.toStringAsFixed(4)}';
      onLocationUpdate(initialPosition, _currentAddress);
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  Future<void> stopTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
}
