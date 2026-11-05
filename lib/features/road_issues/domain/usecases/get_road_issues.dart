import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/features/road_issues/domain/repositories/road_issue_repository.dart';

class GetRoadIssues {
  const GetRoadIssues(this._repository);

  final RoadIssueRepository _repository;

  Future<List<RoadIssue>> call() => _repository.getAll();
}