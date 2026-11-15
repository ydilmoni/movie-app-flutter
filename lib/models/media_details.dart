class MediaDetails {
  final String overview;
  final List<String> genres;
  final int? collectionId;

  MediaDetails({
    required this.overview,
    required this.genres,
    required this.collectionId,

  });

  factory MediaDetails.fromJson(Map<String, dynamic> json){
    return 
    MediaDetails(overview: json['overview']??"",genres: (json['genres'] as List).map((g) => g['name'] as String).toList(), collectionId: json['belongs_to_collection']?['id']);
  }
}
