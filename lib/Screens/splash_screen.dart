// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vedio_app/Page/test_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Set duration here
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TestPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.black],
                begin: Alignment.topRight,
                end: Alignment.bottomCenter)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline_sharp,
              color: Colors.black,
              size: 100,
            )
          ],
        ),
      ),
    );
  }
}
