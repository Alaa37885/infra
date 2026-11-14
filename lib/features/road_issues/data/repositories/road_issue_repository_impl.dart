import 'package:inframind/features/road_issues/data/datasources/road_issue_data_source.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/features/road_issues/domain/repositories/road_issue_repository.dart';

class RoadIssueRepositoryImpl implements RoadIssueRepository {
  const RoadIssueRepositoryImpl(this._dataSource);

  final RoadIssueDataSource _dataSource;

  @override
  Future<List<RoadIssue>> getAll() async =>
      (await _dataSource.getAll()).map((model) => model.toEntity()).toList();
}
