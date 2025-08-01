import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediary/ui/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'scaffold_wrapper.dart';
import 'package:mediary/providers/cards_provider.dart';
import 'package:mediary/services/card_services.dart';
import 'package:mediary/models/card_model.dart';
import 'package:mediary/ui/widgets/card_view.dart';
import 'package:mediary/app_router.dart' as RoutePaths;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
//steps: have a button. on pressed, load from json and store into firestore. show "success" if so. then, fetch from firestore
//and load onto screen.
//todo: check if user's uid exists in the db yet. should be users/uid/cards and users/uid/media. if so, read from cards.json
//if not, read from firestore.

class _HomeState extends State<Home> {

  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    final cardsProvider = Provider.of<CardsProvider>(context);

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: ListView(
          children: <Widget>[
            const Text(
              constants.Titles.homeTitle, // 'My Media'
              style: TextStyle(
                color: myColors.darkTextColor,
                fontSize: 45,
              )
            ),
            TextButton(
              onPressed: () async {
                if(await cardsProvider.doesUserExist(_auth.currentUser!.uid)){
                  print('found user in firestore database, yay');
                  await cardsProvider.getCardsFirestore(_auth.currentUser!.uid);
                } else {
                  print('user not found in firestore, have to load again');
                  await cardsProvider.getCardsJson();
                  cardsProvider.storeCardsFirestore();
                }
              },
              child: Text('get data'),
            ),
            ...cardsProvider.cards.entries.map((entry) {
              final card = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, constants.RoutePaths.MediaList, arguments: card.titleText );
                  },
                  child: CardContainer(
                    titleText: card.titleText ?? 'Untitled',
                    active: card.cardActive ?? false,
                  ),
                ),
              );
            }),
          ]
        ),
      )
    );
  }

}
