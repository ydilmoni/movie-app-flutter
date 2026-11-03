import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';

class FavoritesNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];                      // בהתחלה: רשימה ריקה

  bool isFavorite(Movie movie) => state.any((m) => m.id == movie.id);

  void toggle(Movie movie) {
    if (isFavorite(movie)) {
      state = state.where((m) => m.id != movie.id).toList();   // רשימה חדשה, בלי הסרט
    } else {
      state = [...state, movie];                               // רשימה חדשה, עם הסרט
    }
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Movie>>(FavoritesNotifier.new);