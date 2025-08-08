import 'package:flutter/cupertino.dart';

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


class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  String? category;

  @override
  Widget build(BuildContext context) {
    final cardsProvider = Provider.of<CardsProvider>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return AlertDialog(
      backgroundColor: myColors.darkImageColor.withOpacity(0.5), // translucent dark
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        'New Category',
        style: TextStyle(color: Colors.white),
      ),
      content: TextField(
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Category Title',
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onChanged: (value) => category = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: myColors.darkImageColor, // button text
          ),
          onPressed: () {
            if (category != null && category!.trim().isNotEmpty && uid != null) {
              final newCard = CardsModel(
                cardActive: true,
                titleText: category!.trim(),
              );
              if (!cardsProvider.cards.containsKey(newCard.titleText)) {
                cardsProvider.addCard(uid, newCard);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category already exists')),
                );
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );

  }
}
