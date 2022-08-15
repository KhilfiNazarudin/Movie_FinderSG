// To parse this JSON data, do
//
//     final stuff = stuffFromJson(jsonString);

import 'dart:convert';

Stuff stuffFromJson(String str) => Stuff.fromJson(json.decode(str));

String stuffToJson(Stuff data) => json.encode(data.toJson());

class Stuff {
    Stuff({
        this.found,
        this.totalNumPages,
        this.pageNum,
        this.results,
    });

    int found;
    int totalNumPages;
    int pageNum;
    List<Result> results;

    factory Stuff.fromJson(Map<String, dynamic> json) => Stuff(
        found: json["found"],
        totalNumPages: json["totalNumPages"],
        pageNum: json["pageNum"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "found": found,
        "totalNumPages": totalNumPages,
        "pageNum": pageNum,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        this.searchval,
        this.blkNo,
        this.roadName,
        this.building,
        this.address,
        this.postal,
        this.x,
        this.y,
        this.latitude,
        this.longitude,
        this.longtitude,
    });

    String searchval;
    String blkNo;
    String roadName;
    String building;
    String address;
    String postal;
    String x;
    String y;
    String latitude;
    String longitude;
    String longtitude;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        searchval: json["SEARCHVAL"],
        blkNo: json["BLK_NO"],
        roadName: json["ROAD_NAME"],
        building: json["BUILDING"],
        address: json["ADDRESS"],
        postal: json["POSTAL"],
        x: json["X"],
        y: json["Y"],
        latitude: json["LATITUDE"],
        longitude: json["LONGITUDE"],
        longtitude: json["LONGTITUDE"],
    );

    Map<String, dynamic> toJson() => {
        "SEARCHVAL": searchval,
        "BLK_NO": blkNo,
        "ROAD_NAME": roadName,
        "BUILDING": building,
        "ADDRESS": address,
        "POSTAL": postal,
        "X": x,
        "Y": y,
        "LATITUDE": latitude,
        "LONGITUDE": longitude,
        "LONGTITUDE": longtitude,
    };
}
