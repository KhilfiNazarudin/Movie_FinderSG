import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/screens/login_reg/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// " CONTROLLER "
class appProvider extends ChangeNotifier {
  User user;
  String dpUrl;
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  void setUser(User user, String url) {
    this.user = user;
    this.dpUrl = url;
    notifyListeners();
  }

  Future<void> logout(context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.clear();

    await _fbAuth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => homeScreen(),
      ),
    );
    
    notifyListeners();
  }

  
}
