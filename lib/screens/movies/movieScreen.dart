import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_findersg_khilfi/models/moviesModels.dart';
import 'package:movie_findersg_khilfi/models/popularMovies.dart';
import 'package:movie_findersg_khilfi/models/searchedModels.dart';
import 'package:movie_findersg_khilfi/screens/movies/movieDetailsScreens.dart';

var baseURL = 'https://api.themoviedb.org/3/';
var apiKey = "?api_key=d531746f62591cbf027fc279fd5d3c44";
var imageURL = 'https://image.tmdb.org/t/p/original/';

class moviePage extends StatefulWidget {
  moviePage({Key key}) : super(key: key);

  @override
  State<moviePage> createState() => _moviePageState();
}

class _moviePageState extends State<moviePage> {
  TextEditingController searchController = TextEditingController();
  Popular popularList;
  Future<Popular> popularMovies;
  List<Movies> searchedList;
  Future<List<Movies>> searchedMovies;
  Widget display;
  String keyword;
  String dropdownValue = 'All Genre';
  @override
  void initState() {
    super.initState();
    popularMovies = getPopularMovies();
    popularMovies.then((value) => {
          setState(() {
            popularList = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 20),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                print(value);
                if (value.isNotEmpty) {
                  setState(() {
                    keyword = value;
                  });
                } else if (value.isEmpty) {
                  setState(() {
                    searchedList = null;
                  });
                }
                ;
              },
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                    color: Colors.grey.shade600, fontFamily: 'roboto'),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Genre:",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                width: 50,
              ),
              DropdownButton<String>(
                onChanged: (String newValue) {
                  setState(() {
                    print(keyword);
                    keyword != null ? searchFunction() : DoNothingAction();
                    dropdownValue = newValue;
                  });
                },
                items: dropDownItems(),
                value: dropdownValue,
                icon: const Icon(Icons.more_vert),
                elevation: 16,
                style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                underline: Container(
                  height: 2,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          setDisplay(popularList, searchedList, keyword)
        ],
      ),
    );
  }

  Future<Popular> getPopularMovies() async {
    var response =
        await http.get(Uri.parse(baseURL + 'movie/popular' + apiKey));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Popular.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }

  Future<List<Movies>> getSearchedMovies(
      String keyword, String dropdownValue) async {
    var response = await http
        .get(Uri.parse(baseURL + 'search/movie' + apiKey + '&query=$keyword'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var searched = Searched.fromJson(jsonDecode(response.body));
      List<Movies> listOfMovies = [];
      searched.results.forEach((element) {
        createList(listOfMovies, dropdownValue, element.id);
      });
      return listOfMovies;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }

  Widget searchedMovieContainer(List<Movies> searchedList) {
    return Expanded(
      child: ListView.builder(
          itemCount: null == searchedList ? 0 : searchedList.length,
          itemBuilder: (context, index) {
            Movies popularMovies = searchedList[index];

            return InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => movieDetail(id: popularMovies.id)),
                ),
              },
              splashColor: Colors.red,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        popularMovies.title,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            imageURL +
                                (popularMovies.posterPath == null
                                    ? "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"
                                    : popularMovies.posterPath),
                            height: 250,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              popularMovies.overview,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Expanded popuplarMovieContainer(Popular popularList) {
    return Expanded(
      child: ListView.builder(
          itemCount: null == popularList ? 0 : popularList.results.length,
          itemBuilder: (context, index) {
            Result popularMovies = popularList.results[index];
            return InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => movieDetail(id: popularMovies.id)),
                ),
              },
              splashColor: Colors.red,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        popularMovies.title,
                        style: TextStyle(
                            fontFamily: 'NexaBold',
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: popularMovies.id,
                            child: Image.network(
                              imageURL + popularMovies.posterPath,
                              height: 250,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              popularMovies.overview,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget setDisplay(
      Popular popularList, List<Movies> searchedList, String keyword) {
    if (searchedList == null || keyword == '') {
      return popuplarMovieContainer(popularList);
    } else {
      // find moveFunction
      return searchedMovieContainer(searchedList);
    }
  }

  Future<List<Movies>> createList(
      List<Movies> list, String dropdownValue, int id) async {
    //
    var response =
        await http.get(Uri.parse(baseURL + 'movie/' + id.toString() + apiKey));
    if (response.statusCode == 200) {
      Movies themovie = Movies.fromJson(jsonDecode(response.body));
      if (dropdownValue != "All Genre") {
        for (var genre in themovie.genres) {
          if (genre.name == dropdownValue) {
            list.add(themovie);
          }
        }
      } else {
        list.add(themovie);
      }
    }
    return list;
  }

  List<DropdownMenuItem<String>> dropDownItems() {
    return <String>[
      "Action",
      "Adventure",
      "Animation",
      "Comedy",
      "Crime",
      "Documentary",
      "Drama",
      "Family",
      "Fantasy",
      "History",
      "Horror",
      "Music",
      "Mystery",
      "Romance",
      "Science Fiction",
      "TV Movie",
      "Thriller",
      "War",
      "Western",
      "All Genre"
    ] // REPLACE WITH GENRE LIST
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  searchFunction() {
    searchedMovies = getSearchedMovies(keyword, dropdownValue);
    searchedMovies.then((value) => {searchedList = value});
  }
}
