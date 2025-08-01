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
  String? query;
  String? userSpecific;

  @override
  Widget build(BuildContext context) {
    final watchlist = context.watch<WatchlistProvider>().mediaList;
    final mediaList = context.read<MediaProvider>();

    return Scaffold(
      backgroundColor: myColors.bgColor,
      body: AppScaffoldWrapper(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
              },
              child: Text('get media data from firebase')
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
                    print(mediaList.searchResults[0].titleText);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: myColors.mediumGreenColor, // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // rectangle corners
                    ),
                    padding: EdgeInsets.all(13), // size of button
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.black, // icon color
                    size: 22,
                  ),
                ),

              ],
            ),
            SizedBox(height: 20),
            Consumer<MediaProvider>(
              builder: (context, mediaList, child) {
                if (mediaList.searchResults.isEmpty) {
                  return Text('No Results :(');
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: mediaList.searchResults.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final result = mediaList.searchResults[index];
                    if (result.titleText != "title not found") {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: result.isSelected == true
                        ? myColors.lightHighlightGoldColor
                            : Colors.white,
                        ),
                        child: ListTile(
                          title: Text(result.titleText!),
                          subtitle: Text(result.date ?? ''),
                          onTap: () {
                            mediaList.selectResult(index);
                          },
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                );
              },
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
                          title: selected.titleText ?? userSpecific ?? '',
                          date: selected.date ?? '',
                          category: widget.category,
                          id: selected.id!,
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
