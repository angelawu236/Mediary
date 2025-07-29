import 'package:flutter/material.dart';
import '../models/media_model.dart';
import 'dart:collection';

class WatchlistProvider extends ChangeNotifier {
  final List<MediaModel> _mediaList = [];

  UnmodifiableListView<MediaModel> get mediaList => UnmodifiableListView(_mediaList);

  int get count => _mediaList.length;

  void addMedia(MediaModel media) {
    _mediaList.add(media);
    notifyListeners();
  }

  void deleteMedia(MediaModel media) {
    _mediaList.remove(media);
    notifyListeners();
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
