import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/core/utils/maps_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.roadIssues});

  final Future<List<RoadIssue>> roadIssues;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'الكل';
  RoadIssue? _activeMarker;

  Color _severityColor(IssueSeverity severity) => switch (severity) {
        IssueSeverity.high => AppColors.red,
        IssueSeverity.medium => AppColors.gold,
        IssueSeverity.low => AppColors.greenLight,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة رصد الأضرار الذكية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_rounded, color: AppColors.gold),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<RoadIssue>>(
        future: widget.roadIssues,
        builder: (context, snapshot) {
          final issues = snapshot.data ?? [];
          return Stack(
            fit: StackFit.expand,
            children: [
              // Dark Map Background Mock
              Container(
                color: const Color(0xFF07111A),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: MapGridPainter(),
                    ),
                    Positioned(
                      top: 100,
                      left: 50,
                      right: 50,
                      child: Container(height: 6, color: Colors.white10),
                    ),
                    Positioned(
                      top: 250,
                      left: 20,
                      right: 20,
                      child: Container(height: 8, color: Colors.white10),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 150,
                      child: Container(width: 8, color: Colors.white10),
                    ),

                    // Dynamic Map Markers from API Issues
                    ...issues.asMap().entries.map((entry) {
                      final index = entry.key;
                      final issue = entry.value;
                      if (_selectedFilter != 'الكل' && _severityLabel(issue.severity) != _selectedFilter) {
                        return const SizedBox.shrink();
                      }
                      // Distribute dummy map coordinates visually
                      final top = 0.2 + ((index * 0.15) % 0.6);
                      final left = 0.2 + ((index * 0.25) % 0.7);
                      final color = _severityColor(issue.severity);

                      return Positioned(
                        top: MediaQuery.of(context).size.height * top,
                        left: MediaQuery.of(context).size.width * left,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeMarker = issue;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: color, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.warning_rounded,
                              color: color,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Top Filter Chips
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildFilterChip('الكل'),
                      _buildFilterChip('عالية'),
                      _buildFilterChip('متوسطة'),
                      _buildFilterChip('منخفضة'),
                    ],
                  ),
                ),
              ),

              // Bottom Sheet Preview when Marker Selected
              if (_activeMarker != null)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceGlassBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _severityColor(_activeMarker!.severity),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _activeMarker!.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: AppColors.textGray),
                              onPressed: () {
                                setState(() {
                                  _activeMarker = null;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Clickable Location Link to Google Maps
                        InkWell(
                          onTap: () => MapsHelper.openLocationOnGoogleMaps(_activeMarker!.location),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppColors.gold),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _activeMarker!.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.goldLight,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.open_in_new, size: 12, color: AppColors.gold),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'تم الكشف بواسطة وحدة الذكاء الاصطناعي - InfraMind AI. يحتاج إلى تدخل عاجل للصيانة.',
                          style: TextStyle(fontSize: 12, color: AppColors.textGrayLight),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  MapsHelper.openLocationOnGoogleMaps(_activeMarker!.location);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.map_rounded, size: 16),
                                label: const Text('فتح في جوجل مابس', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _severityLabel(IssueSeverity severity) => switch (severity) {
        IssueSeverity.high => 'عالية',
        IssueSeverity.medium => 'متوسطة',
        IssueSeverity.low => 'منخفضة',
      };

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFieldChange(label);
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

  void _selectedFieldChange(String label) {
    _selectedFilter = label;
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const gridSize = 40.0;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
