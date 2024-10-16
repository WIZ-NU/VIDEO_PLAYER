// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedio_app/Screens/login_screen.dart';
import 'package:vedio_app/Vedio/vedio_viewer.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key, required String title});

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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FocusNode userfocus = FocusNode();
  final FocusNode emailfocus = FocusNode();
  final FocusNode passfocus = FocusNode();
  final FocusNode checkfocus = FocusNode();

  late DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    dbRef = FirebaseDatabase.instance.ref().child('User');
  }

  void _setText() async {
    if (_formkey.currentState!.validate()) {
      try {
        // Firebase Authentication signup
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Create user data in Realtime Database
        await dbRef.child(userCredential.user!.uid).set({
          'username': nameController.text.trim(),
          'email': emailController.text.trim(),
        });

        // Navigate to VideoScreen on successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(
              dbRef: dbRef.child(userCredential.user!.uid),
              username: nameController.text.trim(),
              email: emailController.text.trim(),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle signup errors
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Error', style: GoogleFonts.ubuntu()),
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

  bool rememberme = false;
  bool showerrormessage = false;
  final _formkey = GlobalKey<FormState>();
  var value;
  late RegExp regex;

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
              Text("SignUp",
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  )),
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
                          ),
                        ],
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Name",
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
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
                                    style: GoogleFonts.ubuntu(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    cursorColor: Colors.white,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: nameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter username";
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
                                                width: 1)),
                                        hintText: "Name",
                                        hintStyle: GoogleFonts.ubuntu(
                                            textStyle:
                                                TextStyle(color: Colors.grey)),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Email",
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
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
                                    style: GoogleFonts.ubuntu(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    cursorColor: Colors.white,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: emailController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "please enter email";
                                      }
                                      return null;
                                    },
                                    focusNode: emailfocus,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      errorStyle: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                              color: Colors.greenAccent)),
                                      hintText: "Email",
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Password",
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
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
                                    style: GoogleFonts.ubuntu(
                                        textStyle:
                                            TextStyle(color: Colors.white)),
                                    cursorColor: Colors.white,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    validator: (PassCurrentValue) {
                                      RegExp regex = RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                      var passNonNullValue =
                                          PassCurrentValue ?? "";
                                      if (passNonNullValue.isEmpty) {
                                        return ("Password is required");
                                      } else if (passNonNullValue.length < 6) {
                                        return ("Password Must be more than 5 characters");
                                      } else if (!regex
                                          .hasMatch(passNonNullValue)) {
                                        return ("Password should contain upper,lower,digit and Special character ");
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
                          SizedBox(height: 30),
                          MaterialButton(
                            onPressed: _setText,
                            minWidth: 250,
                            splashColor: Colors.white60,
                            color: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Text('SignUp',
                                style: GoogleFonts.ubuntu(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 25),
                              Text("Already have an account? ",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                    color: Colors.grey,
                                  ))),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                              title: '',
                                            )),
                                  );
                                },
                                child: Text('Login',
                                    style: GoogleFonts.ubuntu(
                                        textStyle: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 15,
                                    ))),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
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
}
