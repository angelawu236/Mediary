import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/media_model.dart';
import 'dart:collection';
import 'package:mediary/services/watchlist_services.dart';

class WatchlistProvider extends ChangeNotifier {
  final List<MediaModel> _mediaList = [];
  final WatchListService watchListService = WatchListService();

  UnmodifiableListView<MediaModel> get mediaList =>
      UnmodifiableListView(_mediaList);

  int get count => _mediaList.length;

  Future<void> loadMedia(String category) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final success =
        await watchListService.fetchMediaFromFirestore(uid, category);

    if (success) {
      watchListService.mediaMap.forEach(
          (k, v) => print('$k → ${v.titleText}, ${v.category}, ${v.index}'));
      clearAll();
      watchListService.mediaMap.forEach((_, media) => _mediaList.add(media));
      notifyListeners();
    }
  }

  Future<void> storeAllMedia(String category) async {
    final mediaToStore = {
      for (var media in _mediaList)
        media.titleText!: media..category = category,
    };

    await watchListService.storeMedia(mediaToStore);
  }

  void addMedia(MediaModel media) {
    _mediaList.add(media);
    notifyListeners();
  }

  Future<void> addAndStoreMedia(MediaModel media, String category) async {
    _mediaList.add(media);
    notifyListeners();
    await storeAllMedia(category);
  }

  void deleteMedia(MediaModel media) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('media')
            .doc(media.id.toString())
            .delete();

        // Then remove locally by ID
        _mediaList.removeWhere((item) => item.id == media.id);
        notifyListeners();
      } catch (e) {
        print('Failed to delete from Firestore: $e');
      }
    }
  }


  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;

    final item = _mediaList.removeAt(oldIndex);
    _mediaList.insert(newIndex, item);
    notifyListeners();
  }

  void clearAll() {
    _mediaList.clear();
    notifyListeners();
  }
}
