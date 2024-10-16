import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vedio_app/Screens/login_screen.dart';
import 'package:vedio_app/Screens/splash_screen.dart';
import 'package:vedio_app/Vedio/vedio_viewer.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _checkLoginState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Show the splash screen while waiting
        } else if (snapshot.hasData) {
          var userData = snapshot.data!;
          return VideoScreen(
            dbRef: FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(userData['uid']),
            username: userData['username'],
            email: userData['email'],
          );
        } else {
          return const LoginScreen(title: 'Login');
        }
      },
    );
  }

  Future<Map<String, dynamic>?> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      String? uid = prefs.getString('uid');
      String? username = prefs.getString('username');
      String? email = prefs.getString('email');
      if (uid != null && username != null && email != null) {
        return {'uid': uid, 'username': username, 'email': email};
      }
    }
    return null;
  }
}
