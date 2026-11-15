import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/details_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/collection_row.dart';

class DetailsScreen extends ConsumerWidget {
  final Movie movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(detailsProvider(movie));

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (movie.posterUrl != null)
            Center(
              child: SizedBox(
                width: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(movie.posterUrl!),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
          Text(movie.releaseDate),
          const SizedBox(height: 16),
          detailsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
            data: (details) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.genres.join(' · '),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(details.overview),
                if (details.collectionId != null) ...[
                  const SizedBox(height: 16),
                  CollectionRow(collectionId: details.collectionId!),
                ],               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
