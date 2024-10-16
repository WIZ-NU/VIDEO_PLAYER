// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedio_app/Screens/user_screen.dart';
import 'package:vedio_app/Vedio/vedio_tile.dart';

class VideoScreen extends StatefulWidget {
  final DatabaseReference dbRef;
  final String username;
  final String email;

  const VideoScreen({
    super.key,
    required this.dbRef,
    required this.username,
    required this.email,
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late DatabaseReference dbRef;
  int _selectedIndex = 0;

  final List<String> foodVideoAssets = [
    'assets/videos/food1.mp4',
    'assets/videos/food2.mp4',
    'assets/videos/food3.mp4',
  ];

  final List<String> sportsVideoAssets = [
    'assets/videos/sport.mp4',
    'assets/videos/sport1.mp4',
    'assets/videos/sport2.mp4',
  ];

  final List<String> kidsVideoAssets = [
    'assets/videos/kid.mp4',
    'assets/videos/kid1.mp4',
    'assets/videos/kid2.mp4',
  ];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('users');
  }

  void _updateUserData(String newUsername, String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await dbRef.child(user.uid).update({
          'username': newUsername,
          'email': newEmail,
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', newUsername);
        await prefs.setString('email', newEmail);

        setState(() {});
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Vedio Player',
              style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.greenAccent, Colors.black],
              ),
            ),
          ),
        ),
        body: _buildBody(),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }

  Widget _createBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.greenAccent, Colors.black],
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        selectedLabelStyle: GoogleFonts.ubuntu(),
        unselectedLabelStyle: GoogleFonts.ubuntu(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return ListView(
          children: <Widget>[
            VideoSection(title: 'FOOD', videoAssets: foodVideoAssets),
            VideoSection(title: 'SPORTS', videoAssets: sportsVideoAssets),
            VideoSection(title: 'KIDS', videoAssets: kidsVideoAssets),
          ],
        );
      case 1:
        return UserProfileScreen(
          username: widget.username,
          email: widget.email,
          dbRef: widget.dbRef,
          onUpdate: _updateUserData,
        );
      default:
        return Container();
    }
  }
}

class VideoSection extends StatelessWidget {
  final String title;
  final List<String> videoAssets;

  const VideoSection({
    Key? key,
    required this.title,
    required this.videoAssets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 40,
            width: 200,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$title VIDEOS',
                style: GoogleFonts.ubuntu(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 160,
            width: 600,
            margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoAssets.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.black,
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                  child: VideoTile(videoAsset: videoAssets[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
