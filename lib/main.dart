import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/models/searchedModels.dart';
import 'package:movie_findersg_khilfi/screens/home/mainScreen.dart';
import 'package:movie_findersg_khilfi/screens/login_reg/homeScreen.dart';
import 'package:movie_findersg_khilfi/controller/Provider.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieScreen.dart';
import 'package:movie_findersg_khilfi/services/firebaseauth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var baseURL = 'https://api.themoviedb.org/3/';
var apiKey = "?api_key=d531746f62591cbf027fc279fd5d3c44";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => appProvider(),
    child: MyApp(),
  ));
}

Color defaultp = Colors.red.shade400;
Color defaulta = Colors.orange.shade300;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'NexaBold',
            primaryColor: defaultp,
            accentColor: defaulta),
        title: 'Material App',
        home: Scaffold(
          body: homeScreen(),
        ));
  }
}

class loginScreen extends StatefulWidget {
  loginScreen({Key key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  Searched searchList;
  bool signUp = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String pwdinput = "";
  String idinput = "";
  String message = "Enter your login credentials";

  save(User reguser, String password) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('uid', reguser.uid);
    await sp.setString('email', reguser.email);
    await sp.setString('password', password);
  }

  Future<List> retrieve() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List returned = [];
    var uid = sp.getString('uid');
    var email = sp.getString('email');
    var password = sp.getString('password');
    
    if (uid != null) {
      // Automatic sign in
      Reference ref =
          FirebaseStorage.instance.ref().child("/user/profile/" + uid);
      var url = await ref.getDownloadURL();
      var user = await FirebaseAuthService().signIn(
        email: email,
        password: password,
      );
      returned.add(user);
      returned.add(url);

      return returned;
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    // Inject provider instance
    var provider = Provider.of<appProvider>(context);    
    return FutureBuilder(
      future: retrieve(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          provider.setUser(snapshot.data[0], snapshot.data[1]);
          return mainScreen();
        } else {
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            child: Text(
                              "Login to your account",
                              style: TextStyle(
                                  fontSize: 80,
                                  color: Colors.amber,
                                  fontFamily: 'NexaBold',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50, right: 50, bottom: 10),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Username',
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
                          padding: const EdgeInsets.only(
                              left: 50, right: 50, bottom: 10),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                        ),
                        Text(
                          message,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NexaBold',
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(30),
                            child: GestureDetector(
                                onTap: () async {
                                  var password = passwordController.text.trim();
                                  var reguser =
                                      await FirebaseAuthService().signIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
          
                                  if (reguser != null) {
                                    Reference ref = FirebaseStorage.instance
                                        .ref()
                                        .child("/user/profile/" + reguser.uid);
                                    var url = await ref.getDownloadURL();
                                    print(url);
                                    provider.setUser(reguser, url);
                                    save(reguser,
                                        password); // to shared preference
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => mainScreen()));
                                  }
                                  setState(() {
                                    idinput = emailController.text;
                                    pwdinput = passwordController.text;
                                    emailController.clear();
                                    passwordController.clear();
                                  });
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
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontFamily: 'NexaBold',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ))))
                      ],
                    ),
                  ),
                ),
              
            ),
          );
        }
      },
    );
  
  
  }
}
