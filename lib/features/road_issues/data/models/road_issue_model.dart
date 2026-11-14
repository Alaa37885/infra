import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';

class RoadIssueModel {
  const RoadIssueModel({
    required this.id,
    required this.title,
    required this.location,
    required this.severity,
    required this.status,
    required this.reportedAt,
    required this.confidence,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String title;
  final String location;
  final String severity;
  final String status;
  final DateTime reportedAt;
  final double confidence;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;

  factory RoadIssueModel.fromJson(Map<String, dynamic> json) {
    return RoadIssueModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      severity: json['severity'] ?? 'medium',
      status: json['status'] ?? 'underReview',
      reportedAt: json['reported_at'] != null ? DateTime.parse(json['reported_at']) : DateTime.now(),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.85,
      imageUrl: json['image_url'],
      thumbnailUrl: json['thumbnail_url'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  RoadIssue toEntity() => RoadIssue(
        id: id,
        title: title,
        location: location,
        severity: IssueSeverity.values.asNameMap()[severity] ?? IssueSeverity.medium,
        status: RoadIssueStatus.values.asNameMap()[status] ?? RoadIssueStatus.underReview,
        reportedAt: reportedAt,
        confidence: confidence,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        latitude: latitude,
        longitude: longitude,
      );
}
