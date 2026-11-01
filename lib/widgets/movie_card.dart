import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final void Function() onFavoriteTap;

  const MovieCard({super.key, required this.movie, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title:Text(movie.title),
        subtitle: Text(movie.releaseDate),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            onFavoriteTap();
          },//onPressed
        ),
      )

    );
  }
}