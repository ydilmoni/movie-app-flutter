import 'movie.dart';

class PartMark {
  final Movie series;
  final String part;

  PartMark({required this.series, required this.part});

  factory PartMark.fromJson(Map<String, dynamic> json) {
    return PartMark(
      series: Movie.fromJson(json['series']),
      part: json['part'],
    );
  }

  Map<String, dynamic> toJson() => {'series': series.toJson(), 'part': part};

  bool isSame(PartMark other) =>
      series.isSame(other.series) && part == other.part;
}

String seasonPart(int season) => 's$season';
String episodePart(int season, int episode) => 's${season}e$episode';