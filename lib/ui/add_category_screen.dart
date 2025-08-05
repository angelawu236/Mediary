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

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  String? category;

  @override
  Widget build(BuildContext context) {
    final cardsProvider = Provider.of<CardsProvider>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Category Title'),
              onChanged: (value) {
                category = value;
              },
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.mediumGreenColor,
                ),
                onPressed: () {
                  if (category != null && category!.trim().isNotEmpty && uid != null) {
                    final newCard = CardsModel(
                      cardActive: true,
                      titleText: category!.trim(),
                    );
                    cardsProvider.addCard(uid, newCard);

                    // Optionally go back after adding
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Category', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

