class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;
  final String mediaType;

  Movie({required this.id,
    required this.title, 
    required this.releaseDate,
    this.posterPath,
    this.mediaType = 'movie',});

  factory Movie.fromJson(Map<String, dynamic> json,{String? mediaType}) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'],
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
      posterPath: json['poster_path'],
      mediaType: mediaType ?? json['media_type'] ?? 'movie',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'release_date': releaseDate,
      'poster_path': posterPath,
      'media_type': mediaType,
    };
  }


  String? get posterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w342$posterPath';
    }
    return null;
  }

  bool isSame(Movie other){
    return id == other.id && mediaType == other.mediaType;
  }

}