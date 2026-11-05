import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _confidenceThreshold = 85.0;
  bool _autoSave = true;
  bool _offlineMode = false;
  String _videoQuality = '4K 60FPS (عالي الدقة)';
  String _language = 'العربية (مصر)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات النظام الذكي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // User Profile Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceGlassBorder),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.gold,
                  child: Text(
                    'م.أ',
                    style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('م. أحمد المصري', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text('الهيئة العامة للطرق والكباري - مصر', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('مهندس فحص معتمد', style: TextStyle(fontSize: 10, color: AppColors.gold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // AI Model Settings Section
          const Text('إعدادات نموذج الذكاء الاصطناعي (AI)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
          const SizedBox(height: 12),

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
                    const Text('مستوى الثقة الأدنى للكشف (Confidence Threshold)', style: TextStyle(fontSize: 13)),
                    Text('${_confidenceThreshold.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold)),
                  ],
                ),
                Slider(
                  value: _confidenceThreshold,
                  min: 50.0,
                  max: 95.0,
                  divisions: 9,
                  activeColor: AppColors.gold,
                  inactiveColor: AppColors.background,
                  onChanged: (value) {
                    setState(() {
                      _confidenceThreshold = value;
                    });
                  },
                ),
                const Text(
                  'تحديد الحد الأدنى لنسبة ثقة النموذج قبل تسجيل البلاغ تلقائياً.',
                  style: TextStyle(fontSize: 11, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // General Settings Container
          Material(
            color: AppColors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.surfaceGlassBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('الحفظ التلقائي للبلاغات', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('رفع البلاغات للخادم السحابي فور رصدها', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                  value: _autoSave,
                  activeColor: AppColors.gold,
                  onChanged: (val) => setState(() => _autoSave = val),
                ),
                const Divider(color: Colors.white12, height: 1),
                SwitchListTile(
                  title: const Text('الوضع المحلي (Offline Mode)', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('حفظ البيانات محلياً في حالة ضعف الشبكة', style: TextStyle(fontSize: 11, color: AppColors.textGray)),
                  value: _offlineMode,
                  activeColor: AppColors.gold,
                  onChanged: (val) => setState(() => _offlineMode = val),
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  title: const Text('جودة تصوير الفيديو', style: TextStyle(fontSize: 14)),
                  subtitle: Text(_videoQuality, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGray),
                  onTap: () {
                    _showQualityDialog();
                  },
                ),
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  title: const Text('لغة التطبيق', style: TextStyle(fontSize: 14)),
                  subtitle: Text(_language, style: const TextStyle(fontSize: 11, color: AppColors.textGray)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textGray),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About / Logout
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, color: AppColors.red),
              label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'InfraMind مصر - الإصدار 1.0.0 (Build 2026)',
              style: TextStyle(fontSize: 11, color: AppColors.textGray),
            ),
          ),
        ],
      ),
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('اختر جودة الفيديو'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('4K 60FPS (عالي الدقة)'),
              onTap: () {
                setState(() => _videoQuality = '4K 60FPS (عالي الدقة)');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('1080P 60FPS (موصى به)'),
              onTap: () {
                setState(() => _videoQuality = '1080P 60FPS (موصى به)');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
