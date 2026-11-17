import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/media_details.dart';
import '../models/movie.dart';
import '../models/episode.dart';

const _apiKey = String.fromEnvironment('TMDB_KEY');
const _baseUrl = 'https://api.themoviedb.org/3';

class MovieApi {
  Future<List<Movie>> getPopularMovies(
    String language,
    String mediaType,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/$mediaType/popular?api_key=$_apiKey&language=$language',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch popular movies');
    }
    final data = jsonDecode(response.body);
    final List results = data['results'];
    return results
        .map((json) => Movie.fromJson(json, mediaType: mediaType))
        .toList();
  }

  Future<List<Movie>> searchMovies(
    String query,
    String language,
    String mediaType,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/search/$mediaType?api_key=$_apiKey&language=$language&query=${Uri.encodeQueryComponent(query)}',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to search movies');
    }
    final data = jsonDecode(response.body);
    final List results = data['results'];

    return results
        .map((json) => Movie.fromJson(json, mediaType: mediaType))
        .toList();
  }

  Future<MediaDetails> getDetails(
    int id,
    String mediaType,
    String language,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$mediaType/$id?api_key=$_apiKey&language=$language'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch popular movies');
    }
    final data = jsonDecode(response.body);
    return MediaDetails.fromJson(data);
  }

  Future<List<Movie>> getCollection(int id, String language) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/collection/$id?api_key=$_apiKey&language=$language',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch this movies collection');
    }
    final data = jsonDecode(response.body);
    final List results = data['parts'];
    final movies = results.map((json) => Movie.fromJson(json)).toList();
    movies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    return movies;
  }

    Future<List<Episode>> getSeason(int tvId, int seasonNumber, String language) async {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/tv/$tvId/season/$seasonNumber?api_key=$_apiKey&language=$language',
        ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch episodes for this season');
      }
      final data = jsonDecode(response.body);
      final List results = data['episodes'];
      final episodes = results.map((json) => Episode.fromJson(json)).toList();
      return episodes;
    }
}
