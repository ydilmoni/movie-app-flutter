import 'package:flutter/material.dart';
import '../models/media_details.dart';
import 'season_tile.dart';

class SeasonsSection extends StatefulWidget {
  final List<Season> seasons;
  final void Function(Season season) onSeasonTap;             // (A)

  const SeasonsSection({super.key, required this.seasons, required this.onSeasonTap});

  @override
  State<SeasonsSection> createState() => _SeasonsSectionState();
}

class _SeasonsSectionState extends State<SeasonsSection> {
  static const gap = 8.0;
  bool showAll = false;                                        // (B)

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                                      // (C)
      builder: (context, constraints) {
        final perRow = ((constraints.maxWidth + gap) / (SeasonTile.width + gap)).floor();
        final limit = (perRow < 1 ? 1 : perRow) * 2;           // (D)
        final hasMore = widget.seasons.length > limit;
        final visible = showAll || !hasMore
            ? widget.seasons
            : widget.seasons.take(limit).toList();             // (E)

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final season in visible)
                  SeasonTile(season: season, onTap: () => widget.onSeasonTap(season)),
              ],
            ),
            if (hasMore)
              TextButton.icon(                                 // (F)
                onPressed: () => setState(() => showAll = !showAll),
                icon: Icon(showAll ? Icons.expand_less : Icons.expand_more),
                label: Text(showAll ? 'Show less' : 'See more'),
              ),
          ],
        );
      },
    );
  }
}