
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/controller/Provider.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieDetailsScreens.dart';
import 'package:provider/provider.dart';

class yourReviews extends StatefulWidget {
  yourReviews({Key key}) : super(key: key);

  @override
  State<yourReviews> createState() => _yourReviewsState();
}

class _yourReviewsState extends State<yourReviews> {
  final _firestore = Firestore.instance;

  // Use this to refresh
  // void reviewStream() async {
  //   await for (var snapshot in _firestore.collection('reviews').snapshots()) {
  //     for (var review in snapshot.docs) {
  //       print(review.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget yourReviewsCard(String author, String title, String body,
        String documentId, int movieId) {
      // Get authors profile picture
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => movieDetail(
                      id: movieId,
                    )));
            print(movieId);
          },
          splashColor: defaultp,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'By $author',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontFamily: 'roboto',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'roboto',
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            body,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                              fontFamily: 'roboto',
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        print("delete this comment $documentId");
                        _firestore
                            .collection('reviews')
                            .doc(documentId)
                            .delete();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: defaultp,
                        size: 30,
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Controller
    var provider = Provider.of<appProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('reviews').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final reviews = snapshot.data.docs;
                    List<Widget> reviewWidget = [];
                    for (var review in reviews) {
                      if (review.get('uid') == provider.user.uid) {
                        final documentId = review.id;
                        final reviewAuthor = review.get('author');
                        final reviewTitle = review.get('title');
                        final reviewBody = review.get('body');
                        final movieId = review.get('mid');
                        // final dpURL = review.get('dpURL');
                        // Widget widget = Text(reviewAuthor + reviewTitle + reviewBody);

                        //reviewWidget.add(widget);
                        final widget = yourReviewsCard(reviewAuthor,
                            reviewTitle, reviewBody, documentId, movieId);
                        // if (review.get('mid') == theMovie.id) {
                        //   reviewWidget.add(widget);
                        // }
                        reviewWidget.add(widget);
                      }
                    }
                    // return Text(
                    //   "STREAM BUILDER COMPLETED",
                    //   style: TextStyle(fontSize: 70),
                    // );
                    return Column(
                      children: reviewWidget,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
