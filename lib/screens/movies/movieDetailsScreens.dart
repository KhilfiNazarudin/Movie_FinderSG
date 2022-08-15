import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_findersg_khilfi/models/moviesModels.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_findersg_khilfi/models/videoModels.dart';
import 'package:movie_findersg_khilfi/controller/Provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';

var baseURL = 'https://api.themoviedb.org/3/';
var apiKey = "?api_key=d531746f62591cbf027fc279fd5d3c44";
var imageURL = 'https://image.tmdb.org/t/p/original/';

class movieDetail extends StatefulWidget {
  final int id;
  movieDetail({Key key, int this.id}) : super(key: key);

  @override
  State<movieDetail> createState() => _movieDetailState();
}

class _movieDetailState extends State<movieDetail> {
  final _firestore = Firestore.instance;
  Future<Movies> futureMovie;
  Future<Video> futureVideo;
  Movies theMovie;
  Video videoDetails;
  YoutubePlayerController videoController;
  TextEditingController reviewController;
  TextEditingController titleController;
  String title;
  String review;
  double rating;

  Future<void> submitReview(
      BuildContext context, Movies theMovie, User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Submit review'),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    controller: titleController,
                    decoration:
                        InputDecoration(hintText: "Title of your review"),
                  ),
                  TextField(
                    onChanged: (value) {
                      review = value;
                    },
                    controller: reviewController,
                    decoration: InputDecoration(hintText: "Your review"),
                  ),
                  RatingBar.builder(
                    initialRating: 2.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      rating = value;
                    },
                  )
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
                  reviewController != null
                      ? reviewController.clear()
                      : DoNothingAction();

                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Submit you review'),
              onPressed: () {
                setState(() {
                  Reference ref = FirebaseStorage.instance
                      .ref()
                      .child("/user/profile/" + user.uid);
                  ref.getDownloadURL().then((value) {
                    _firestore.collection('reviews').add({
                      'author': user.displayName,
                      'body': review,
                      'mid': theMovie.id,
                      'title': title,
                      'uid': user.uid,
                      'rating' : rating
                    });
                  });
                  // Upload the review BEFORE setstate to clear
                  reviewController != null
                      ? reviewController.clear()
                      : DoNothingAction();

                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

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
    futureVideo = getVideoDetails(widget.id);
    futureMovie = getMovie(widget.id);
    print(widget.id);
    futureMovie.then((value) => {
          setState(() {
            theMovie = value;
          })
        });
    futureVideo.then((value) => {
          setState(() {
            videoDetails = value;
            print(videoDetails.results[0].key);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // provider as a controller
    var provider = Provider.of<appProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: defaultp,
          actions: [
            IconButton(
                onPressed: () => {
                      setState(() {
                        submitReview(context, theMovie, provider.user);
                      })
                    },
                icon: Icon(Icons.edit))
          ],
          title: Text("DetailPage"),
        ),
        body: FutureBuilder(
          future: futureMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          theMovie.title,
                          style: TextStyle(
                              fontFamily: 'NexaBold',
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: widget.id,
                              child: Image.network(
                                imageURL + theMovie.posterPath,
                                height: MediaQuery.of(context).size.width * 0.6,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Expanded(
                                child: Text(theMovie.overview,
                                    style: TextStyle(
                                        fontFamily: 'Roboto', fontSize: 16))),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),

                        FutureBuilder(
                            future: futureVideo,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String url =
                                    "https://www.youtube.com/watch?v=${videoDetails.results[0].key}";

                                var videoController = YoutubePlayerController(
                                  initialVideoId:
                                      YoutubePlayer.convertUrlToId(url),
                                );

                                return YoutubePlayerBuilder(
                                    player: YoutubePlayer(
                                      controller: videoController,
                                    ),
                                    builder: (context, player) => Container(
                                          child: player,
                                        ));
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              // By default, show a loading spinner.
                              return Center(
                                  child: const CircularProgressIndicator());
                            }),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        //Image.network(imageURL + theMovie.backdropPath),
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
                              final reviewAuthor = review.get('author');
                              final reviewTitle = review.get('title');
                              final reviewBody = review.get('body');
                              final reviewRating = review.get('rating');
                              final Future<String> dpURL = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child("/user/profile/" + review.get('uid'))
                                  .getDownloadURL();
                              final widget = reviewCards(
                                  reviewAuthor, reviewTitle, reviewBody,reviewRating ,dpURL);
                              if (review.get('mid') == theMovie.id) {
                                reviewWidget.add(widget);
                              }
                            }
                            return Column(
                              children: reviewWidget,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return Center(child: const CircularProgressIndicator());
          },
        ));
  }
}

Future<Movies> getMovie(int id) async {
  var response = await http.get(Uri.parse(baseURL + 'movie/$id' + apiKey));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Movies.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Video> getVideoDetails(int id) async {
  var response =
      await http.get(Uri.parse(baseURL + 'movie/$id' + '/videos' + apiKey));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Video.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Widget reviewCards(
    String author, String title, String body,double rating ,Future<String> url) {
  return FutureBuilder(
    future: url,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                    width: 200,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'By $author',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 10),
                          Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          Text(
                            body,
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          )
                        ]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(rating.toString()),
                      Icon(Icons.star,color: Colors.amber,),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
      return const CircularProgressIndicator();
    },
  );
}
