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

import '../services/media_services.dart';

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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      Future.microtask(() async {
        final mediaService = context.read<MediaService>();
        final success = await mediaService.fetchMediaFromFirestore(uid, widget.category);
        if (success) {
          final mediaMap = mediaService.mediaMap;
          final watchlistProvider = context.read<WatchlistProvider>();
          watchlistProvider.clearAll();
          mediaMap.forEach((_, media) => watchlistProvider.addMedia(media));
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColors.bgColor,
        body: AppScaffoldWrapper(
          child: Column(
            children: <Widget>[

              Expanded(
                child: Consumer<WatchlistProvider>(
                  builder: (context, watchlistProvider, _) {
                    final mediaList = watchlistProvider.mediaList;
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
              TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, constants.RoutePaths.MediaItems, arguments: widget.category);
                  },
                  child: const Text('add')
              ),
            ]
          )
        )
    );
  }
}
