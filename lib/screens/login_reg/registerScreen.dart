import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:movie_findersg_khilfi/services/firebaseauth_service.dart';
import 'package:url_launcher/url_launcher.dart';

class registerScreen extends StatefulWidget {
  registerScreen({Key key}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  String pwdinput = "";
  String idinput = "";
  String message = "Or sign in with other accounts";
  List<String> credentials = ["JohnDoe", "abc123"];

  void pickUploadImage(uid) async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    Reference ref =
        FirebaseStorage.instance.ref().child("/user/profile/" + uid);

    await ref.putFile(File(image.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [defaultp, defaulta],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 30),
                  child: Container(
                    child: Text(
                      "Register as a new user",
                      style: TextStyle(
                          fontSize: 80,
                          color: Colors.amber,
                          fontFamily: 'NexaBold',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 10),
                  child: TextField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      hintText: 'Display Name',
                      hintStyle: TextStyle(
                          fontFamily: 'NexaBold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 10),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          fontFamily: 'NexaBold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 10),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontFamily: 'NexaBold',
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: GestureDetector(
                        onTap: () async {
                          var newuser = await FirebaseAuthService()
                              .signUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  displayName:
                                      displayNameController.text.trim())
                              .then((value) => pickUploadImage(value.uid));
                          emailController.clear();
                          passwordController.clear();
                          displayNameController.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return loginScreen();
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              )),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'NexaBold',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        message,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NexaBold',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            
                            {launch(
                                  "https://accounts.google.com/signin/v2/identifier?service=accountsettings&continue=https%3A%2F%2Fmyaccount.google.com%3Futm_source%3Daccount-marketing-page%26utm_medium%3Dgo-to-account-button&flowName=GlifWebSignIn&flowEntry=ServiceLogin"),
                              print("Google button is pressed")}
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                "Google",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            {launch("https://www.facebook.com/"),
                              print("Facebook button is pressed")}
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.blue.shade800,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                "Facebook",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
