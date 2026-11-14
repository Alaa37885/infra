import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/features/authentication/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.getRoadIssues});

  final dynamic getRoadIssues;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'category': 'AI ROAD DETECTION',
      'title': 'اكتشف أضرار الطرق بالذكاء الاصطناعي',
      'description': 'وجه الكاميرا نحو الطريق، ودع الذكاء الاصطناعي يرصد الحفر والشققات بدقة.',
      'badge': 'رصد ذكي • القاهرة',
      'badgeIcon': Icons.camera_alt_outlined,
      'image': 'assets/onboarding1.jpg',
      'fallback': 'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=1080&q=80',
    },
    {
      'category': 'LIVE GEO INTELLIGENCE',
      'title': 'تابع الأولويات والخريطة لحظيًا',
      'description': 'اعرف أين يحتاج الطريق إلى تدخلك ورتب البلاغات حسب الأولوية والموقع.',
      'badge': 'الأولوية أولاً • القاهرة',
      'badgeIcon': Icons.map_outlined,
      'image': 'assets/onboarding2.jpg',
      'fallback': 'https://images.unsplash.com/photo-1508873696983-2df5c92063c7?auto=format&fit=crop&w=1080&q=80',
    },
    {
      'category': 'TOGETHER FOR EGYPT',
      'title': 'ساهم في تحسين طرق مصر',
      'description': 'كل بلاغ خطوة نحو صيانة أسرع. شارك فرق العمل في بناء طرق أكثر أماناً للجميع.',
      'badge': 'معاً نحو أكثر أماناً',
      'badgeIcon': Icons.shield_outlined,
      'image': 'assets/onboarding3.jpg',
      'fallback': 'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?auto=format&fit=crop&w=1080&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen(getRoadIssues: widget.getRoadIssues)),
                      );
                    },
                    child: const Text('تخطي', style: TextStyle(color: AppColors.textGray, fontSize: 14)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'مصر',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.gold),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'InfraMind',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.surfaceGlassBorder),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  slide['image']!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.network(
                                    slide['fallback']!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.background.withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.surfaceGlassBorder),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(slide['badgeIcon'] as IconData, color: AppColors.gold, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          slide['badge'] as String,
                                          style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          slide['category'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          slide['title'] as String,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          slide['description'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrayLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? AppColors.gold : AppColors.surfaceGlassBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginScreen(getRoadIssues: widget.getRoadIssues)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: AppColors.background,
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        _currentIndex == _slides.length - 1 ? 'ابدأ الآن' : 'التالي',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
