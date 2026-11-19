# Architecture — Movie App

> Status: v0.3 · 2026-11-11 · Flutter (web + mobile) · Riverpod 3 · Data: TMDB API

## 1. What the app does

| Screen | What the user does |
|---|---|
| **Home** | Sees popular movies. Types in the search field and presses Enter to search (empty search → popular again). Taps a heart to add/remove a favorite. |
| **Favorites / Watchlist / Watched** | Sees the movies marked in that list. Can unmark them. A movie can be in any combination of the three lists. |

Navigation: a bottom bar with four tabs (Home, Favorites, Watchlist, Watched). `IndexedStack` keeps the screens alive, so switching tabs does not lose the search.

## 2. Layers

```
┌──────────── UI ─────────────┐
│ screens/   one file per screen (ConsumerWidget)
│ widgets/   MovieGrid, MovieCard
└──────────────┬──────────────┘
               │ ref.watch (read + rebuild) · ref.read (actions)
┌──────────── State ──────────┐
│ providers/   Riverpod providers
└──────────────┬──────────────┘
               │ calls (injected through movieApiProvider)
┌──────────── Service ────────┐
│ services/movie_api.dart   class MovieApi: HTTP + JSON → Movie
└──────────────┬──────────────┘
               ▼
          TMDB REST API
```

**Rules**
- UI never imports `http` and never sees JSON. It only gets `Movie` objects.
- `Movie` is plain data (`final` fields + `fromJson` + `posterUrl` getter). No HTTP.
- No prop drilling: widgets read shared state from providers, not through constructors. `MovieCard` gets only `movie`.
- Providers never create `MovieApi` themselves. They get it from `movieApiProvider`, so tests can replace it.
- State is immutable: a provider's `state` is replaced with a new list, never changed in place.

## 3. Providers

| Provider | Type | Holds | Who reads it |
|---|---|---|---|
| `movieApiProvider` | `Provider<MovieApi>` | The API client | `moviesProvider` |
| `searchQueryProvider` | `NotifierProvider<…, String>` | The search text (`setQuery`, trimmed) | `moviesProvider`; Home writes it |
| `languageProvider` | `NotifierProvider<…, String>` | TMDB language, `he-IL` or `en-US` (`setLanguage`) | `moviesProvider`, `LanguageButton` |
| `mediaTypeProvider` | `NotifierProvider<…, String>` | `movie` or `tv` (`toggleMediaType`). The value goes straight into the TMDB path (`/movie/popular`, `/tv/popular`). Set by the `Movies \| Series` buttons (`setMediaType`) | `moviesProvider`, Home |
| `moviesProvider` | `FutureProvider<List<Movie>>` | Popular or search results in the chosen language and media type | Home (`.when`) |
| `favoritesProvider`, `watchlistProvider`, `watchedProvider` | `NotifierProvider<MovieListNotifier, List<Movie>>` | Three independent lists of the same class, each with its own storage key (`toggle`). Loads from `prefsProvider` in `build`, saves on every `toggle` | `MovieCard`, `MovieListScreen` |
| `detailsProvider` | `FutureProvider.autoDispose.family<MediaDetails, Movie>` | Overview, genres, collection id, seasons, last air date and in-production flag of one movie / TV show (`/{mediaType}/{id}`) | `DetailsScreen` |
| `collectionProvider` | `FutureProvider.autoDispose.family<List<Movie>, int>` | The movies of one collection, sorted by release date (`/collection/{id}`) | `CollectionRow` |
| `seasonProvider` | `FutureProvider.autoDispose.family<List<Episode>, ({int tvId, int season})>` | The episodes of one season. The key is a record, so each show + season pair gets its own cached result (`/tv/{id}/season/{n}`) | `SeasonsSection` |
| `prefsProvider` | `Provider<SharedPreferences>` | Device storage. No default: `main` opens it (`await`) and injects it with `overrideWithValue` | `favoritesProvider` |

`MainApp` keeps only `currentTab` in `setState`. `SeasonsSection` keeps `showAll` and `selectedNumber`, and `ExpandableText` keeps `isExpanded`. All of these are local UI state, so they do not need a provider.

## 4. Folder structure

