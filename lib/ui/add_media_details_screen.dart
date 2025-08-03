import 'package:flutter/material.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:mediary/models/media_model.dart';
import 'package:provider/provider.dart';
import '../models/media_model.dart';
import '../providers/watchlist_provider.dart';
import 'package:mediary/ui/widgets/media_card.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/ui/scaffold_wrapper.dart';
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/app_router.dart' as RoutePaths;

import '../services/media_api_service.dart';
import '../services/watchlist_services.dart';

class MediaDetailFormScreen extends StatelessWidget {
  final String title;
  final String date;
  final String posterPath;
  final String category;
  final int id;

  const MediaDetailFormScreen({
    required this.title,
    required this.date,
    required this.category,
    required this.id,
    required this.posterPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? comments;
    int? rating;
    String? watched_date;

    return Scaffold(
      appBar: AppBar(title: Text('$category Details')),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (posterPath.isNotEmpty)
                Center(
                  child: ClipRRect(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 150,
                        maxHeight: 300,
                      ),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w342$posterPath',
                        fit: BoxFit.contain, // keeps aspect ratio
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 100, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                )
              else
                Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Title: $title',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Release Date: $date',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'Comments'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                onChanged: (value) {
                  comments = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rating = int.tryParse(value) ?? 0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Date Watched'),
                onChanged: (value) {
                  watched_date = value;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () async {
                    final watchlistProvider = context.read<WatchlistProvider>();

                    final media = MediaModel(
                      titleText: title,
                      date: date,
                      id: id,
                      isSelected: false,
                      comments: comments,
                      rating: rating,
                      dateWatched: watched_date,
                      category: category,
                      index: watchlistProvider.count,
                      posterPath: posterPath,
                    );

                    watchlistProvider.addMedia(media);
                    await watchlistProvider.storeAllMedia(category);

                    Navigator.pushNamed(context, constants.RoutePaths.MediaList, arguments: category);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.mediumGreenColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
