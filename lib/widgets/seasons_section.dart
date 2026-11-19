import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/media_details.dart';
import '../providers/details_provider.dart';
import 'season_tile.dart';
import 'episode_tile.dart';
import '../models/episode.dart';
import '../utils/date_format.dart';
import '../theme/app_theme.dart';
class SeasonsSection extends ConsumerStatefulWidget {
  final int tvId;                                                       // (A)
  final List<Season> seasons;

  const SeasonsSection({super.key, required this.tvId, required this.seasons});

  @override
  ConsumerState<SeasonsSection> createState() => _SeasonsSectionState();
}

class _SeasonsSectionState extends ConsumerState<SeasonsSection> {
  static const gap = 8.0;
  bool showAll = false;
  int? selectedNumber;                                                  // (B)

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = ((constraints.maxWidth + gap) / (SeasonTile.width + gap)).floor();
        final limit = (perRow < 1 ? 1 : perRow) * 2;
        final hasMore = widget.seasons.length > limit;
        final visible = showAll || !hasMore
            ? widget.seasons
            : widget.seasons.take(limit).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final season in visible)
                  SeasonTile(
                    season: season,
                    isSelected: season.number == selectedNumber,         // (C)
                    onTap: () => setState(() => selectedNumber = season.number),
                  ),
              ],
            ),
            if (hasMore)
              TextButton.icon(
                onPressed: () => setState(() => showAll = !showAll),
                icon: Icon(showAll ? Icons.expand_less : Icons.expand_more),
                label: Text(showAll ? 'Show less' : 'See more'),
              ),
            if (selectedNumber != null) ...[                            // (D)
              const SizedBox(height: 16),
              _buildEpisodes(selectedNumber!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEpisodes(int seasonNumber) {                             // (E)
    final episodesAsync =
        ref.watch(seasonProvider((tvId: widget.tvId, season: seasonNumber)));

    return episodesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (episodes) {                                               // (D)
        final range = _dateRange(episodes);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (range.isNotEmpty) ...[
              Text(range, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
            ],
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final episode in episodes) EpisodeTile(episode: episode),
              ],
            ),
          ],
        );
      },
    );
  }

  String _dateRange(List<Episode> episodes) {
    final dates = episodes
        .map((e) => e.airDate)                                         // (A)
        .where((d) => d.isNotEmpty)                                    // (B)
        .toList();
    if (dates.isEmpty) return '';
    return '${formatDate(dates.first)} - ${formatDate(dates.last)}';   // (C)
  }
}