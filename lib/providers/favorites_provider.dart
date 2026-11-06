import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import 'dart:convert';
import 'storage_provider.dart';

class FavoritesNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() {
    final prefs = ref.read(prefsProvider);
    final texts = prefs.getStringList('favorites') ?? [];
    return texts.map((text) => Movie.fromJson(jsonDecode(text))).toList();
  }

  bool isFavorite(Movie movie) => state.any((m) => m.id == movie.id);

  void toggle(Movie movie) {
    if (isFavorite(movie)) {
      state = state.where((m) => m.id != movie.id).toList();   // רשימה חדשה, בלי הסרט
    } else {
      state = [...state, movie];                               // רשימה חדשה, עם הסרט
    }
    _save();
  }
  void _save() {
    final prefs = ref.read(prefsProvider);
    final texts = state.map((movie) => jsonEncode(movie.toJson())).toList();
    prefs.setStringList('favorites', texts);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Movie>>(FavoritesNotifier.new);