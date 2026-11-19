import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../providers/movie_lists_provider.dart';
import '../theme/app_theme.dart';

class ListButtons extends ConsumerWidget {
  final Movie movie;

  const ListButtons({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,                                    // (A)
      children: [
        _button(ref, favoritesProvider, Icons.favorite, Icons.favorite_border, 'Add to favorites'),
        _button(ref, watchedProvider, Icons.check_circle, Icons.check_circle_outline, 'Already seen'),
        _button(ref, watchlistProvider, Icons.bookmark, Icons.bookmark_border, 'Want to watch'),
      ],
    );
  }

  Widget _button(                                                        // (B)
    WidgetRef ref,
    NotifierProvider<MovieListNotifier, List<Movie>> provider,
    IconData iconOn,
    IconData iconOff,
    String tooltip,
  ) {
    final isInList = ref.watch(provider).any((m) => m.isSame(movie));    // (C)
    return IconButton(
      tooltip: tooltip,
      icon: Icon(
        isInList ? iconOn : iconOff,
        color: isInList ? AppColors.accent : AppColors.textSecondary,
      ),
      onPressed: () => ref.read(provider.notifier).toggle(movie),
    );
  }
}