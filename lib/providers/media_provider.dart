import 'package:flutter/material.dart';
import '../models/media_model.dart';
import '../services/media_api_service.dart';

class MediaProvider with ChangeNotifier {
  final MediaService _service = MediaService ();
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

}
