import 'package:flutter/material.dart';
import '../models/episode.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

class EpisodeTile extends StatelessWidget {
  final Episode episode;
  static const width = 180.0;

  const EpisodeTile({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(                                                   // (A)
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${episode.number}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(episode.name, maxLines: 1, overflow: TextOverflow.ellipsis),  // (B)
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(formatDate(episode.airDate),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}