import 'package:mediary/models/card_model.dart';
import 'package:mediary/services/card_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediary/app_constants.dart';

class CardsProvider extends ChangeNotifier {

  //box for hive
  late Box cardOrderBox;
  late Box cardStateBox;
  Map<String, bool> cardStates = {};

  //providers
  Map<String, CardsModel> cards = {};

  //services
  final cardService = CardsService();

  List<String> cardOrder = [];

  void updateCards() async {
    if (await cardService.fetchCards()) {
      cards.forEach((card, model) {
        if (model.cardActive!) {
          cardOrder.add(card);
          cardStates.putIfAbsent(card, () => true);
        }
      });
    }
  }

  //update hive storage for card order
  Future updateCardOrder() async {
    cardOrderBox = await Hive.openBox(DataPersistence.cardOrder);

    cardOrderBox.put(DataPersistence.cardOrder, cardOrder);

    notifyListeners();
  }

  //load card order
  Future loadCardOrder() async {
    cardOrderBox = await Hive.openBox(DataPersistence.cardOrder);

    if (cardOrderBox.get(DataPersistence.cardOrder) == null) {
      await cardOrderBox.put(DataPersistence.cardOrder, cardOrder);
    } else {
      cardOrder = cardOrderBox.get(DataPersistence.cardOrder);
    }

    notifyListeners();
  }

  //load card states
  Future loadCardState() async {
    cardStateBox = await Hive.openBox(DataPersistence.cardStates);

    if (cardStateBox.get(DataPersistence.cardStates) == null) {
      await cardStateBox.put(DataPersistence.cardStates,
          cardStates.keys.where((card) => cardStates[card]!).toList());
    } else {
      deactivateAllCards();
    }
    notifyListeners();
  }

  Future updateCardState() async {
    var activeCards =
        cardStates.keys.where((card) => cardStates[card]!).toList();

    cardStateBox = await Hive.openBox(DataPersistence.cardStates);

    cardStateBox.put(DataPersistence.cardStates, activeCards);

    notifyListeners();
  }

  void deactivateAllCards() {
    for (String card in cardStates.keys) {
      cardStates[card] = false;
    }
  }

  void toggleCard(String card) {
    try {
      cardStates[card] = !cardStates[card]!;
      updateCardState();
    } catch (e) {
      print('error logging card state');
      cardStates[card] = !cardStates[card]!;
    }
  }
}
