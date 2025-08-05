import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/models/media_model.dart';
import 'package:mediary/ui/media_details_screen.dart';

import '../../providers/watchlist_provider.dart';

class MediaCard extends StatelessWidget {
  final MediaModel media;

  const MediaCard({
    Key? key,
    required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaDetailsScreen(media: media),
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(7),
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
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
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
                icon: const Icon(Icons.delete, size: 20, color: myColors.systemErrorTextColor),
                onPressed: () {
                  context.read<WatchlistProvider>().deleteMedia(media);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


