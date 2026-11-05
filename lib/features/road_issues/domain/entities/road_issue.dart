enum IssueSeverity { high, medium, low }

enum RoadIssueStatus { repairing, completed, underReview }

class RoadIssue {
  const RoadIssue({
    required this.id,
    required this.title,
    required this.location,
    required this.severity,
    required this.status,
    required this.reportedAt,
    required this.confidence,
    this.imageUrl,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String location;
  final IssueSeverity severity;
  final RoadIssueStatus status;
  final DateTime reportedAt;
  final double confidence;
  final String? imageUrl;
  final String? thumbnailUrl;
}
