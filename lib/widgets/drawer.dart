import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/controller/Provider.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final Function onTap;
  MyDrawer({this.onTap});

  @override
  Widget build(BuildContext context) {
    // Inject provider instance
    var provider = Provider.of<appProvider>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    defaultp,
                    defaulta,
                  ])),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(provider.dpUrl),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      provider.user.displayName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      provider.user.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.movie_creation,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Movies',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: () => onTap(context, 0, 'Movies'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Your reviews',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: () => onTap(context, 1, 'Your Reviews'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Locate Cinemas',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: () => onTap(context, 2, 'Locate Cinemas'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.02,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
                size: 30,
              ),
              title: Text(
                'Profile',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: () => onTap(context, 3, 'Profile'),
            ),
          
          ],
        ),
      ),
    );
  }
}
