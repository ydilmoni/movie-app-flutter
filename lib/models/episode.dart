class Episode {
  final int number;
  final String name;
  final String airDate;

  Episode({required this.number, required this.name, required this.airDate});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      number: json['episode_number'],
      name: json['name'] ?? '',
      airDate: json['air_date'] ?? '',
    );
  }
}