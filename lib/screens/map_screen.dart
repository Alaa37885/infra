import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/core/utils/maps_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.roadIssues, required this.onRefresh});

  final Future<List<RoadIssue>> roadIssues;
  final VoidCallback onRefresh;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'الكل';
  RoadIssue? _activeMarker;
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(30.0444, 31.2357); // Cairo default
  final double _currentZoom = 12.0;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _determineUserPosition();
  }

  Future<void> _determineUserPosition() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
          _locationError = 'خدمات الموقع (GPS) غير مفعلة.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
            _locationError = 'تم رفض صلاحية الوصول للموقع.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
          _locationError = 'صلاحية الموقع مرفوضة نهائياً، يرجى تفعيلها من إعدادات الهاتف.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentPosition = position;
        _currentCenter = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      _mapController.move(_currentCenter, 15.0);
    } on MissingPluginException {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'يرجى إعادة تشغيل التطبيق (Cold Restart) لتفعيل ربط الـ GPS.';
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'تعذر تحديد الموقع الحالي: $e';
      });
    }
  }

  void _centerOnUser() {
    if (_currentPosition != null) {
      final userLatLng = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _mapController.move(userLatLng, 15.0);
    } else {
      _determineUserPosition();
    }
  }

  Color _severityColor(IssueSeverity severity) => switch (severity) {
        IssueSeverity.high => AppColors.red,
        IssueSeverity.medium => AppColors.gold,
        IssueSeverity.low => AppColors.greenLight,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة رصد الأضرار الذكية (OSM)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.gold),
            onPressed: () {
              widget.onRefresh();
              _determineUserPosition();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تحديث الخريطة والبلاغات...')),
              );
            },
            tooltip: 'تحديث الخريطة',
          ),
        ],
      ),
      body: FutureBuilder<List<RoadIssue>>(
        future: widget.roadIssues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.red, size: 48),
                  const SizedBox(height: 12),
                  Text('تعذر تحميل البلاغات على الخريطة\n(${snapshot.error})', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textGrayLight)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: widget.onRefresh,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.background),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final issues = snapshot.data ?? [];

          // Build OpenStreetMap Markers ONLY for issues with valid GPS coordinates
          final List<Marker> markers = [];
          
          // User location marker if available
          if (_currentPosition != null) {
            markers.add(
              Marker(
                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.my_location, color: Colors.blue, size: 20),
                  ),
                ),
              ),
            );
          }

          for (final issue in issues) {
            if (_selectedFilter != 'الكل' && _severityLabel(issue.severity) != _selectedFilter) {
              continue;
            }

            // Strictly check if valid latitude and longitude exist from API/Repo
            if (issue.latitude != null && issue.longitude != null) {
              final color = _severityColor(issue.severity);
              markers.add(
                Marker(
                  point: LatLng(issue.latitude!, issue.longitude!),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeMarker = issue;
                      });
                      _mapController.move(LatLng(issue.latitude!, issue.longitude!), 16.0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // OpenStreetMap FlutterMap Widget
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentCenter,
                  initialZoom: _currentZoom,
                  onTap: (_, _) {
                    if (_activeMarker != null) {
                      setState(() {
                        _activeMarker = null;
                      });
                    }
                  },
                ),
                children: [
                  // OpenStreetMap Tile Layer
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.inframind',
                  ),
                  // Markers Layer
                  MarkerLayer(markers: markers),
                  // OSM Attribution
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                      ),
                    ],
                  ),
                ],
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

              // Location error or loading banner if any
              if (_locationError != null)
                Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.red.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_locationError!, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3)),
                        ),
                        TextButton(
                          onPressed: _determineUserPosition,
                          child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.goldLight, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
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
                        InkWell(
                          onTap: () => MapsHelper.openLocationOnGoogleMaps(_activeMarker!.location, lat: _activeMarker!.latitude, lng: _activeMarker!.longitude),
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
                                  MapsHelper.openLocationOnGoogleMaps(_activeMarker!.location, lat: _activeMarker!.latitude, lng: _activeMarker!.longitude);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.map_rounded, size: 16),
                                label: const Text('فتح في تطبيق الخرائط', style: TextStyle(fontWeight: FontWeight.bold)),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: _centerOnUser,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.gold,
          elevation: 4,
          child: _isLoadingLocation
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
              : const Icon(Icons.my_location_rounded),
        ),
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
      padding: const EdgeInsets.only(left: 3),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
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
