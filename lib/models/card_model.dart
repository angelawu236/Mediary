//this file a card model and includes functions such as model->Json and Json->model

import 'dart:convert';

//#1 converts from JSON to Map<String, CardsModel>
Map<String, CardsModel> cardsModelFromJson(String str) =>
    Map.from(json.decode(str))
    .map((k,v) => MapEntry<String, CardsModel>(k, CardsModel.fromJson(v)));

//#2 converts from Map<String, CardsModel> to a JSON.
String cardsModelToJson(Map<String, CardsModel> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class CardsModel {
  CardsModel({
    required this.cardActive,
    required this.titleText
});
  bool? cardActive;
  String? titleText;

  //used in #1
  factory CardsModel.fromJson(Map<String, dynamic> json) => CardsModel(
    cardActive: json["cardActive"]!,
    titleText: json["titleText"]!,
  );

  //used in #2
  Map<String, dynamic> toJson() => {
    "cardActive": cardActive,
    "titleText": titleText,
  };



}