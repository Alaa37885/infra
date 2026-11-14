import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final LatLng latLng;
  final String name;

  Place({required this.latLng, required this.name});

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['result']?['geometry']?['location'] ?? {};
    final lat = (location['lat'] as num?)?.toDouble() ?? 30.0444;
    final lng = (location['lng'] as num?)?.toDouble() ?? 31.2357;
    final name = json['result']?['name'] ?? 'موقع';
    return Place(latLng: LatLng(lat, lng), name: name);
  }
}
