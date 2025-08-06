import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediary/providers/media_provider.dart';
import 'package:provider/provider.dart';
import '../models/media_model.dart';
import '../providers/watchlist_provider.dart';
import 'package:mediary/ui/widgets/media_card.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/ui/scaffold_wrapper.dart';
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/ui/add_media_details_screen.dart';

import '../services/watchlist_services.dart';

class MediaListScreen extends StatefulWidget {
  final String category;

  const MediaListScreen({
    required this.category,

});


  @override
  State<MediaListScreen> createState() => _MediaListScreenState();
}

class _MediaListScreenState extends State<MediaListScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistProvider>().loadMedia(widget.category);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
              '${widget.category} List',
              style: TextStyle(
                fontSize: 25,
                color: myColors.lightTextColor,
              )
          ),
          backgroundColor: myColors.bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: myColors.lightTextColor),
            onPressed: () {
              Navigator.pushNamed(context, constants.RoutePaths.NavBar);
            },
          ),
        ),
        backgroundColor: myColors.bgColor,
        body: AppScaffoldWrapper(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Consumer<WatchlistProvider>(
                  builder: (context, watchListProvider, _) {
                    final mediaList = watchListProvider.mediaList;
                    if (mediaList.isEmpty) {
                      return Center(child: Text('No media in this category.'));
                    }
                    return ListView.builder(
                      itemCount: mediaList.length,
                      itemBuilder: (context, index) {
                        return MediaCard(media: mediaList[index]);
                      },
                    );
                  },
                ),
              ),
            ]
          )
        ),
      bottomNavigationBar: SizedBox(
        height: 70, // tweak to your taste
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: myColors.brightOutlineColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.only(bottom: 15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              constants.RoutePaths.MediaItems,
              arguments: widget.category,
            );
          },
          child: const Text(
              'Add Media',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
