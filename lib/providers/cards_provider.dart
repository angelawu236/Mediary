import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediary/models/card_model.dart';
import 'package:mediary/services/card_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediary/app_constants.dart';

class CardsProvider extends ChangeNotifier {
  //box for hive
  // late Box cardOrderBox;
  // late Box cardStateBox;

  //providers
  Map<String, CardsModel> cards = {};

  //services
  final cardService = CardsService();

  List<String> cardOrder = [];

  Future <void> getCardsJson () async{
    bool success = await cardService.fetchCards();
    if(success){
      cards = cardService.cardsModel;
      notifyListeners();
    } else {
      print('error using fetchCards() in getCardsJson()');
    }
  }

  Future <void> getCardsFirestore(String uid) async {
    bool success = await cardService.fetchCardsFromFirestore(uid);
    if(success){
      cards = cardService.cardsModel;
      notifyListeners();
    } else {
      print('error using fetchCardsFromFirestore() in getCardsFirestore()');
    }
  }

  void storeCardsFirestore() async {
    bool success = await cardService.storeCards(cards);
    if(!success){
      print('error storeCards() from storeCardsFirestore()');
    }
  }

  Future<bool> doesUserExist(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      return doc.exists; // true if user doc exists
    } catch (e) {
      print('error finding if user exists');
      return false;
    }
  }


  void addCard(String uid, CardsModel card) async {
    cards[card.titleText!] = card;

    bool success = await cardService.storeCards(cards);
    if (!success) {
      print('Error adding card to Firestore');
    }

    notifyListeners();
  }


  void removeCard(String uid, CardsModel card) async {
    cards.remove(card.titleText);

    bool success = await cardService.storeCards(cards);
    if (!success) {
      print('Error removing card from Firestore');
    }
    notifyListeners();
  }



  //if user does this in card settings
  void toggleCard(String card) async {
    cards[card]?.cardActive = !(cards[card]?.cardActive ?? true);

    cardService.storeCards(cardService.cardsModel);
    notifyListeners();

  }

// //update hive storage for card order
// Future updateCardOrder() async {
//   cardOrderBox = await Hive.openBox(DataPersistence.cardOrder);
//
//   cardOrderBox.put(DataPersistence.cardOrder, cardOrder);
//
//   notifyListeners();
// }
//
// //load card order
// Future loadCardOrder() async {
//   cardOrderBox = await Hive.openBox(DataPersistence.cardOrder);
//
//   if (cardOrderBox.get(DataPersistence.cardOrder) == null) {
//     await cardOrderBox.put(DataPersistence.cardOrder, cardOrder);
//   } else {
//     cardOrder = cardOrderBox.get(DataPersistence.cardOrder);
//   }
//
//   notifyListeners();
// }

  // //load card states
  // Future loadCardState() async {
  //   cardStateBox = await Hive.openBox(DataPersistence.cardStates);
  //
  //   if (cardStateBox.get(DataPersistence.cardStates) == null) {
  //     await cardStateBox.put(DataPersistence.cardStates,
  //         cardStates.keys.where((card) => cardStates[card]!).toList());
  //   } else {
  //     deactivateAllCards();
  //   }
  //   notifyListeners();
  // }

  // Future updateCardState() async {
  //   var activeCards =
  //       cardStates.keys.where((card) => cardStates[card]!).toList();
  //   // cardStateBox = await Hive.openBox(DataPersistence.cardStates);
  //   // cardStateBox.put(DataPersistence.cardStates, activeCards);
  //   notifyListeners();
  // }
  //
  // void deactivateAllCards() {
  //   for (String card in cardStates.keys) {
  //     cardStates[card] = false;
  //   }
  // }
}
