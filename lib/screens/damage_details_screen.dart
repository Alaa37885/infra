import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/core/utils/maps_helper.dart';

class DamageDetailsScreen extends StatelessWidget {
  const DamageDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الضرر والبلاغ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.gold),
            onPressed: () {
              MapsHelper.openLocationOnGoogleMaps('طريق صلاح سالم، القاهرة');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large Damage Image
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('ثقة الذكاء الاصطناعي: 92%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),

            // Title & Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceGlassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('#INF-9021', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('قيد الإصلاح', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('حفرة عميقة في الأسفلت', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.gold),
                      const SizedBox(width: 6),
                      const Text('طريق صلاح سالم، القاهرة', style: TextStyle(fontSize: 12, color: AppColors.textGrayLight)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.gold),
                      const SizedBox(width: 6),
                      const Text('05 نوفمبر 2026 - 10:25 ص', style: TextStyle(fontSize: 12, color: AppColors.textGrayLight)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.gold),
                      const SizedBox(width: 6),
                      const Text('المُبلّغ: م. أحمد حسن (مستخدم)', style: TextStyle(fontSize: 12, color: AppColors.textGrayLight)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mini Map Location Card
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF07111A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceGlassBorder),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.location_pin, color: AppColors.red, size: 36),
                        SizedBox(height: 4),
                        Text('طريق صلاح سالم - القاهرة الكبرى', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: ElevatedButton.icon(
                      onPressed: () => MapsHelper.openLocationOnGoogleMaps('طريق صلاح سالم، القاهرة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: const Icon(Icons.map, size: 14),
                      label: const Text('فتح في جوجل مابس', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تحديث حالة البلاغ بنجاح')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.edit_note, color: AppColors.gold),
                    label: const Text('تغيير الحالة', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => MapsHelper.openLocationOnGoogleMaps('طريق صلاح سالم، القاهرة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.navigation_rounded),
                    label: const Text('مشاركة وتوجيه', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