```
lib/
├── main.dart                     opens SharedPreferences, ProviderScope, MaterialApp, theme, bottom navigation
├── models/
│   ├── movie.dart
│   ├── media_details.dart        MediaDetails (overview, genres, collectionId, seasons, lastAirDate, inProduction) + Season
│   └── episode.dart              Episode (number, name, airDate)
├── services/
│   └── movie_api.dart            class MovieApi: getPopularMovies(language, mediaType), searchMovies(query, language, mediaType), getDetails, getCollection, getSeason
├── providers/
│   ├── movie_lists_provider.dart MovieListNotifier + favorites, watchlist and watched providers
│   ├── language_provider.dart    LanguageNotifier + languageProvider
│   ├── media_type_provider.dart  MediaTypeNotifier + mediaTypeProvider (movie / tv)
│   ├── storage_provider.dart     prefsProvider (overridden in main)
│   └── search_provider.dart      searchQueryProvider, movieApiProvider, moviesProvider
├── screens/
│   ├── home_screen.dart          search field + Movies | Series buttons + MovieGrid
│   ├── movie_list_screen.dart    any list provider as a MovieGrid, or an empty message
│   └── details_screen.dart       LayoutBuilder: phone (title, poster + year/genres/buttons, overview below) or wide > 700 (poster beside title row + overview); then collection or seasons
├── widgets/
│   ├── movie_grid.dart           GridView.extent shared by both screens
│   ├── movie_card.dart           poster, heart, title, year
│   ├── language_button.dart      🌐 menu in the top bar (Hebrew / English)
│   ├── collection_row.dart       horizontal row of MovieCards for a collection
│   ├── list_buttons.dart         favorite / watched / watchlist toggles on the details screen
│   ├── expandable_text.dart      overview limited to 4 lines + More / Less (measured with TextPainter)
│   ├── seasons_section.dart      season tiles in a Wrap (2 rows + See more), tap a season to show its episodes below with the date range
│   ├── season_tile.dart          one season: name, episode count, start date
│   └── episode_tile.dart         one episode: number, name, air date
├── utils/
│   └── date_format.dart          formatDate: 2015-12-24 -> 24.12.2015
└── theme/
    └── app_theme.dart            AppColors + ThemeData (see DESIGN_SYSTEM.md)
test/
├── movie_model_test.dart         Movie.fromJson (TV fields)
└── movies_provider_test.dart     FakeMovieApi + moviesProvider test
```

## 5. Data flow

**Load / search**
```
Home opens        → ref.watch(moviesProvider)
                  → moviesProvider: query is '' → api.getPopularMovies()
Enter in search   → ref.read(searchQueryProvider.notifier).setQuery(text)
                  → searchQueryProvider changes → moviesProvider runs again
                  → api.searchMovies(text, language)   (empty text → popular)
Movies | Series  → ref.read(mediaTypeProvider.notifier).setMediaType('tv')
                  → moviesProvider runs again: /tv/popular or /search/tv
Language menu     → ref.read(languageProvider.notifier).setLanguage('en-US')
                  → moviesProvider runs again with the new language
.when             → loading: spinner · error: message · data: MovieGrid
```

**Favorites**
```
tap heart  → ref.read(favoritesProvider.notifier).toggle(movie)
           → state = new list (added or removed by movie.id)
           → _save(): the list is written to shared_preferences
           → every widget that watches favoritesProvider rebuilds:
             MovieCard (filled heart + green border), MovieListScreen
Watchlist and Watched work the same way, through the buttons on the poster.
```
List items are compared with `Movie.isSame` (`id` + `mediaType`), not by object, because every API call creates new `Movie` objects, and a movie and a TV show can share the same TMDB `id`.

## 6. Testing (dependency injection)

`test/movies_provider_test.dart` builds a `ProviderContainer` with
`movieApiProvider.overrideWithValue(FakeMovieApi())`.
`FakeMovieApi implements MovieApi` and returns fixed movies, so the test runs the real `moviesProvider` code with no network and known data.

```
flutter test
```

## 7. Decisions

| Topic | Decision | Why |
|---|---|---|
| API | TMDB, package `http` | Simple, well documented, enough for GET requests |
| API key | Not in code. `--dart-define-from-file=env.json` (gitignored) | Public repo |
| State | Riverpod 3 (started with `setState`, moved in step 7) | Removes prop drilling, and allows overriding providers in tests |
| Async UI | `FutureProvider` + `AsyncValue.when` | Loading, error and data in one place, refetches when the search changes |
| Service | A class, injected through `movieApiProvider` | Can be replaced by a fake in tests |
| Lists | One `MovieListNotifier` class, three providers, three separate lists (not one status field) | A movie can be favorite, watched and on the watchlist in any combination |
| Navigation | `BottomNavigationBar` (fixed, 4 tabs) + `IndexedStack`, no router | Few screens. GoRouter only if deep links are needed |
| Favorites storage | `shared_preferences`, a list of JSON strings under `favorites` (`Movie.toJson` / `fromJson`) | One small list, no queries needed. Cloud (Supabase + login) later, by replacing what `prefsProvider` holds |
| Opening storage | `await` in `main`, then `overrideWithValue` | `build` must return at once and cannot wait for storage to open |

## 8. Errors

- `MovieApi` throws `Exception` when `statusCode != 200`.
- `moviesProvider` turns it into an error state, and Home shows `Error: …` instead of crashing.
- No internet → same path (the request throws).

## 9. Run

```
flutter run -d chrome --dart-define-from-file=env.json
```
`env.json`: `{"TMDB_KEY": "<your key>"}`

## 10. Not now

UI translation (ARB files; RTL already follows `languageProvider`), cloud sync, marking seasons and episodes in the three lists (planned: episode-level watched, filtered series view from a list), filtering the lists by movie/TV, genres, a retry button, more tests (search, favorites toggle).
