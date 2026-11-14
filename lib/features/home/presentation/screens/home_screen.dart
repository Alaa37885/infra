import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/core/widgets/road_artwork.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:inframind/core/utils/maps_helper.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;
  final Future<List<RoadIssue>> roadIssues;
  final VoidCallback? onRefresh;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
    required this.roadIssues,
    this.onRefresh,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    } else {
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    widget.onNavigateTab(4);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surface,
                    child: Text(
                      'أح',
                      style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('لا توجد إشعارات جديدة')),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, color: AppColors.textWhite, size: 24),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'InfraMind',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textWhite, height: 1.0),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'مصر',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.gold, height: 1.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.shield_rounded, color: AppColors.gold, size: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.gold,
        backgroundColor: AppColors.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'أهلاً بك',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textWhite),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'معاً، نحو طرق أكثر أماناً',
                        style: TextStyle(fontSize: 12, color: AppColors.textGray),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => MapsHelper.openLocationOnGoogleMaps('القاهرة، مصر'),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.surfaceGlassBorder),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on, color: AppColors.gold, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'القاهرة، مصر',
                            style: TextStyle(fontSize: 11, color: AppColors.goldLight, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceGlassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 95,
                      width: 95,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 0.68,
                            strokeWidth: 9,
                            backgroundColor: AppColors.background,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('68%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('حالة مستقرة', style: TextStyle(fontSize: 10, color: AppColors.goldLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مؤشر سلامة الطرق',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textWhite),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '85 بلاغاً مسجلاً في القاهرة',
                            style: TextStyle(fontSize: 11, color: AppColors.textGray),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildPriorityItem('عالية', '12', AppColors.red),
                              _buildPriorityItem('متوسطة', '28', AppColors.gold),
                              _buildPriorityItem('منخفضة', '45', AppColors.greenLight),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceGlassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('↓ 18% عن الأسبوع السابق', style: TextStyle(fontSize: 10, color: AppColors.greenLight, fontWeight: FontWeight.bold)),
                        ),
                        const Text('اتجاه الأضرار', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 130,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const dates = ['30 أكت', '31', '1 نوف', '2', '3', '4', '5'];
                                  if (value.toInt() >= 0 && value.toInt() < dates.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(dates[value.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textGray)),
                                    );
                                  }
                                  return const Text('');
                                },
                                reservedSize: 24,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                const FlSpot(0, 3.5),
                                const FlSpot(1, 2.8),
                                const FlSpot(2, 3.2),
                                const FlSpot(3, 1.8),
                                const FlSpot(4, 1.2),
                                const FlSpot(5, 0.8),
                                const FlSpot(6, 0.5),
                              ],
                              isCurved: true,
                              color: AppColors.gold,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.gold.withValues(alpha: 0.18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'آخر الاكتشافات الحية',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.goldLight),
                  ),
                  TextButton(
                    onPressed: () => widget.onNavigateTab(3),
                    child: const Text('عرض الكل', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 142,
                child: FutureBuilder<List<RoadIssue>>(
                  future: widget.roadIssues,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) => Container(
                          width: 160,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'تعذر الاتصال بالخادم',
                          style: const TextStyle(fontSize: 12, color: AppColors.redLight),
                        ),
                      );
                    }
                    final issues = snapshot.data ?? [];
                    if (issues.isEmpty) {
                      return const Center(
                        child: Text('لا توجد بلاغات حالياً', style: TextStyle(color: AppColors.textGray)),
                      );
                    }
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: issues.map(_buildDiscoveryCard).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => widget.onNavigateTab(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.background,
                    elevation: 6,
                    shadowColor: AppColors.gold.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt_rounded, size: 24),
                  label: const Text(
                    'ابدأ المسح الحي (Live Scan)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textWhite),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
          ],
        ),
      ],
    );
  }

  Widget _buildDiscoveryCard(RoadIssue issue) {
    final badgeColor = switch (issue.severity) {
      IssueSeverity.high => AppColors.red,
      IssueSeverity.medium => AppColors.gold,
      IssueSeverity.low => AppColors.greenLight,
    };
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceGlassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                issue.thumbnailUrl != null || issue.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: issue.thumbnailUrl ?? issue.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold),
                          ),
                        ),
                        errorWidget: (context, url, error) => const RoadArtwork(),
                      )
                    : const RoadArtwork(),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('${(issue.confidence * 100).round()}%', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issue.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () => MapsHelper.openLocationOnGoogleMaps(issue.location),
                  child: Text(
                    issue.location,
                    style: const TextStyle(fontSize: 10, color: AppColors.goldLight, decoration: TextDecoration.underline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                const Text('منذ وقت قريب', style: TextStyle(fontSize: 10, color: AppColors.textGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
