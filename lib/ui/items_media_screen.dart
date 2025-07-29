import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/media_model.dart';
import '../providers/watchlist_provider.dart';
import 'package:mediary/ui/widgets/media_card.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/ui/scaffold_wrapper.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({Key? key}) : super(key: key);

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  @override
  void initState() {
    super.initState();
    // Add dummy data for testing
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    if (watchlistProvider.mediaList.isEmpty) {
      watchlistProvider.addMedia(
        MediaModel(
          titleText: "Inception",
          comments: "Great movie!",
          rating: 5,
          id: "1",
          date: "2025-07-28",
        ),
      );
      watchlistProvider.addMedia(
        MediaModel(
          titleText: "Interstellar",
          comments: "Emotional and deep.",
          rating: 4,
          id: "2",
          date: "2025-07-28",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = context.watch<WatchlistProvider>().mediaList;

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: ListView.builder(
          itemCount: watchlist.length,
          itemBuilder: (context, index) {
            final media = watchlist[index];
            return MediaCard(media: media);
          },
        ),
      ),
    );
  }
}
