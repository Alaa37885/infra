import 'package:inframind/features/road_issues/data/models/road_issue_model.dart';

abstract interface class RoadIssueDataSource {
  Future<List<RoadIssueModel>> getAll();
}
