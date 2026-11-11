import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/models/movie.dart';

void main() {
  test('tv json uses name as title', () {
    final movieJ = {'id': 1668, 'name': 'Friends', 'first_air_date': '1994-09-22'};
    final movie = Movie.fromJson(movieJ);
    expect(movie.title, 'Friends');
  });
}