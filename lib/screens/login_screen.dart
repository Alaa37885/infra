import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/screens/signup_screen.dart';
import 'package:inframind/screens/forgot_password_screen.dart';
import 'package:inframind/screens/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.getRoadIssues});

  final dynamic getRoadIssues;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'citizen'; // 'citizen' or 'company'

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Egyptian Road Image
          Image.network(
            'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1080&q=80',
            fit: BoxFit.cover,
          ),
          Container(
            color: AppColors.background.withValues(alpha: 0.90),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo Section matching Splash Screen & Reference Image
                  Center(
                    child: Stack(
                      alignment: Alignment.topRight,
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 80,
                              child: Image.asset(
                                'assets/شعار الطريق والأفق.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 100,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.shield, color: AppColors.background, size: 36),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'InfraMind',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37), // Gold
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'AI-Powered Road Governance',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFFD4AF37), // Gold
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // Egyptian Flag at top right of logo
                        Positioned(
                          right: 12,
                          top: -6,
                          child: SizedBox(
                            width: 36,
                            height: 25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/علم مصر.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.red,
                                  child: const Center(child: Text('🇪🇬', style: TextStyle(fontSize: 11))),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceGlassBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('نوع الحساب (الصلاحية)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedRole = 'citizen'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'citizen' ? AppColors.gold.withValues(alpha: 0.25) : AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _selectedRole == 'citizen' ? AppColors.gold : AppColors.surfaceGlassBorder),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'مواطن عادي',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _selectedRole == 'citizen' ? Colors.white : AppColors.textGray,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedRole = 'company'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'company' ? AppColors.gold.withValues(alpha: 0.25) : AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _selectedRole == 'company' ? AppColors.gold : AppColors.surfaceGlassBorder),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'شركة صيانة',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _selectedRole == 'company' ? Colors.white : AppColors.textGray,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        const Text('البريد الإلكتروني أو رقم الهاتف', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'name@example.com أو 01xxxxxxxxx',
                            hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 13),
                            prefixIcon: const Icon(Icons.person_outline, color: AppColors.gold),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('كلمة المرور', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 13),
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gold),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textGray),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen(getRoadIssues: widget.getRoadIssues)),
                              );
                            },
                            child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => MainNavigation(getRoadIssues: widget.getRoadIssues)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 6,
                          ),
                          child: const Text('تسجيل الدخول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟', style: TextStyle(color: AppColors.textGrayLight, fontSize: 13)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUpScreen(getRoadIssues: widget.getRoadIssues)),
                          );
                        },
                        child: const Text('إنشاء حساب جديد', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
