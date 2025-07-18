//read from json into a cards model (fetchCards())
//store data to firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediary/models/card_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


var db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

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

  void storeCards() async {
       await db.collection(_auth.currentUser as String).add(cardsModel);
  }



}
