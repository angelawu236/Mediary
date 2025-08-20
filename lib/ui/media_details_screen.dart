import 'package:flutter/material.dart';
import 'package:mediary/models/media_model.dart';
import 'package:mediary/app_constants.dart' as constants;

import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/ui/scaffold_wrapper.dart'; // Make sure this import is here

class MediaDetailsScreen extends StatelessWidget {
  final MediaModel media;

  const MediaDetailsScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.bgColor,
      appBar: AppBar(
        title: Text(media.titleText ?? "Media Details", style: TextStyle(fontSize: 23, color: myColors.lightTextColor, fontWeight: FontWeight.bold),),
        backgroundColor: myColors.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: myColors.lightTextColor),

      ),
      body: AppScaffoldWrapper(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (media.posterPath != null && media.posterPath!.isNotEmpty)
                    ClipRRect(
                      child: Image.network(
                        media.posterPath!,
                        height: 300,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Release Date:",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center),
                      SizedBox(width: 10),
                      Text(
                        "${media.date ?? 'N/A'}",
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if ((media.comments ?? '').isNotEmpty) ...[
                    const Text(
                      "Comments",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      media.comments!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rating: ",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                        textAlign: TextAlign.center,),
                      Text(
                        "${media.rating}/5",
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}

