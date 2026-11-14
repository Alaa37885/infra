import 'package:flutter/material.dart';
import 'package:inframind/features/road_issues/domain/usecases/get_road_issues.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.getRoadIssues});

  final GetRoadIssues getRoadIssues;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
              OnboardingScreen(getRoadIssues: widget.getRoadIssues),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient matching app theme
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F1B2B),
                  Color(0xFF16253B),
                  Color(0xFF0C1622),
                ],
              ),
            ),
          ),

          // Bottom Cairo Skyline & Road Image Asset
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 360,
            child: Image.asset(
              'assets/أفق القاهرة والطريق (1).png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF131D2E),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    
                    // Logo Section matching user reference image
                    Stack(
                      alignment: Alignment.topRight,
                      clipBehavior: Clip.none,
                      children: [
                        // Main Logo Graphic (خط الشعار 3)
                        Column(
                          children: [
                            SizedBox(
                              height: 90,
                              child: Image.asset(
                                'assets/شعار الطريق والأفق.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 110,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.shield, color: AppColors.background, size: 40),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // InfraMind Title in Golden Yellow
                            const Text(
                              'InfraMind',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37), // Gold
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Subtitle in Golden Yellow
                            const Text(
                              'AI-Powered Road Governance',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD4AF37), // Gold
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Egyptian Flag placed at the top right of the logo graphic
                        Positioned(
                          right: 12,
                          top: -6,
                          child: SizedBox(
                            width: 38,
                            height: 26,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/علم مصر.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.red,
                                  child: const Center(child: Text('🇪🇬', style: TextStyle(fontSize: 12))),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Tagline from Figma
                    const Text(
                      'طريق أفضل .. لمستقبل أذكى',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const Spacer(),

                    // Loader & "جاري التحميل..."
                    Column(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'جاري التحميل...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
