import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

const _apiKey = String.fromEnvironment('TMDB_KEY');
const _baseUrl = 'https://api.themoviedb.org/3';

class MovieApi {
  Future<List<Movie>> getPopularMovies(String language, String mediaType) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$mediaType/popular?api_key=$_apiKey&language=$language'),

    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch popular movies');
    }
    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results.map((json) => Movie.fromJson(json, mediaType: mediaType)).toList();
  }

Future<List<Movie>> searchMovies(String query, String language, String mediaType) async {
  final response = 
  await http.get(Uri.parse('$_baseUrl/search/$mediaType?api_key=$_apiKey&language=$language&query=${Uri.encodeQueryComponent(query)}'));
    if (response.statusCode != 200) {
      throw Exception('Failed to search movies');
    }
    final data = jsonDecode(response.body);
    final List results = data['results'];

    return results.map((json) => Movie.fromJson(json, mediaType: mediaType)).toList();
  }
}
