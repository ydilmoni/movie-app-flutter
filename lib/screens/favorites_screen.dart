import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Movie> favorites;
  final void Function(Movie movie) onToggleFavorite;

  const FavoritesScreen({super.key, required this.favorites, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }
    return ListView(
      children: favorites.map((movie) => 
        MovieCard(
          movie: movie,
          isFavorite: true,
          onFavoriteTap: () {
            onToggleFavorite(movie);
          },
        )
      ).toList(),
    );
  }
}