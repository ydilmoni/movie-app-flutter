import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/media_details.dart';
import 'package:movie_app/services/movie_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/providers/search_provider.dart';
import 'package:movie_app/providers/media_type_provider.dart';

class FakeMovieApi implements MovieApi {
  String? lastMediaType;

  @override
  Future<List<Movie>> getPopularMovies(String language, String movieType) async {
    lastMediaType = movieType;
    return [Movie(id: 1, title: 'Fake Movie', releaseDate: '2024-01-01')];
  }

  @override
  Future<List<Movie>> searchMovies(String query, String language, String movieType) async {
    lastMediaType = movieType;
    return [Movie(id: 2, title: 'Found $query', releaseDate: '2024-01-01')];
  }

  @override
  Future<MediaDetails> getDetails(int id, String mediaType, String language) async {
    lastMediaType = mediaType;
    return MediaDetails(overview: 'Fake overview', genres: ['Drama'], collectionId: null, seasons: []);
  }

  @override
  Future<List<Movie>> getCollection(int id, String language) async {
    return [Movie(id: 3, title: 'Fake Part 1', releaseDate: '2001-01-01')];
  }
}

void main() {
  late FakeMovieApi api;
  late ProviderContainer container;

  setUp(() {
    api = FakeMovieApi();
    container = ProviderContainer(
      overrides: [movieApiProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);
  });

  test('empty search shows popular movies', () async {
    final movies = await container.read(moviesProvider.future);

    expect(movies.first.title, 'Fake Movie');
  });

  test('search text is sent to the api', () async {
    container.read(searchQueryProvider.notifier).setQuery('batman');

    final movies = await container.read(moviesProvider.future);

    expect(movies.first.title, 'Found batman');
  });

  test('starts with movies', () async {
    await container.read(moviesProvider.future);

    expect(api.lastMediaType, 'movie');
  });

  test('after toggle the api is asked for tv', () async {
    container.read(mediaTypeProvider.notifier).toggleMediaType();

    await container.read(moviesProvider.future);

    expect(api.lastMediaType, 'tv');
  });
}
