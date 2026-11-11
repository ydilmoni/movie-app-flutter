import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/movie_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/providers/search_provider.dart';

class FakeMovieApi implements MovieApi {
  @override
  Future<List<Movie>> getPopularMovies(String language, String movieType) async {
    return [Movie(id: 1, title: 'Fake Movie', releaseDate: '2024-01-01')];
  }

  @override
  Future<List<Movie>> searchMovies(String query, String language, String movieType) async {
    return [Movie(id: 2, title: 'Found $query', releaseDate: '2024-01-01')];
  }
}

void main() {
  test('moviesProvider uses the fake api', () async {
    final container = ProviderContainer(
      overrides: [movieApiProvider.overrideWithValue(FakeMovieApi())],
    );
    addTearDown(container.dispose);

    final movies = await container.read(moviesProvider.future);

    expect(movies.first.title, 'Fake Movie');
  });
}