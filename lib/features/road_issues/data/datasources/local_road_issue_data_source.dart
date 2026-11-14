import 'package:inframind/features/road_issues/data/datasources/road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/models/road_issue_model.dart';

class LocalRoadIssueDataSource implements RoadIssueDataSource {
  @override
  Future<List<RoadIssueModel>> getAll() async => [
        RoadIssueModel(
          id: 'INF-9021',
          title: 'حفرة عميقة في الأسفلت',
          location: 'طريق صلاح سالم، القاهرة',
          severity: 'high',
          status: 'repairing',
          reportedAt: DateTime(2026, 11, 5, 10, 25),
          confidence: 0.92,
          latitude: 30.0444,
          longitude: 31.2357,
        ),
        RoadIssueModel(
          id: 'INF-9020',
          title: 'شق طولي طارئ',
          location: 'محور الشهيد، التجمع',
          severity: 'high',
          status: 'completed',
          reportedAt: DateTime(2026, 11, 4, 9, 10),
          confidence: 0.88,
          latitude: 30.0500,
          longitude: 31.2500,
        ),
        RoadIssueModel(
          id: 'INF-9019',
          title: 'هبوط أرضي جزئي',
          location: 'كورنيش النيل، المعادي',
          severity: 'medium',
          status: 'underReview',
          reportedAt: DateTime(2026, 11, 3, 16, 40),
          confidence: 0.79,
          latitude: 29.9600,
          longitude: 31.2500,
        ),
        RoadIssueModel(
          id: 'INF-9018',
          title: 'تآكل في الطبقة السطحية',
          location: 'طريق الدائري، الجيزة',
          severity: 'low',
          status: 'completed',
          reportedAt: DateTime(2026, 11, 2, 13, 15),
          confidence: 0.85,
          latitude: 30.0100,
          longitude: 31.2000,
        ),
      ];
}
