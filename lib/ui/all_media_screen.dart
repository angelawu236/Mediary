import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediary/ui/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'animation.dart';
import 'scaffold_wrapper.dart';
import 'package:mediary/providers/cards_provider.dart';
import 'package:mediary/services/card_services.dart';
import 'package:mediary/models/card_model.dart';
import 'package:mediary/ui/widgets/card_view.dart';
import 'package:mediary/app_router.dart' as RoutePaths;
import 'package:mediary/ui/add_dialogue.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final cardsProvider = Provider.of<CardsProvider>(context, listen: false);
      final uid = _auth.currentUser?.uid;

      if (uid != null) {
        if (await cardsProvider.doesUserExist(uid)) {
          print('found user in firestore database, yay');
          await cardsProvider.getCardsFirestore(uid);
        } else {
          print('user not found in firestore, have to load again');
          await cardsProvider.getCardsJson();
          cardsProvider.storeCardsFirestore();
        }
      }
    });

  }


  @override
  Widget build(BuildContext context) {

    final cardsProvider = Provider.of<CardsProvider>(context);

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        constants.Titles.homeTitle,
                        style: TextStyle(
                          color: myColors.lightTextColor,
                          fontSize: 45,
                        ),
                      ),
                      IconButton(
                        iconSize: 45,
                          onPressed: (){
                            final route = cupertinoForwardRoute(const ProfileScreen());
                            Navigator.of(context).pushReplacement(route);
                          // Navigator.pushNamed(context, constants.RoutePaths.Profile);
                          },
                          icon: Icon(Icons.person, color: myColors.paleBlueColor)
                      )
                    ],
                  ),
                  ...cardsProvider.cards.entries.map((entry) {
                    final card = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            constants.RoutePaths.MediaList,
                            arguments: card.titleText,
                          );
                        },
                        child: CardContainer(
                          titleText: card.titleText ?? 'Untitled',
                          active: card.cardActive ?? false,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70, // tweak to your taste
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: myColors.brightOutlineColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.only(bottom: 7),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddCategoryDialog(),
            );
          },
          child: const Text(
            'Add Category',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );

  }

}
