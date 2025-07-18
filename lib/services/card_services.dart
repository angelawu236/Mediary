//read from json into a cards model.

import 'package:mediary/models/card_model.dart';
import 'dart:async';

class CardsService {
  final Map<String, String> headers = {
    "accept": "application/json",
  };

  late Map<String, CardsModel> cardsModel;

  //reads the json using function from models.
  Future <bool> fetchCards() async{
    try{
      cardsModel = cardsModelFromJson('data/cards.json');
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }

}
