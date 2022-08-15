import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:movie_findersg_khilfi/screens/locateCinema/locateCinemaScreen.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieScreen.dart';
import 'package:movie_findersg_khilfi/screens/profile/profileScreen.dart';
import 'package:movie_findersg_khilfi/screens/reviewPage/yourReviewScreen.dart';
import 'package:movie_findersg_khilfi/widgets/drawer.dart';

class mainScreen extends StatefulWidget {
  mainScreen({Key key}) : super(key: key);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int index = 0;
  String title = 'Movies';
  List<Widget> list = [
    moviePage(),
    yourReviews(),
    locateCinemas(),
    profilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'NexaBold',
      ),
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: defaultp,
            title: Text(
              title,
              style: TextStyle(
                  fontFamily: 'NexaBold', fontWeight: FontWeight.bold),
            ),
          ),
        drawer: MyDrawer(onTap: (context, i, txt) {
              setState(() {
                index = i;
                title = txt;
                print(index);
                Navigator.pop(context);
              });
            }),
        
        body: list[index],
        ),
    );
     
  }
}
