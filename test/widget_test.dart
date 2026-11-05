import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inframind/core/di/app_dependencies.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/features/road_issues/domain/repositories/road_issue_repository.dart';
import 'package:inframind/features/road_issues/domain/usecases/get_road_issues.dart';
import 'package:inframind/screens/main_navigation.dart';

void main() {
  test('local data is mapped through the repository', () async {
    final issues = await AppDependencies.create().getRoadIssues();

    expect(issues, hasLength(4));
    expect(issues.first.id, 'INF-9021');
    expect(issues.first.severity, IssueSeverity.high);
  });

  testWidgets('loads road issues across app sections', (tester) async {
    final getRoadIssues = GetRoadIssues(_FakeRoadIssueRepository());

    await tester.pumpWidget(
      MaterialApp(home: MainNavigation(getRoadIssues: getRoadIssues)),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('أهلاً بك، م. أحمد'), findsOneWidget);

    await tester.tap(find.text('الخريطة'));
    await tester.pump();
    expect(find.text('خريطة رصد الأضرار الذكية'), findsOneWidget);

    await tester.tap(find.text('التقارير'));
    await tester.pump();
    expect(find.text('INF-9021'), findsOneWidget);
    expect(find.text('حفرة عميقة في الأسفلت'), findsOneWidget);
  });
}

class _FakeRoadIssueRepository implements RoadIssueRepository {
  @override
  Future<List<RoadIssue>> getAll() async => [
        RoadIssue(
          id: 'INF-9021',
          title: 'حفرة عميقة في الأسفلت',
          location: 'طريق صلاح سالم، القاهرة',
          severity: IssueSeverity.high,
          status: RoadIssueStatus.repairing,
          reportedAt: DateTime(2026, 11, 5),
          confidence: 0.92,
        ),
      ];
}
