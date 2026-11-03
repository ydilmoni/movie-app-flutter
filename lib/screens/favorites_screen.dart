import 'package:flutter/material.dart';
import '../widgets/movie_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget  {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider); // ← the list from the board
    if (favorites.isEmpty) {
      return const Center(child: Text('No favorites yet.'));
    }
    return MovieGrid(movies: favorites);
  }
}