import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import 'language_provider.dart';
import 'media_type_provider.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String text) {
    state = text.trim();
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);
final movieApiProvider = Provider<MovieApi>((ref) => MovieApi());
final moviesProvider = FutureProvider<List<Movie>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final api = ref.watch(movieApiProvider);
  final language = ref.watch(languageProvider);
  final movieType = ref.watch(mediaTypeProvider);
  return query.isEmpty
      ? api.getPopularMovies(language, movieType)
      : api.searchMovies(query, language, movieType);
});
