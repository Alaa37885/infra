import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inframind/core/network/api_config.dart';
import 'package:inframind/features/road_issues/data/datasources/road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/models/road_issue_model.dart';
import 'package:inframind/features/road_issues/data/datasources/local_road_issue_data_source.dart';

class RemoteRoadIssueDataSource implements RoadIssueDataSource {
  final http.Client client;

  RemoteRoadIssueDataSource({required this.client});

  @override
  Future<List<RoadIssueModel>> getAll() async {
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
      debugPrint('Remote API error: $e. Falling back to local mock data source for seamless demo.');
      // Fallback to local data source when FastAPI backend is not yet reachable
      return LocalRoadIssueDataSource().getAll();
    }
  }
}
