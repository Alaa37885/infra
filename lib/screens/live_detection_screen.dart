import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/core/widgets/road_artwork.dart';

class LiveDetectionScreen extends StatefulWidget {
  const LiveDetectionScreen({super.key});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen> with SingleTickerProviderStateMixin {
  bool _isAutoSaving = true;
  bool _isScanning = true;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated Camera Background (Road View)
          const RoadArtwork(),

          // Dark Overlay for contrast
          Container(
            color: Colors.black.withValues(alpha:0.3),
          ),

          // Top Header / Status bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha:0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceGlassBorder),
                    ),
                    child: Row(
                      children: [
                        FadeTransition(
                          opacity: _pulseController,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'AI LIVE SCANNER',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha:0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceGlassBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.gold, size: 14),
                        SizedBox(width: 4),
                        Text('القاهرة، مصر', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bounding Boxes Simulation (AI Detection)
          // Box 1: Pothole
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('حفرة (Pothole) 0.92', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 130,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.red, width: 2.5),
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.red.withValues(alpha:0.15),
                  ),
                ),
              ],
            ),
          ),

          // Box 2: Crack
          Positioned(
            top: MediaQuery.of(context).size.height * 0.52,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('شق طولي (Crack) 0.87', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold, width: 2.5),
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.gold.withValues(alpha:0.15),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Glassmorphic Control Panel
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha:0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceGlassBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('الاكتشافات', '3 نشط', Icons.radar, AppColors.red),
                        Container(width: 1, height: 30, color: Colors.white24),
                        _buildStatItem('مستوى الثقة', '91.5%', Icons.verified, AppColors.gold),
                        Container(width: 1, height: 30, color: Colors.white24),
                        _buildStatItem('الحفظ التلقائي', _isAutoSaving ? 'مفعل' : 'متوقف', Icons.save_alt, AppColors.greenLight),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isScanning = !_isScanning;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_isScanning ? 'تم استئناف المسح' : 'تم إيقاف المسح مؤقتاً')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow, color: AppColors.red),
                            label: Text(_isScanning ? 'إيقاف مؤقت' : 'استئناف', style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isAutoSaving = !_isAutoSaving;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.background,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.cloud_upload_rounded),
                            label: const Text('حفظ وبلاغ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textGray)),
      ],
    );
  }
}
