import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
//model for both storing to firebase (watchlist) and also loading from API.

Map<String, MediaModel> cardsModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k,v) => MapEntry<String, MediaModel>(k, MediaModel.fromJson(v)));

String mediaModelToJson(Map<String, MediaModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class MediaModel {
  MediaModel({

    required this.id,
    required this.date,
    required this.titleText,
    required this.comments, //user input
    required this.rating, //user input
    required this.isSelected,
    required this.dateWatched,
    required this.index,
    required this.category,
    required this.posterPath,
  });

  int? id;
  String? date;
  String? titleText;
  String? comments;
  int? rating;
  bool? isSelected;
  String? dateWatched;
  int? index;
  String? category;
  String? posterPath;

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      titleText: json['titleText'] ?? json['original_title'] ?? 'title not found',
      date: json['release_date'] ?? json['date'] ?? 'date not found',
      id: json['id'] ?? 'no ID',
      comments: json['comments'] ?? "",
      rating: json['rating'] ?? 0,
      isSelected: false,
      dateWatched: "",
      category: json['category'] ?? '',
      index: json['index'] ?? 0,
      posterPath: json['posterPath'] ??  // from Firestore
          (json['poster_path'] != null     // from TMDB API
              ? 'https://image.tmdb.org/t/p/original${json['poster_path']}'
              : null),
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "release_date": date,
    "titleText": titleText,
    "comments": comments,
    "rating": rating,
    "dateWatched": dateWatched,
    "index": index,
    "category": category,
    "posterPath": posterPath,
  };

}