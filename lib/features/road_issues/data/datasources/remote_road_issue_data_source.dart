import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inframind/core/network/api_config.dart';
import 'package:inframind/features/road_issues/data/models/road_issue_model.dart';

class RemoteRoadIssueDataSource {
  final http.Client client;

  RemoteRoadIssueDataSource({required this.client});

  Future<List<RoadIssueModel>> fetchRoadIssues() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.roadIssues}'),
        headers: {
          'Content-Type': 'application/json',
          if (ApiConfig.authToken != null) 'Authorization': 'Bearer ${ApiConfig.authToken}',
        },
      ).timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => RoadIssueModel.fromJson(json)).toSet().toList();
      } else {
        throw Exception('فشل الاتصال بالخادم (رمز الاستجابة: ${response.statusCode})');
      }
    } catch (e) {
      // Fallback or rethrow for state handling (Loading / Error / Empty)
      throw Exception('تعذر جلب البيانات من الخادم: $e');
    }
  }
}
