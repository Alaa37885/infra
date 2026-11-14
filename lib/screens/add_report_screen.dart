import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  String _damageType = 'حفرة عميقة';
  String _severity = 'عالية';
  final _locationController = TextEditingController(text: 'طريق صلاح سالم، القاهرة (GPS)');
  final _descriptionController = TextEditingController();
  bool _hasImage = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: AppColors.greenLight, size: 28),
            SizedBox(width: 10),
            Text('تم إرسال البلاغ بنجاح'),
          ],
        ),
        content: const Text(
          'شكراً لمساهمتك الوطنية. تم تسجيل البلاغ برقم #INF-9025 وإرساله لهيئة الطرق والكباري.',
          style: TextStyle(color: AppColors.textGrayLight, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.background,
            ),
            child: const Text('حسناً', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة بلاغ جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Capture Card
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceGlassBorder),
              ),
              child: _hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=600&q=80',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => _hasImage = false),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('إعادة التقاط'),
                          ),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () => setState(() => _hasImage = true),
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded, color: AppColors.gold, size: 36),
                          ),
                          const SizedBox(height: 12),
                          const Text('التقاط صورة للضرر أو اختيار من المعرض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          const Text('انقر هنا لتفعيل الكاميرا', style: TextStyle(color: AppColors.textGray, fontSize: 11)),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Location Card
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
                  const Text('موقع البلاغ (GPS)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.gold),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.map, color: AppColors.gold),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تحديد الموقع بدقة عبر الأقمار الصناعية')),
                          );
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Damage Type Selector
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
                  const Text('نوع الضرر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildTypeChip('حفرة عميقة', Icons.warning),
                      const SizedBox(width: 8),
                      _buildTypeChip('شق طولي', Icons.linear_scale),
                      const SizedBox(width: 8),
                      _buildTypeChip('هبوط أرضي', Icons.terrain),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Severity Selector
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
                  const Text('مستوى الخطورة والأولوية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSeverityChip('عالية', AppColors.red),
                      const SizedBox(width: 8),
                      _buildSeverityChip('متوسطة', AppColors.gold),
                      const SizedBox(width: 8),
                      _buildSeverityChip('منخفضة', AppColors.greenLight),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Optional Description
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
                  const Text('وصف إضافي (اختياري)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب تفاصيل إضافية عن الضرر أو حجمه...',
                      hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.background,
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.send_rounded),
                label: const Text('إرسال البلاغ رسمياً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = _damageType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _damageType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold.withValues(alpha: 0.2) : AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.gold : AppColors.surfaceGlassBorder),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.gold : AppColors.textGray, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textGray)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityChip(String label, Color color) {
    final isSelected = _severity == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _severity = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? color : AppColors.surfaceGlassBorder),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textGray)),
          ),
        ),
      ),
    );
  }
}
