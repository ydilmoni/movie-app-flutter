class MediaDetails {
  final String overview;
  final List<String> genres;
  final int? collectionId;
  final List<Season> seasons;

  MediaDetails({
    required this.overview,
    required this.genres,
    required this.collectionId,
    required this.seasons
  });

  factory MediaDetails.fromJson(Map<String, dynamic> json){
    return 
    MediaDetails(
      overview: json['overview']??"",
      genres: (json['genres'] as List).map((g) => g['name'] as String).toList(),
      collectionId: json['belongs_to_collection']?['id'],
      seasons: (json['seasons'] as List? ?? []).map((s) => Season.fromJson(s)).toList(),);
  }
}

class Season {
  final int number;
  final String name;
  final int episodeCount;

  Season({required this.number, required this.name, required this.episodeCount});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      number: json['season_number'],
      name: json['name'] ?? '',
      episodeCount: json['episode_count'] ?? 0,
    );
  }
}
