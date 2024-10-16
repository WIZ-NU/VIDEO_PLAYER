// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final DatabaseReference dbRef;
  final void Function(String newUsername, String newEmail) onUpdate;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.email,
    required this.dbRef,
    required this.onUpdate,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
  }

  void _updateProfile() async {
    String newUsername = _usernameController.text;
    String newEmail = _emailController.text;

    try {
      // Update user data in Realtime Database
      await widget.dbRef.update({
        'username': newUsername,
        'email': newEmail,
      });

      // Call onUpdate callback to update state in VideoScreen
      widget.onUpdate(newUsername, newEmail);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Profile updated successfully', style: GoogleFonts.ubuntu()),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.',
              style: GoogleFonts.ubuntu()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newPasswordController = TextEditingController();
        return AlertDialog(
          title: Text('Change Password', style: GoogleFonts.ubuntu()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your new password.', style: GoogleFonts.ubuntu()),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: GoogleFonts.ubuntu()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: GoogleFonts.ubuntu()),
            ),
            TextButton(
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.updatePassword(newPasswordController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password changed successfully!',
                            style: GoogleFonts.ubuntu()),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? 'An error occurred',
                          style: GoogleFonts.ubuntu()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Change', style: GoogleFonts.ubuntu()),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('uid');
    await prefs.remove('username');
    await prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(title: 'Login'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: Image.asset(
                "assets/images/user.png",
                height: 240,
                width: 180,
              )),
              // SizedBox(
              //   height: 100,
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          //height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(40)),
                          child: Column(
                            children: [
                              TextFormField(
                                style: GoogleFonts.ubuntu(color: Colors.white),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  icon: const Icon(
                                    Icons.account_circle_outlined,
                                    size: 27,
                                  ),
                                  iconColor: Colors.white,
                                  suffixIcon: const Icon(Icons.edit),
                                  suffixIconColor: Colors.white,
                                  border: InputBorder.none,
                                  labelText: 'Username',
                                  labelStyle: GoogleFonts.ubuntu(
                                      textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                                ),
                                cursorColor: Colors.white,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Container(
                                  height: 1,
                                  width: 265,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: GoogleFonts.ubuntu(
                                  color: Colors.white,
                                ),
                                controller: _emailController,
                                decoration: InputDecoration(
                                    icon: const Icon(
                                      Icons.email_outlined,
                                      size: 25,
                                    ),
                                    iconColor: Colors.white,
                                    border: InputBorder.none,
                                    labelText: 'Email',
                                    labelStyle: GoogleFonts.ubuntu(
                                        textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                                    fillColor: Colors.black),
                                enabled: false, // Disable email editing
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            width: 300.0,
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black, // Change button color
                              ),
                              child: Text('Update Profile',
                                  style: GoogleFonts.ubuntu(
                                      textStyle: const TextStyle(
                                          color: Colors.white))),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            width: 300.0,
                            child: ElevatedButton(
                              onPressed: _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black, // Change button color
                              ),
                              child: Text(
                                'Change Password',
                                style: GoogleFonts.ubuntu(
                                    textStyle:
                                        const TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            width: 300.0,
                            child: TextButton(
                                onPressed: _logout,
                                child: Text(
                                  'Sign Out',
                                  style: GoogleFonts.ubuntu(
                                      textStyle:
                                          const TextStyle(color: Colors.white)),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
