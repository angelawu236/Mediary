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
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Cancel'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value){
                      query = value;
                      userSpecific = value;
                    },
                    decoration: constants.textFieldDecoration
                        .copyWith(hintText: 'Media Name'),
                  ),
                ),
                SizedBox(width: 3),
                TextButton(
                  onPressed: () async {
                    await mediaList.search(query!);
                    setState(() {
                      _hasSearched = true;
                    });
                    print(mediaList.searchResults[0].titleText);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: myColors.mediumGreenColor, // background color
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
                  if (mediaList.searchResults.isEmpty) {
                    return _hasSearched
                        ? Text('No Results :(')
                        : SizedBox();
                  }
                  return ListView.builder(
                    itemCount: mediaList.searchResults.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                            ),
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
                        );
                      }

                      final result = mediaList.searchResults[index - 1];
                      if (result.titleText != "title not found" &&
                          result.posterPath != null &&
                          result.posterPath!.isNotEmpty &&
                          result.date != null &&
                          result.date!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: result.isSelected == true
                                  ? myColors.lightHighlightGoldColor
                                  : Colors.white,
                            ),
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
                                mediaList.selectResult(index - 1);
                              },
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink(); // This won’t add visible space now
                      }
                    },
                  );


                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final selected = context.read<MediaProvider>().selectedResult;
                  if (selected != null) {
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
                  }
              
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.mediumGreenColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
