import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaModel {
  MediaModel({
    required this.cardActive,
    required this.titleText,
    required this.category,
    required this.comments,
    required this.rating,
  });

  bool? cardActive;
  String? titleText;
  String? category;
  String? comments;
  int? rating;


}