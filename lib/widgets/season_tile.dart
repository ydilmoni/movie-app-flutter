import 'package:flutter/material.dart';
import '../models/media_details.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';
import '../models/movie.dart';
import '../models/part_mark.dart';
import 'part_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/part_marks_provider.dart';

class SeasonTile extends ConsumerWidget {
  final Movie series;
  final Season season;
  final VoidCallback onTap;
  final bool isSelected;
  static const width = 130.0;

  const SeasonTile({
    super.key,
    required this.series,
    required this.season,
    required this.onTap,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefix = 's${season.number}e';
    final watchedCount = ref
        .watch(watchedPartsProvider)
        .where((m) => m.series.isSame(series) && m.part.startsWith(prefix))
        .length;
    final episodesText = watchedCount == 0
        ? '${season.episodeCount} ep'
        : '$watchedCount/${season.episodeCount} ep';
    return Material(
      // (B)
      color: AppColors.surfaceHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? const BorderSide(color: AppColors.accent, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        // (C)
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline, // (A)
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        season.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      // (B)
                      child: Text(
                        episodesText,
                        textDirection: TextDirection.ltr, // (C)
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(season.airDate),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                PartButtons(
                  series: series,
                  part: seasonPart(season.number),
                  watchParts: [
                    for (var e = 1; e <= season.episodeCount; e++)
                      episodePart(season.number, e),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
