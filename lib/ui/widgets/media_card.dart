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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 9.0),
              child: ClipRRect(
                child: media.posterPath != null && media.posterPath!.isNotEmpty
                    ? Image.network(
                  media.posterPath!,
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 40, color: Colors.grey);
                  },
                )
                    : Container(
                  width: 50,
                  height: 80,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.titleText!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  if ((media.comments ?? '').isNotEmpty)
                    Text(
                      "Comment: ${media.comments}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                  Text(
                    "Rating: ${media.rating}/5",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );



  }
}


