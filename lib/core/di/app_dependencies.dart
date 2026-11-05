import 'package:inframind/features/road_issues/data/datasources/local_road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/repositories/road_issue_repository_impl.dart';
import 'package:inframind/features/road_issues/domain/usecases/get_road_issues.dart';

class AppDependencies {
  const AppDependencies({required this.getRoadIssues});

  final GetRoadIssues getRoadIssues;

  factory AppDependencies.create() {
    final dataSource = LocalRoadIssueDataSource();
    final repository = RoadIssueRepositoryImpl(dataSource);

    return AppDependencies(getRoadIssues: GetRoadIssues(repository));
  }
}