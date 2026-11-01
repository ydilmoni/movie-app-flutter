# Architecture — Movie App

> Status: v0.1 · 2026-11-01 · Flutter (web + mobile) · Data: TMDB API

## 1. What the app does

| Screen | What the user does |
|---|---|
| **Home** | Sees popular movies. Types in the search field and presses Enter to search. Taps a heart to add/remove a favorite. |
| **Favorites** | Sees only the movies they marked. Can remove a favorite. |

Navigation: a bottom bar with two tabs (Home, Favorites).

## 2. Layers

```
┌──────────── UI ─────────────┐
│ screens/   one file per screen
│ widgets/   small reusable pieces (MovieCard)
└──────────────┬──────────────┘
               │ reads state, calls actions
┌──────────── State ──────────┐
│ now:     setState in the parent screen
│ step 7:  Riverpod providers
└──────────────┬──────────────┘
               │ calls
┌──────────── Service ────────┐
│ services/movie_api.dart   HTTP + JSON → Movie
└──────────────┬──────────────┘
               ▼
          TMDB REST API
```

**Rules**
- UI never imports `http` and never sees JSON. It only gets `Movie` objects.
- `Movie` is plain data (`final` fields + `fromJson`). No logic, no HTTP.
- Widgets in `widgets/` are stateless. They get data and callbacks through the constructor (`movie`, `isFavorite`, `onFavoriteTap`).
- State lives in the closest common parent (lifting state up). Favorites are shared by Home and Favorites, so they live above both.

## 3. Folder structure

```
lib/
├── main.dart                  runApp only
├── app.dart                   MaterialApp, theme, bottom navigation  (step 6c)
├── models/
│   └── movie.dart
├── services/
│   └── movie_api.dart         getPopularMovies(), searchMovies(query)
├── screens/                   (step 6c)
│   ├── home_screen.dart       search field + list
│   └── favorites_screen.dart
├── widgets/
│   └── movie_card.dart
├── providers/                 (step 7) movies + favorites
└── theme/
    └── app_theme.dart         colors and text styles from DESIGN_SYSTEM.md
```

## 4. Data flow

**Load / search**
```
Home opens        → moviesFuture = getPopularMovies()
Enter in search   → setState: moviesFuture = searchMovies(text)   (empty text → popular)
FutureBuilder     → waiting: spinner · error: message · data: list of MovieCard
```

**Favorites**
```
tap heart  → onFavoriteTap() → toggleFavorite(movie) in the parent
           → setState: add or remove by movie.id
           → rebuild: each MovieCard gets isFavorite(movie) → filled or empty heart
```
Favorites are compared by `id`, not by object, because every API call creates new `Movie` objects.

## 5. Decisions

| Topic | Decision | Why |
|---|---|---|
| API | TMDB, package `http` | Simple, well documented, enough for GET requests |
| API key | Not in code. `--dart-define-from-file=env.json` (gitignored) | Public repo |
| State | `setState` first, Riverpod in step 7 | Learn why Riverpod is needed before using it |
| Async UI | `FutureBuilder` | Loading, error and data states in one place |
| Navigation | `BottomNavigationBar`, no router | Two screens. GoRouter only if deep links are needed |
| Favorites storage | In memory | Lost on restart. Persist (`shared_preferences`) only if needed later |

## 6. Errors

- Service throws `Exception` when `statusCode != 200`.
- `FutureBuilder` shows the error text instead of crashing.
- No internet → same path (the request throws).

## 7. Run

```
flutter run -d chrome --dart-define-from-file=env.json
```
`env.json`: `{"TMDB_KEY": "<your key>"}`

## 8. Not now

TV series, genres, persistence, tests beyond `fromJson` and favorites toggle. See the plan in the learning notes.
