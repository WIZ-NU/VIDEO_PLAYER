// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedio_app/Screens/signup_screen.dart';
// ignore: unused_import
import 'package:vedio_app/Screens/user_screen.dart';
import 'package:vedio_app/Vedio/vedio_viewer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FocusNode userfocus = FocusNode();
  final FocusNode passfocus = FocusNode();
  final FocusNode checkfocus = FocusNode();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('users');

  void _validateAndLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        // Firebase Authentication login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get user data from Realtime Database
        DatabaseEvent databaseEvent =
            await _dbRef.child(userCredential.user!.uid).once();
        DataSnapshot snapshot = databaseEvent.snapshot;

        String username =
            snapshot.value != null && snapshot.child('username').value != null
                ? snapshot.child('username').value as String
                : 'New User';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('uid', userCredential.user!.uid);
        await prefs.setString('username', username);
        await prefs.setString('email', emailController.text.trim());

        // Navigate to VideoScreen on successful login and valid user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(
              dbRef: _dbRef.child(userCredential.user!.uid),
              username: username,
              email: emailController.text.trim(),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle login errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Login Error',
                style: GoogleFonts.ubuntu(),
              ),
              content: Text(e.message ?? 'An error occurred',
                  style: GoogleFonts.ubuntu()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: GoogleFonts.ubuntu()),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _resetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController resetEmailController = TextEditingController();
        return AlertDialog(
          title: Text('Reset Password', style: GoogleFonts.ubuntu()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your email address to receive a password reset link.',
                  style: GoogleFonts.ubuntu()),
              TextField(
                controller: resetEmailController,
                decoration: InputDecoration(
                    labelText: 'Email', hintStyle: GoogleFonts.ubuntu()),
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
                  await _auth.sendPasswordResetEmail(
                    email: resetEmailController.text.trim(),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password reset link sent!',
                          style: GoogleFonts.ubuntu()),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? 'An error occurred',
                          style: GoogleFonts.ubuntu()),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Send', style: GoogleFonts.ubuntu()),
            ),
          ],
        );
      },
    );
  }

  bool rememberme = false;
  bool showerrormessage = false;
  final _formkey = GlobalKey<FormState>();
  var value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Column(children: <Widget>[
          Expanded(
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.greenAccent,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
              );
            }),
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.black,
              );
            }),
          ),
        ]),
        Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w900)),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 330,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ), //BoxShadow
                        ],
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(2, 0.3, 2, 0.3),
                            decoration: BoxDecoration(
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.ubuntu(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: emailController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter email";
                                      }
                                      return null;
                                    },
                                    focusNode: userfocus,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        errorStyle: GoogleFonts.ubuntu(
                                            textStyle: TextStyle(
                                                color: Colors.greenAccent)),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                              width: 1),
                                        ),
                                        hintText: "Email",
                                        hintStyle: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(color: Colors.grey)),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Password",
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(2, 0.3, 2, 0.3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    style: GoogleFonts.ubuntu(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    cursorColor: Colors.white,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter password";
                                      }
                                      return null;
                                    },
                                    focusNode: passfocus,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      errorStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                              color: Colors.greenAccent)),
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.ubuntu(
                                          textStyle:
                                              TextStyle(color: Colors.grey)),
                                      border: InputBorder.none,
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: Colors.greenAccent,
                                              width: 1)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: _resetPassword,
                                child: Text(
                                  "Forget Password?",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          MaterialButton(
                            onPressed: _validateAndLogin,
                            minWidth: 250,
                            splashColor: Colors.white60,
                            color: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Text(
                              'Login',
                              style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 30),
                              Text(
                                "Don't have an account?",
                                style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen(
                                              title: '',
                                            )),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 15,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
