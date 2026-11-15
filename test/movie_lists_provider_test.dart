import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/movie_lists_provider.dart';
import 'package:movie_app/providers/storage_provider.dart';

ProviderContainer makeContainer(SharedPreferences prefs) {
  final container = ProviderContainer(
    overrides: [prefsProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  final movie = Movie(id: 1, title: 'Swat', releaseDate: '2003-08-08');
  final show = Movie(id: 1, title: 'S.W.A.T.', releaseDate: '2017-11-02', mediaType: 'tv');

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  test('toggle once adds the movie', () {
    final container = makeContainer(prefs);

    container.read(favoritesProvider.notifier).toggle(movie);

    expect(container.read(favoritesProvider).length, 1);
  });

  test('toggle twice removes the movie', () {
    final container = makeContainer(prefs);
    final favorites = container.read(favoritesProvider.notifier);

    favorites.toggle(movie);
    favorites.toggle(movie);

    expect(container.read(favoritesProvider), isEmpty);
  });

  test('movie and tv show with the same id are both kept', () {
    final container = makeContainer(prefs);
    final favorites = container.read(favoritesProvider.notifier);

    favorites.toggle(movie);
    favorites.toggle(show);

    expect(container.read(favoritesProvider).length, 2);
  });

  test('saved list is loaded again after restart', () {
    makeContainer(prefs).read(favoritesProvider.notifier).toggle(show);

    final restarted = makeContainer(prefs);
    final loaded = restarted.read(favoritesProvider);

    expect(loaded.length, 1);
    expect(loaded.first.isSame(show), true);
  });

  test('lists are independent', () {
    final container = makeContainer(prefs);

    container.read(favoritesProvider.notifier).toggle(movie);

    expect(container.read(watchedProvider), isEmpty);
  });
}
