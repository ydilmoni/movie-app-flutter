import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';

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
    final year = movie.releaseDate.length >= 4 ? movie.releaseDate.substring(0, 4) : '';
    return Container(
      padding: const EdgeInsets.all(2),   // רווח בין הגבול לתוכן
      decoration: BoxDecoration(
        border: Border.all(
          color: isFavorite ? AppColors.accent : AppColors.surfaceHigh,   // ירוק למועדף, אפור לשאר
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,  // יחס של פוסטר: רוחב 2, גובה 3
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: 
              movie.posterUrl == null? Container(
                      color: AppColors.surfaceHigh,
                      child: const Icon(Icons.movie, color: AppColors.textSecondary),
                      )
                      : Image.network(movie.posterUrl!, fit: BoxFit.cover),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,   // ← חדש: ילדים צמודים למעלה
            children: [
              IconButton(
                iconSize: 32,                               // גדול: בערך בגובה 3 השורות
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.accent : AppColors.textSecondary,
                ),
                onPressed: onFavoriteTap,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,     // טקסט צמוד לשמאל
                  children: [
                    Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(year, style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}