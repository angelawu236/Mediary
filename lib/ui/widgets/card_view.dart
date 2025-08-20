import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediary/providers/cards_provider.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/ui/scaffold_wrapper.dart';

//ui container for a card, returns a single card
class CardContainer extends StatelessWidget {
  CardContainer({
    super.key,
    required this.titleText,
    required this.active,
    required this.docId,
    required this.onDelete,
  });

  final String titleText;
  final bool active;
  final _auth = FirebaseAuth.instance;
  final String docId;
  final VoidCallback onDelete;

  Future<int?> _fetchCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 0;

    final query = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('media')
        .where('category', isEqualTo: titleText);

    final agg = await query.count().get(); // aggregate count, no doc downloads
    return agg.count;
  }

  @override
  Widget build(BuildContext context) {
    if (active) {
      return Card(
          color: myColors.categoryCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Container(
              height: 90,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                    top: 10.0, right: 8.0, bottom: 10.0, left: 15.0),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 25,
                        color: myColors.brightOutlineColor,
                      ),
                    ),
                    const SizedBox(width: 7),
                    FutureBuilder<int?>(
                      future: _fetchCount(),
                      builder: (context, snap) {
                        final n = snap.data ?? 0;
                        return Text(
                          '($n)',
                          style: const TextStyle(fontSize: 14, color: myColors.lightTextColor),
                        );
                      },
                    ),
                  ],
                ),

                trailing: IconButton(
                  icon: Icon(Icons.delete,
                      size: 20, color: myColors.bgColor),
                  onPressed: onDelete,
                ),

              )

              // buildCardContent(context),
              ));
    }
    return const Text('not active!'); //not active
  }

  Widget buildCardContent(context) {
    return const SizedBox(
      height: 100,
      width: double.infinity,
    );
  }
}
