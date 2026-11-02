import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final bool Function(Movie movie) isFavorite;
  final void Function(Movie movie) onToggleFavorite;

  const MovieGrid({super.key, required this.movies, required this.isFavorite, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,          // 3 בשורה
      childAspectRatio: 0.5,      // רוחב חלקי גובה: כל משבצת גבוהה פי 2 מרוחבה
      mainAxisSpacing: 8,         // רווח בין שורות
      crossAxisSpacing: 8,        // רווח בין טורים
      padding: const EdgeInsets.all(12),
      children: movies.map((movie) => 
                    MovieCard(
                      movie: movie,
                      isFavorite: isFavorite(movie),
                      onFavoriteTap:   () {
                      onToggleFavorite(movie);
                      },
                    )
                  ).toList(),
    ); 
  }
}