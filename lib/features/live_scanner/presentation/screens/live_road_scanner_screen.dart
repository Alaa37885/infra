import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/features/live_scanner/data/services/ai_inference_service.dart';
import 'package:inframind/features/live_scanner/data/services/camera_service.dart';
import 'package:inframind/features/live_scanner/data/services/scanner_location_service.dart';
import 'package:inframind/features/live_scanner/presentation/cubit/live_scanner_cubit.dart';
import 'package:inframind/features/live_scanner/presentation/cubit/live_scanner_state.dart';
import 'package:inframind/features/live_scanner/presentation/widgets/detection_overlay.dart';
import 'package:http/http.dart' as http;

class LiveRoadScannerScreen extends StatelessWidget {
  const LiveRoadScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LiveScannerCubit(
        cameraService: CameraService(),
        aiInferenceService: AiInferenceService(client: http.Client()),
        locationService: ScannerLocationService(),
      )..initializeScanner(),
      child: const _LiveRoadScannerView(),
    );
  }
}

class _LiveRoadScannerView extends StatefulWidget {
  const _LiveRoadScannerView();

  @override
  State<_LiveRoadScannerView> createState() => _LiveRoadScannerViewState();
}

class _LiveRoadScannerViewState extends State<_LiveRoadScannerView> with SingleTickerProviderStateMixin {
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
      body: BlocConsumer<LiveScannerCubit, LiveScannerState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.red),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LiveScannerCubit>();

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview or Road Camera Image Asset Background
              if (state.controller != null && state.controller!.value.isInitialized)
                CameraPreview(state.controller!)
              else
                Image.asset(
                  'assets/كاميرا الطريق.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  ),
                ),

              // AI Detection Bounding Boxes Overlay
              DetectionOverlay(detections: state.detections),

              // Dark Vignette / Gradient Overlay for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),

              // Top Header: Live Status & Location Badge
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.75),
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
                                decoration: BoxDecoration(
                                  color: state.isPaused ? AppColors.gold : AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.isPaused ? 'مسح متوقف مؤقتاً' : 'AI LIVE SCANNER',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.surfaceGlassBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.gold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              state.currentAddress.length > 20
                                  ? '${state.currentAddress.substring(0, 20)}...'
                                  : state.currentAddress,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Glassmorphic Control & Stats Panel
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(20),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('الاكتشافات', '${state.sessionDetectionsCount} نشط', Icons.radar, AppColors.red),
                            Container(width: 1, height: 30, color: Colors.white24),
                            _buildStatItem('مستوى الثقة', '${(state.avgConfidence * 100).round()}%', Icons.verified, AppColors.gold),
                            Container(width: 1, height: 30, color: Colors.white24),
                            _buildStatItem('الحفظ التلقائي', state.isAutoSaving ? 'مفعل' : 'متوقف', Icons.save_alt, AppColors.greenLight),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => cubit.togglePause(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause, color: AppColors.red),
                                label: Text(state.isPaused ? 'استئناف' : 'إيقاف مؤقت', style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: state.isSaving ? null : () => cubit.saveObservation(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.gold,
                                  foregroundColor: AppColors.background,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: state.isSaving
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background))
                                    : const Icon(Icons.cloud_upload_rounded),
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
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textGray)),
      ],
    );
  }
}
