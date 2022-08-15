import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieDetailsScreens.dart';
import 'package:movie_findersg_khilfi/controller/Provider.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieScreen.dart';
import 'package:movie_findersg_khilfi/screens/profile/aboutScreen.dart';
import 'package:movie_findersg_khilfi/services/firestore_service.dart';
import 'package:provider/provider.dart';

class profilePage extends StatefulWidget {
  profilePage({Key key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final nameEditor = TextEditingController();
  final fbtController = TextEditingController();
  final fbbController = TextEditingController();
  final _firestore = Firestore.instance;
  String updatedUrl = '';
  String fbBody = '';
  String fbTitle = '';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<appProvider>(context);
    updatedUrl != '' ? provider.dpUrl = updatedUrl : '';
    var imageurl = provider.user.photoURL;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickUploadImage(provider.user.uid);
                    },
                    child: updatedUrl == ''
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(provider.dpUrl),
                            backgroundColor: Colors.black,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(updatedUrl),
                            backgroundColor: Colors.black,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.user.displayName,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold),
                      ),
                      // IconButton(
                      //     onPressed: () => {
                      //           setState(() {
                      //             editName(context);
                      //           })
                      //         },
                      //     icon: Icon(Icons.edit))
                    ],
                  ),
                  Text(
                    provider.user.email,
                    style: TextStyle(fontSize: 17, fontFamily: 'Roboto'),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [defaultp, defaulta])),
            ),
            profileList(provider, context)
          ],
        ),
      ),
    );
  }

  Future<void> editName(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change name'),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameEditor,
                    decoration: InputDecoration(hintText: "New name"),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  nameEditor.clear();
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Change name'),
              onPressed: () {
                setState(() {
                  // nameEditor.clear();
                  // Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> leaveFeedback(BuildContext context, User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'How was your experience?',
            style: TextStyle(fontFamily: 'roboto', fontWeight: FontWeight.w400),
          ),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(fontFamily: 'roboto'),
                    onChanged: (value) {
                      fbTitle = value;
                    },
                    controller: fbtController,
                    decoration: InputDecoration(hintText: "Feedback Title"),
                  ),
                  TextField(
                    style: TextStyle(fontFamily: 'roboto'),
                    onChanged: (value) {
                      fbBody = value;
                    },
                    controller: fbbController,
                    decoration: InputDecoration(hintText: "Feedback Body"),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'roboto'),
              ),
              onPressed: () {
                setState(() {
                  fbtController.clear();
                  fbbController.clear();
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text(
                'Submit feedback',
                style: TextStyle(fontFamily: 'roboto'),
              ),
              onPressed: () {
                setState(() {
                  fbtController.clear();
                  fbbController.clear();
                  fbBody != '' && fbTitle != ''
                      ? submitFeedback(fbTitle, fbBody, user)
                      : DoNothingAction();
                  fbTitle = '';
                  fbBody = '';

                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void pickUploadImage(uid) async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    Reference ref =
        FirebaseStorage.instance.ref().child("/user/profile/" + uid);

    await ref.putFile(File(image.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        updatedUrl = value;
      });
    });
  }

  void submitFeedback(String fbt, String fbb, user) async {
    _firestore.collection('feedback').add({
      'body': fbb,
      'title': fbt,
      'uid': user.uid,
    });
  }

  Container profileList(appProvider provider, BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 20.0,
              child: InkWell(
                onTap: () {
                  leaveFeedback(context, provider.user);
                },
                splashColor: defaultp,
                highlightColor: defaulta,
                child: Container(
                  height: 75,
                  child: Text(
                    "Send Feedback",
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xFF000000),
                        fontFamily: 'Roboto'),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 20.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => aboutPage(),
                    ),
                  );
                },
                splashColor: defaultp,
                highlightColor: defaulta,
                child: Container(
                  height: 75,
                  child: Text(
                    "About Page",
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xFF000000),
                        fontFamily: 'Roboto'),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 20.0,
              child: InkWell(
                onTap: () {
                  provider.logout(context);
                },
                splashColor: defaultp,
                highlightColor: defaulta,
                child: Container(
                  height: 75,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xFF000000),
                        fontFamily: 'Roboto'),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                ),
              ),
            )
          ]),
      alignment: Alignment.center,
      width: 300.0,
      height: 300,
    );
  }
}
