import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../widgets/movie_grid.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesProvider);

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(hintText: 'Search movies...'),
          onSubmitted: (String userSearchInput) {
            ref.read(searchQueryProvider.notifier).setQuery(userSearchInput);
          },
        ),
        Expanded(
          child: moviesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (movies) => MovieGrid(movies: movies),
          ),
        ),
      ],
    );
  }
}


