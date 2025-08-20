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
      backgroundColor: myColors.bgColor,
      appBar: AppBar(
        title: Text(
          '$category Details',
          style: TextStyle(
            color: myColors.lightTextColor,
            fontSize: 25,
          ),
        ),
        backgroundColor: myColors.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: myColors.lightTextColor),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (posterPath.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 225,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w342$posterPath',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: myColors.darkImageColor,
                          );
                        },
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 225,
                    child: Container(
                      color: myColors.darkImageColor,
                    ),
                  ),
                ),

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Title: $title',
                    style: TextStyle(
                        fontSize: 18, color: myColors.lightTextColor),
                  ),
                  Text(
                    'Release Date: $date',
                    style: TextStyle(
                        fontSize: 16, color: myColors.lightTextColor),
                  ),
                  SizedBox(height: 12),
                ],
              ),
              SizedBox(height: 12),
              TextField(
                cursorColor: myColors.brightOutlineColor,
                style: TextStyle(color: myColors.brightOutlineColor),
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  labelStyle: TextStyle(color: myColors.brightOutlineColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // bottom line
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // when focused
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                onChanged: (value) {
                  comments = value;
                },
              ),
              TextField(
                cursorColor: myColors.brightOutlineColor,
                style: TextStyle(color: myColors.brightOutlineColor),
                decoration: const InputDecoration(
                  labelText: 'Rating',
                  labelStyle: TextStyle(color: myColors.brightOutlineColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // bottom line
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // when focused
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rating = int.tryParse(value) ?? 0;
                },
              ),
              TextField(
                cursorColor: myColors.brightOutlineColor,
                style: TextStyle(color: myColors.brightOutlineColor),
                decoration: const InputDecoration(
                  labelText: 'Date Watched',
                  labelStyle: TextStyle(color: myColors.brightOutlineColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // bottom line
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: myColors.brightOutlineColor), // when focused
                  ),
                ),
                onChanged: (value) {
                  watched_date = value;
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70, // tweak to your taste
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: myColors.brightOutlineColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.only(bottom: 7),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
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

            Navigator.pushNamed(context, constants.RoutePaths.MediaList,
                arguments: category);
          },
          child: const Text(
            'Add',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
