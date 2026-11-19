import 'package:flutter/material.dart';
import '../models/media_details.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

class SeasonTile extends StatelessWidget {
  final Season season;
  final VoidCallback onTap;
  final bool isSelected;
  static const width = 130.0;


  const SeasonTile({super.key, required this.season, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Material(                                          // (B)
      color: AppColors.surfaceHigh,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? const BorderSide(color: AppColors.accent, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(                                         // (C)
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
                  crossAxisAlignment: CrossAxisAlignment.baseline,       // (A)
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
                    Flexible(                                            // (B)
                      child: Text(
                        '${season.episodeCount} ep',
                        textDirection: TextDirection.ltr,                // (C)
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(formatDate(season.airDate),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}