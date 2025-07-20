import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/ui/scaffold_wrapper.dart';

//ui container for a card, returns a single card
class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.titleText,
    required this.active,
  });

  final String titleText;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return TextButton(
        onPressed: (){},
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Container(
                height: 90,
                  alignment: Alignment.centerLeft,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(
                        top: 10.0, right: 8.0, bottom: 10.0, left: 9.0),
                    title: Text(titleText,
                    style: TextStyle(fontSize: 20)),
                  ),
                  // buildCardContent(context),
            )
        ),
      );
    }
    return const Text('not active!'); //not active
  }

  Widget buildCardContent(context){
    return const SizedBox(
      height: 100,
      width: double.infinity,
    );
  }
}
