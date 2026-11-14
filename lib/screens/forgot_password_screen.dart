import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.getRoadIssues});

  final dynamic getRoadIssues;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _controller = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.gold, width: 2),
                ),
                child: const Icon(Icons.lock_reset_rounded, size: 48, color: AppColors.gold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'نسيت كلمة المرور؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل بريدك الإلكتروني أو رقم الهاتف المسجل، وسنرسل لك تعليمات إعادة التعيين.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textGrayLight),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceGlassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('البريد الإلكتروني أو رقم الهاتف', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'name@example.com أو 01xxxxxxxxx',
                      hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 13),
                      prefixIcon: const Icon(Icons.contact_mail_outlined, color: AppColors.gold),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _sent = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إرسال رابط الاستعادة بنجاح')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                    ),
                    child: const Text('إرسال رابط الاستعادة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  if (_sent) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.greenLight.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'تم إرسال التعليمات بنجاح. تحقق من بريدك الإلكتروني أو رسائل هاتفك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.greenLight, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('العودة لتسجيل الدخول', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
