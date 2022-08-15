import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutPage extends StatefulWidget {
  aboutPage({Key key}) : super(key: key);

  @override
  State<aboutPage> createState() => _aboutPageState();
}

class _aboutPageState extends State<aboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                launch("tel: 64515115");
                print("Phone icon is pressed");
              },
              icon: Icon(Icons.phone))
        ],
        title: Text(
          "About page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: defaultp,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_pin_circle, size: 50),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                    child: Text(
                  'Your ultimate application to all movies. Watch trailers and read reviews online.',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Developed by:",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'Roboto'),
                      ),
                      Text("Khilfi Nazarudin | Nanyang Polytechnic (NYP)",
                          style: TextStyle(fontFamily: 'roboto')),
                      Text("201945D@mymail.nyp.edu.sg | contactNYP@nyp.edu.sg",
                          style: TextStyle(fontFamily: 'ROBOTO')),
                    ],
                  ),
                ]),
                Divider(
                  height: 48,
                  color: defaultp,
                  thickness: 5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.01,
                ),
                Image.asset('images/thorAd.png'),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                Text(
                  "Watch trailers and read reviews with MovieFinderSG and get access to the latest movie information, movie trailers wherever you are.",
                  style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
