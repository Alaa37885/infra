import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inframind/core/di/app_dependencies.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(InfraMindApp(dependencies: AppDependencies.create()));
}

class InfraMindApp extends StatelessWidget {
  const InfraMindApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfraMind مصر',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.12),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      home: SplashScreen(getRoadIssues: dependencies.getRoadIssues),
    );
  }
}
