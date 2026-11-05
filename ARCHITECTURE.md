# Architecture — Movie App

> Status: v0.2 · 2026-11-05 · Flutter (web + mobile) · Riverpod 3 · Data: TMDB API

## 1. What the app does

| Screen | What the user does |
|---|---|
| **Home** | Sees popular movies. Types in the search field and presses Enter to search (empty search → popular again). Taps a heart to add/remove a favorite. |
| **Favorites** | Sees only the movies they marked. Can remove a favorite. |

Navigation: a bottom bar with two tabs (Home, Favorites). `IndexedStack` keeps both screens alive, so switching tabs does not lose the search.

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
| `moviesProvider` | `FutureProvider<List<Movie>>` | Popular or search results | Home (`.when`) |
| `favoritesProvider` | `NotifierProvider<…, List<Movie>>` | Favorite movies (`toggle`, `isFavorite`) | `MovieCard`, Favorites screen |

`MainApp` keeps only `currentTab` in `setState`. It is local UI state, so it does not need a provider.

## 4. Folder structure

```
lib/
├── main.dart                     ProviderScope, MaterialApp, theme, bottom navigation
├── models/
│   └── movie.dart
├── services/
│   └── movie_api.dart            class MovieApi: getPopularMovies(), searchMovies(query)
├── providers/
│   ├── favorites_provider.dart   FavoritesNotifier + favoritesProvider
│   └── search_provider.dart      searchQueryProvider, movieApiProvider, moviesProvider
├── screens/
│   ├── home_screen.dart          search field + MovieGrid
│   └── favorites_screen.dart     MovieGrid of favorites, or an empty message
├── widgets/
│   ├── movie_grid.dart           GridView.extent shared by both screens
│   └── movie_card.dart           poster, heart, title, year
└── theme/
    └── app_theme.dart            AppColors + ThemeData (see DESIGN_SYSTEM.md)
test/
└── movies_test.dart              FakeMovieApi + moviesProvider test
```

## 5. Data flow

**Load / search**
```
Home opens        → ref.watch(moviesProvider)
                  → moviesProvider: query is '' → api.getPopularMovies()
Enter in search   → ref.read(searchQueryProvider.notifier).setQuery(text)
                  → searchQueryProvider changes → moviesProvider runs again
                  → api.searchMovies(text)   (empty text → popular)
.when             → loading: spinner · error: message · data: MovieGrid
```

**Favorites**
```
tap heart  → ref.read(favoritesProvider.notifier).toggle(movie)
           → state = new list (added or removed by movie.id)
           → every widget that watches favoritesProvider rebuilds:
             MovieCard (filled heart + green border), Favorites screen
```
Favorites are compared by `id`, not by object, because every API call creates new `Movie` objects.

## 6. Testing (dependency injection)

`test/movies_test.dart` builds a `ProviderContainer` with
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
| Navigation | `BottomNavigationBar` + `IndexedStack`, no router | Two screens. GoRouter only if deep links are needed |
| Favorites storage | In memory | Lost on restart. Persist (`shared_preferences`) only if needed later |

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

TV series, genres, persistence, a retry button, more tests (search, favorites toggle).
