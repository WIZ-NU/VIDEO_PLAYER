// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vedio_app/Page/test_page.dart';
import 'package:vedio_app/Service/firebase_api.dart';
import 'Screens/splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test',
      home: const SplashScreenPage(),
      navigatorKey: navigatorKey,
      routes: {
        '/video_viewer': (context) => const TestPage(),
      },
    );
  }
}
