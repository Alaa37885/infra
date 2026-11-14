import 'package:http/http.dart' as http;
import 'package:inframind/features/road_issues/data/datasources/local_road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/datasources/remote_road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/datasources/road_issue_data_source.dart';
import 'package:inframind/features/road_issues/data/repositories/road_issue_repository_impl.dart';
import 'package:inframind/features/road_issues/domain/usecases/get_road_issues.dart';

class AppDependencies {
  const AppDependencies({required this.getRoadIssues});

  final GetRoadIssues getRoadIssues;

  /// Factory constructor to initialize dependencies.
  /// Set [useMockData] to false when the actual FastAPI backend is running and confirmed.
  factory AppDependencies.create({bool useMockData = true}) {
    final RoadIssueDataSource dataSource;

    if (useMockData) {
      dataSource = LocalRoadIssueDataSource();
    } else {
      dataSource = RemoteRoadIssueDataSource(client: http.Client());
    }

    final repository = RoadIssueRepositoryImpl(dataSource);

    return AppDependencies(getRoadIssues: GetRoadIssues(repository));
  }
}
