import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_lists_provider.dart';
class MovieCard extends ConsumerWidget  {
  final Movie movie;
  
  

  const MovieCard({
    super.key,
    required this.movie,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider); 
    final isFavorite = favorites.any((m) => m.isSame(movie));
    final watchlist = ref.watch(watchlistProvider);
    final isInWatchlist = watchlist.any((m) => m.isSame(movie));
    final watched =  ref.watch(watchedProvider);
    final isItWatched = watched.any((m) => m.isSame(movie));

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: movie.posterUrl == null
                        ? Container(
                            color: AppColors.surfaceHigh,
                            child: const Icon(Icons.movie, color: AppColors.textSecondary),
                          )
                        : Image.network(movie.posterUrl!, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: _PosterButton(
                    icon: isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    isSelected: isInWatchlist,
                    tooltip: 'Want to watch',
                    onPressed: () => ref.read(watchlistProvider.notifier).toggle(movie),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 8,
                  child: _PosterButton(
                    icon: isItWatched ? Icons.check_circle : Icons.check_circle_outline,
                    isSelected: isItWatched,
                    tooltip: 'Already seen',
                    onPressed: () => ref.read(watchedProvider.notifier).toggle(movie),
                  ),
                ),
              ],
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
                tooltip: 'Add to favorites',
                onPressed: () => ref.read(favoritesProvider.notifier).toggle(movie),
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

class _PosterButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String tooltip;
  final VoidCallback onPressed;

  const _PosterButton({
    required this.icon,
    required this.isSelected,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: IconButton(
        iconSize: 22,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
        tooltip: tooltip,
        icon: Icon(icon, color: isSelected ? AppColors.accent : Colors.white70),
        onPressed: onPressed,
      ),
    );
  }
}