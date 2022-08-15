// To parse this JSON data, do
//
//     final searched = searchedFromJson(jsonString);

import 'dart:convert';

Searched searchedFromJson(String str) => Searched.fromJson(json.decode(str));

String searchedToJson(Searched data) => json.encode(data.toJson());

class Searched {
    Searched({
        this.page,
        this.results,
        this.totalPages,
        this.totalResults,
    });

    int page;
    List<SearchedResults> results;
    int totalPages;
    int totalResults;

    factory Searched.fromJson(Map<String, dynamic> json) => Searched(
        page: json["page"],
        results: List<SearchedResults>.from(json["results"].map((x) => SearchedResults.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class SearchedResults {
    SearchedResults({
        this.id,
        this.logoPath,
        this.name,
    });

    int id;
    String logoPath;
    String name;

    factory SearchedResults.fromJson(Map<String, dynamic> json) => SearchedResults(
        id: json["id"],
        logoPath: json["logo_path"] == null ? null : json["logo_path"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo_path": logoPath == null ? null : logoPath,
        "name": name,
    };
}
