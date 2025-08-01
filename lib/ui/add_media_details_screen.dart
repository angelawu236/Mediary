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
import '../services/media_services.dart';

class MediaDetailFormScreen extends StatelessWidget {
  final String title;
  final String date;
  final String category;
  final int id;

  const MediaDetailFormScreen({
    required this.title,
    required this.date,
    required this.category,
    required this.id,
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Title: $title',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Date: $date',
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
                  rating = value as int?;
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
                  final mediaService = context.read<MediaService>();

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
                  );

                  await mediaService.storeMedia({media.id!.toString(): media});
                  watchlistProvider.addMedia(media);

                  Navigator.pushNamed(context, constants.RoutePaths.MediaItems, arguments: category);
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
