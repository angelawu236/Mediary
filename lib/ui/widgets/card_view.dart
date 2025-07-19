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
    required this.hide,
  });

  final String titleText;
  final bool active;
  final Function hide;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 0.0, right: 8.0, bottom: 0.0, left: 8.0),
                  visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                  title: Text(titleText),
                ),
                buildCardContent(context),

              ]
          )
      );
    }
    return const Text('not active!'); //not active

  }

  Widget buildCardContent(context){
    return const SizedBox(
      width: double.infinity,
        child: Center(
        child: SizedBox(
        height: 32,
        width: 32,
        child: CircularProgressIndicator(
          color: myColors.lightGreenColor,
        )),
    ),
    );
  }
}
