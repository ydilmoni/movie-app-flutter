class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;

  Movie({required this.id,
    required this.title, 
    required this.releaseDate,
    this.posterPath,});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'title': title,
      'release_date': releaseDate,
      'poster_path': posterPath
    };
  }


  String? get posterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w342$posterPath';
    }
    return null;
  }

}