import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final void Function() onFavoriteTap;
  final bool isFavorite;    
  

  const MovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteTap,
    required this.isFavorite,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: movie.posterUrl == null                     // ← חדש
            ? const Icon(Icons.movie)
            : Image.network(movie.posterUrl!, width: 40),
        title:Text(movie.title),
        subtitle: Text(movie.releaseDate),
        trailing: IconButton(
          icon:Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color:isFavorite ? Colors.red : null
            ),
            
          onPressed: () {
            onFavoriteTap();
          },//onPressed
        ),
      )

    );
  }
}