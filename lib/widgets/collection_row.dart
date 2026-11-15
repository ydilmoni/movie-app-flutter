import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/details_provider.dart';
import 'movie_card.dart';

class CollectionRow extends ConsumerWidget {
  final int collectionId;

  const CollectionRow({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(collectionProvider(collectionId));       // (A)

    return partsAsync.when(
      loading: () => const SizedBox.shrink(),                              // (B)
      error: (error, stack) => const SizedBox.shrink(),
      data: (movies) => SizedBox(
        height: 260,                                                       // (C)
        child: ListView.separated(
          scrollDirection: Axis.horizontal,                                // (D)
          itemCount: movies.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) => SizedBox(
            width: 140,
            child: MovieCard(movie: movies[index]),                        // (E)
          ),
        ),
      ),
    );
  }
}