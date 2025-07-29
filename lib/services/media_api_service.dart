import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_model.dart';

class MediaService {
  final String _apiKey = '5ffda2f52235ec6ba42433b16cc2518c';

  Future<List<MediaModel>> searchMovies(String query) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final results = jsonBody['results'] as List;
      return results.map((e) => MediaModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

}
