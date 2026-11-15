import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/media_details.dart';
import 'search_provider.dart';
import 'language_provider.dart';

final detailsProvider = FutureProvider.autoDispose.family<MediaDetails, Movie>((ref, movie) {
  final api = ref.watch(movieApiProvider);
  final language = ref.watch(languageProvider);
  return api.getDetails(movie.id, movie.mediaType, language);
});

final collectionProvider = FutureProvider.autoDispose.family<List<Movie>, int>((ref, collectionId) {
  final api = ref.watch(movieApiProvider);
  final language = ref.watch(languageProvider);
  return api.getCollection(collectionId, language);
});