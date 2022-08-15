import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_findersg_khilfi/models/MoviesModels.dart';
import 'package:movie_findersg_khilfi/models/Stuff.dart';

class HttpService {

  static Future<List<Result>> getCinemaLocation() async {
    try {
      var URL1 =
          'https://developers.onemap.sg/commonapi/search?searchVal=cathay cineplex&returnGeom=Y&getAddrDetails=Y';
      var URL2 =
          'https://developers.onemap.sg/commonapi/search?searchVal=shaw theatres&returnGeom=Y&getAddrDetails=Y';
      var URL3 =
          'https://developers.onemap.sg/commonapi/search?searchVal=golden village&returnGeom=Y&getAddrDetails=Y';
      final response1 = await http.get(Uri.parse(URL1));
      final response2 = await http.get(Uri.parse(URL2));
      final response3 = await http.get(Uri.parse(URL3));
      if (response1.statusCode == 200 &&
          response2.statusCode == 200 &&
          response3.statusCode == 200) {
        final Stuff cp1 = stuffFromJson(response1.body);
        final Stuff cp2 = stuffFromJson(response2.body);
        final Stuff cp3 = stuffFromJson(response3.body);
        cp1.results.addAll(cp2.results);
        cp1.results.addAll(cp3.results);
        return cp1.results;
      } else {
        return List<Result>();
      }
    } catch (e) {
      print('Errpr ${e.toString()}');
      return List<Result>();
    }
  }
}
