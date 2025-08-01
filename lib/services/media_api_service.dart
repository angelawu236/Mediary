import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_model.dart';

class MediaAPIService {
  final String base_url = "https://nslfyxaei0.execute-api.us-east-2.amazonaws.com/default/getMovieData";

  Future<List<MediaModel>> searchMovies(String query) async {
    final uri = Uri.parse('$base_url?media=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final results = jsonBody['results'] as List;
      return results.map((e) => MediaModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

}
