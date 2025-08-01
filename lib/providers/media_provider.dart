import 'package:flutter/material.dart';
import '../models/media_model.dart';
import '../services/media_api_service.dart';

class MediaProvider with ChangeNotifier {
  final MediaAPIService _service = MediaAPIService ();
  List<MediaModel> _searchResults = [];

  List<MediaModel> get searchResults => _searchResults;

  Future<void> search(String query) async {

    try {
      _searchResults = await _service.searchMovies(query);
    } catch (e) {
      print(e);
      _searchResults = [];
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  void selectResult(int index) {
    for (int i = 0; i < searchResults.length; i++) {
      searchResults[i].isSelected = i == index;
    }
    notifyListeners();
  }

  MediaModel? get selectedResult {
    try {
      return searchResults.firstWhere((m) => m.isSelected!);
    } catch (e) {
      return null; // nothing selected
    }
  }

}
