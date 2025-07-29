import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/ui/scaffold_wrapper.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:mediary/models/media_model.dart';

class MediaCard extends StatelessWidget {
  final MediaModel media;

  const MediaCard({
    Key? key,
    required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        title: Text(
          media.titleText!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((media.comments ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text("Comment: ${media.comments}"),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text("Rating: ${media.rating}/5"),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: (){},
        ),
      ),
    );
  }
}


