import 'package:flutter/material.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/core/widgets/road_artwork.dart';
import 'package:inframind/core/utils/maps_helper.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, required this.roadIssues});

  final Future<List<RoadIssue>> roadIssues;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedStatus = 'الكل';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والسجلات الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.gold),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<RoadIssue>>(
        future: widget.roadIssues,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذر تحميل السجلات'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data!;
          final filteredReports = _selectedStatus == 'الكل'
              ? reports
              : reports.where((report) => _statusLabel(report.status) == _selectedStatus).toList();
          return Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildStatusChip('الكل'),
                  _buildStatusChip('قيد الإصلاح'),
                  _buildStatusChip('قيد المراجعة'),
                  _buildStatusChip('مكتمل'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Reports List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                final report = filteredReports[index];
                final statusColor = _statusColor(report.status);
                final priorityColor = _severityColor(report.severity);
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceGlassBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Thumbnail Image
                      Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const RoadArtwork(),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('${(report.confidence * 100).round()}%', style: const TextStyle(fontSize: 8, color: AppColors.goldLight, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(report.id, style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                                  ),
                                  child: Text(_statusLabel(report.status), style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(report.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            // Clickable Google Maps Location Link
                            InkWell(
                              onTap: () => MapsHelper.openLocationOnGoogleMaps(report.location),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 13, color: AppColors.gold),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      report.location,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.goldLight,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.open_in_new, size: 11, color: AppColors.gold),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formattedDate(report.reportedAt), style: const TextStyle(fontSize: 10, color: AppColors.textGray)),
                                Row(
                                  children: [
                                    Container(width: 6, height: 6, decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    Text('أولوية ${_severityLabel(report.severity)}', style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
        },
      ),
    );
  }

  String _statusLabel(RoadIssueStatus status) => switch (status) {
        RoadIssueStatus.repairing => 'قيد الإصلاح',
        RoadIssueStatus.completed => 'مكتمل',
        RoadIssueStatus.underReview => 'قيد المراجعة',
      };

  Color _statusColor(RoadIssueStatus status) => switch (status) {
        RoadIssueStatus.repairing => AppColors.gold,
        RoadIssueStatus.completed => AppColors.greenLight,
        RoadIssueStatus.underReview => AppColors.textGray,
      };

  String _severityLabel(IssueSeverity severity) => switch (severity) {
        IssueSeverity.high => 'عالية',
        IssueSeverity.medium => 'متوسطة',
        IssueSeverity.low => 'منخفضة',
      };

  Color _severityColor(IssueSeverity severity) => switch (severity) {
        IssueSeverity.high => AppColors.red,
        IssueSeverity.medium => AppColors.gold,
        IssueSeverity.low => AppColors.greenLight,
      };

  String _formattedDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')} نوفمبر ${date.year}';

  Widget _buildStatusChip(String label) {
    final isSelected = _selectedStatus == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = label;
          });
        },
        selectedColor: AppColors.gold,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.background : AppColors.textWhite,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        side: BorderSide(color: isSelected ? AppColors.gold : AppColors.surfaceGlassBorder),
      ),
    );
  }
}
