import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inframind/features/map/data/models/place_suggestion.dart';
import 'package:inframind/features/map/data/models/place.dart';

class MapsRepository {
  final http.Client client;
  final String apiKey; // Configure your Google Maps API key here

  MapsRepository({required this.client, this.apiKey = 'AIzaSy_YOUR_GOOGLE_MAPS_API_KEY'});

  Future<List<PlaceSuggestion>> fetchSuggestions(String place, String sessionToken) async {
    if (place.isEmpty) return [];
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$apiKey&input=${Uri.encodeComponent(place)}&sessiontoken=$sessionToken',
      );
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final List predictions = data['predictions'] ?? [];
          return predictions.map((json) => PlaceSuggestion.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('Error fetching place suggestions: $e');
    }
    return [];
  }

  Future<Place?> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&sessiontoken=$sessionToken&place_id=$placeId&fields=geometry,name',
      );
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return Place.fromJson(data);
        }
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
    return null;
  }
}
