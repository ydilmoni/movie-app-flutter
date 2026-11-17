import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/media_details.dart';
import '../providers/details_provider.dart';

class SeasonScreen extends ConsumerWidget {
  final int tvId;                                                   // (A)
  final Season season;

  const SeasonScreen({super.key, required this.tvId, required this.season});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync =
        ref.watch(seasonProvider((tvId: tvId, season: season.number)));   // (B)

    return Scaffold(
      appBar: AppBar(title: Text(season.name)),
      body: episodesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (episodes) => ListView.builder(                       // (C)
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return ListTile(
              leading: Text('${episode.number}'),                   // (D)
              title: Text(episode.name),
              subtitle: Text(episode.airDate),
            );
          },
        ),
      ),
    );
  }
}