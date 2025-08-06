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

class AddMediaScreen extends StatefulWidget {
  final String category;

  const AddMediaScreen({
    required this.category
});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaProvider = context.read<MediaProvider>();
      mediaProvider.clearSearch();
      setState(() {
        _hasSearched = false;
        query = null;
        userSpecific = null;
      });
    });
  }
  String? query;
  String? userSpecific;
  bool _hasSearched = false;

  @override
  Widget build(BuildContext context) {
    final watchlist = context.watch<WatchlistProvider>().mediaList;
    final mediaList = context.read<MediaProvider>();

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: myColors.brightOutlineColor),
                    onChanged: (value){
                      query = value;
                      userSpecific = value;
                    },
                    decoration: constants.textFieldDecoration
                        .copyWith(hintText: 'Media Name'),
                  ),
                ),
                SizedBox(width: 15),
                TextButton(
                  onPressed: () async {
                    await mediaList.search(query!);
                    setState(() {
                      _hasSearched = true;
                    });
                    print(mediaList.searchResults[0].titleText);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: myColors.mediaCardColor, // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // rectangle corners
                    ),
                    padding: EdgeInsets.all(13), // size of button
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.black, // icon color
                    size: 22,
                  ),
                ),

              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<MediaProvider>(
                builder: (context, mediaList, child) {
                  final results = mediaList.searchResults;

                  final hasManual = _hasSearched ? 1 : 0;
                  final noResultsRow = (_hasSearched && results.isEmpty) ? 1 : 0;
                  final itemCount = results.length + hasManual + noResultsRow;

                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      // Manual tile only after search
                      if (index == 0 && _hasSearched) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                            ),
                            child: Container(
                              color: myColors.mediaCardColor,
                              child: ListTile(
                                title: Text(userSpecific ?? 'Custom Media'),
                                subtitle: const Text('(Add manually)'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaDetailFormScreen(
                                        posterPath: '',
                                        title: userSpecific ?? '',
                                        date: '',
                                        category: widget.category,
                                        id: DateTime.now().millisecondsSinceEpoch,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }

                      // When not searched yet and index==0, render nothing
                      if (index == 0 && !_hasSearched) {
                        return const SizedBox.shrink();
                      }

                      final base = _hasSearched ? 1 : 0;

                      // "No Results" row right after the manual tile
                      if (_hasSearched && results.isEmpty && index == base) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              'No Search Results Found',
                              style: TextStyle(color: myColors.brightOutlineColor),
                            ),
                          ),
                        );
                      }

                      // Actual results
                      final resultIndex = index - base; // safe now
                      final result = results[resultIndex];

                      if (result.titleText != "title not found" &&
                          (result.posterPath?.isNotEmpty ?? false) &&
                          (result.date?.isNotEmpty ?? false)) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: result.isSelected == true
                                  ? myColors.lightHighlightGoldColor
                                  : Colors.white,
                            ),
                            child: Container(
                              color: myColors.mediaCardColor,
                              child: ListTile(
                                leading: Image.network(
                                  result.posterPath!,
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(result.titleText ?? ''),
                                subtitle: Text(result.date ?? ''),
                                onTap: () {
                                  final selected = results[resultIndex];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaDetailFormScreen(
                                        posterPath: selected.posterPath ?? '',
                                        title: selected.titleText ?? userSpecific ?? '',
                                        date: selected.date ?? '',
                                        category: widget.category,
                                        id: selected.id ?? -1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );

                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
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
            onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
