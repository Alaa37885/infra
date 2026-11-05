import 'package:url_launcher/url_launcher.dart';

class MapsHelper {
  static Future<void> openLocationOnGoogleMaps(String locationName, {double? lat, double? lng}) async {
    final Uri url;
    if (lat != null && lng != null) {
      url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      final encodedQuery = Uri.encodeComponent(locationName);
      url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedQuery');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch map url';
      }
    } catch (e) {
      // Fallback or print error
      print('Error launching maps: $e');
    }
  }
}
