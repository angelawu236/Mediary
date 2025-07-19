//read from json into a cards model (fetchCards())
//store data to firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediary/models/card_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


var db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
final uid = _auth.currentUser?.uid;


class CardsService {
  final Map<String, String> headers = {
    "accept": "application/json",
  };

  late Map<String, CardsModel> cardsModel;

  //reads the json using function from models, used with storeCards.
  Future <bool> fetchCards() async{
    try{
      cardsModel = cardsModelFromJson('data/cards.json');
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }

  //reads from firestore
  Future<Map<String, CardsModel>> fetchCardsFromFirestore(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .get();

    return {
      for (var doc in snapshot.docs)
        doc.id: CardsModel.fromJson(doc.data())
    };
  }

  //store cards in firestore
  void storeCards(String cardId, CardsModel card) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(cardId)
        .set(card.toJson());
  }



}
