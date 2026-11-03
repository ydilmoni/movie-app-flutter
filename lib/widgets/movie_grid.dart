import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;

  const MovieGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 200,   // רוחב מקסימלי של כל משבצת
      childAspectRatio: 0.58,      // רוחב חלקי גובה: כל משבצת גבוהה פי 2 מרוחבה
      mainAxisSpacing: 8,         // רווח בין שורות
      crossAxisSpacing: 8,        // רווח בין טורים
      padding: const EdgeInsets.all(12),
      children: movies.map((movie) => 
                    MovieCard(
                      movie: movie,
                      )).toList(),  
                    );
  }
}