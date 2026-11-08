import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../providers/movie_lists_provider.dart';
import '../widgets/movie_grid.dart';

class MovieListScreen extends ConsumerWidget {
  final NotifierProvider<MovieListNotifier, List<Movie>> provider;
  final String emptyMessage;

  const MovieListScreen({
    super.key,
    required this.provider,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(provider);
    if (movies.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return MovieGrid(movies: movies);
  }
}