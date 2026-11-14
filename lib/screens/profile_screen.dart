import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.getRoadIssues});

  final dynamic getRoadIssues;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'أحمد حسن');
  final _phoneController = TextEditingController(text: '+20 1012345678');
  final _emailController = TextEditingController(text: 'ahmed.hassan@example.com');
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit, color: AppColors.gold),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حفظ تعديلات الملف الشخصي بنجاح')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar & Name Card
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.surface,
                        child: Text('أح', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.gold)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 14, color: AppColors.background),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('أحمد حسن', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  const Text('مهندس فحص وتفتيش هندسي - القاهرة', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('حساب معتمد - هيئة الطرق', style: TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // User Info Fields Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceGlassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('بيانات الحساب الأساسية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 16),
                  const Text('الاسم الكامل', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('البريد الإلكتروني', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _emailController,
                    enabled: false, // email usually locked
                    style: const TextStyle(color: AppColors.textGrayLight),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('رقم الهاتف', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _phoneController,
                    enabled: _isEditing,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions (Change password, Logout)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال رابط تغيير كلمة المرور إلى بريدك')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.gold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.lock_reset, color: AppColors.gold),
                label: const Text('تغيير كلمة المرور', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen(getRoadIssues: widget.getRoadIssues)),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
