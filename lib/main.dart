import 'package:flutter/material.dart';
import 'package:partywity/core/get_Dependency.dart';
import 'package:partywity/core/router.dart';
import 'package:partywity/core/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing dependencies
initDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Clean Arch Booking App',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
    );
  }
}