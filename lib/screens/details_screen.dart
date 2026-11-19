import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/details_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/collection_row.dart';
import '../widgets/seasons_section.dart';
import '../widgets/list_buttons.dart';
import '../widgets/expandable_text.dart';
import '../models/media_details.dart';
import '../providers/language_provider.dart';

class DetailsScreen extends ConsumerWidget {
  final Movie movie;
  static const wideBreakpoint = 700.0;                                   // (A)

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(detailsProvider(movie));
    final loaded = detailsAsync.value;
    final language = ref.watch(languageProvider);
    final yearText = Text(
      _years(loaded, language),
      textDirection: TextDirection.ltr,                                // (E)
      style: Theme.of(context).textTheme.titleMedium,
    );
    // the pieces                                                         (B)
    final title = Text(movie.title, style: Theme.of(context).textTheme.headlineSmall);
    final genres = loaded == null
        ? const SizedBox.shrink()
        : Text(loaded.genres.join(' · '),
            style: const TextStyle(color: AppColors.textSecondary));
    final overview = detailsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (details) => ExpandableText(text: details.overview),
    );
    final extras = Column(                                               // (C)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loaded != null && loaded.collectionId != null) ...[
          const SizedBox(height: 16),
          CollectionRow(collectionId: loaded.collectionId!),
        ],
        if (loaded != null && loaded.seasons.isNotEmpty) ...[
          const SizedBox(height: 16),
          SeasonsSection(tvId: movie.id, seasons: loaded.seasons),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > wideBreakpoint;          // (D)
          return ListView(
            padding: const EdgeInsets.all(16),
            children: isWide
                ? [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _poster(220),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(                                       // (E)
                                spacing: 16,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [title, yearText, genres, ListButtons(movie: movie)],
                              ),
                              const SizedBox(height: 16),
                              overview,
                            ],
                          ),
                        ),
                      ],
                    ),
                    extras,
                  ]
                : [
                    title,
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _poster(130),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              yearText,
                              const SizedBox(height: 4),
                              genres,
                              const SizedBox(height: 8),
                              ListButtons(movie: movie),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    overview,
                    extras,
                  ],
          );
        },
      ),
    );
  }

  Widget _poster(double width) {                                         // (F)
    return SizedBox(
      width: width,
      child: movie.posterUrl == null
          ? null
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(movie.posterUrl!),
            ),
    );
  }

  String _years(MediaDetails? loaded, String language) {
    final start = movie.releaseDate.split('-').first;
    if (loaded == null || movie.mediaType != 'tv') return start;     // (C)
if (loaded.inProduction) return '$start–${language == 'he-IL' ? 'היום' : 'Today'}';
    final end = loaded.lastAirDate.split('-').first;
    if (end.isEmpty || end == start) return start;                   // (D)
    return '$start–$end';
  }
}