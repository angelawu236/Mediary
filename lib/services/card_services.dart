//read from json into a cards model (fetchCards())
//store data to firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediary/models/card_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;


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
      String jsonString = await rootBundle.loadString('data/cards.json');
      cardsModel = cardsModelFromJson(jsonString);
      return true;
    } catch (e){
      print(e);
      return false;
    }
  }

  //reads from firestore
  Future<bool> fetchCardsFromFirestore(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .get();
    try{
      cardsModel = {for (var doc in snapshot.docs)
        doc.id: CardsModel.fromJson(doc.data())
      };
      return true;
    } catch(e){
      print('error fetching cards from firestore in card_services');
      return false;
    }

  }

  //store cards in firestore
  Future<bool> storeCards(Map<String, CardsModel> cardMap) async {
    try{

      await db.collection('users').doc(uid).set({}, SetOptions(merge: true));


      for(final entry in cardMap.entries){
        final cardId = entry.key;
        final card = entry.value;

        await db
            .collection('users')
            .doc(uid)
            .collection('cards')
            .doc(cardId)
            .set(card.toJson());
        print('Writing card $cardId: ${card.toJson()}');
      }
      return true;
    } catch(e) {
      print ('error storing cards ');
      return false;
    }
  }



}
