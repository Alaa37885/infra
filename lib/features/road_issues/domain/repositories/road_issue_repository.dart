import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';

abstract interface class RoadIssueRepository {
  Future<List<RoadIssue>> getAll();
}