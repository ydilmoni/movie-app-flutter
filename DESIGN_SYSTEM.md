# Design System — Movie App

> Status: v0.1 · 2026-11-01 · Dark only · Look: Spotify-style dark + green, posters in a 3-column grid

## 1. Principles

1. **Posters first.** The poster is the content. Text is small and quiet under it.
2. **One accent color.** Green means "yours / active": favorites, selected tab, spinner. Nothing else is green.
3. **Dark and calm.** Near-black background, gray surfaces, no gradients or shadows.

## 2. Colors

Use the token name in code (`AppColors.accent`), never a raw hex.

| Token | Hex | Use |
|---|---|---|
| `background` | `#121212` | App background |
| `surface` | `#181818` | Bottom bar, cards behind posters |
| `surfaceHigh` | `#282828` | Search field, poster placeholder |
| `textPrimary` | `#FFFFFF` | Titles |
| `textSecondary` | `#B3B3B3` | Year, hints, unselected tab |
| `accent` | `#1DB954` | Filled heart, selected tab, spinner, buttons |
| `error` | `#E24B4A` | Error message icon |

## 3. Typography

Default Material font (Roboto) for now. Option later: `google_fonts` with a rounded sans (e.g. Figtree) for a closer Spotify feel.

| Token | Size | Weight | Use |
|---|---|---|---|
| `screenTitle` | 24 | Bold | "Movies", "Favorites" |
| `posterTitle` | 13 | Medium (500) | Movie title under poster, 1 line, ellipsis |
| `caption` | 12 | Regular | Year under title, `textSecondary` |

## 4. Spacing and shape

| Token | Value | Use |
|---|---|---|
| `gap` | 8 | Between grid items |
| `pagePadding` | 12 | Screen edges |
| `radiusSmall` | 6 | Posters |
| `radiusPill` | 24 | Search field |

## 5. Components

**Movie tile** (replaces the current `ListTile` card)
```
┌─────────┐
│  poster │ ♥   heart top-right, on a black 60% circle
│   2:3   │
└─────────┘
Title of movie…     posterTitle, 1 line
2026                caption
```
- Poster: `https://image.tmdb.org/t/p/w342{poster_path}`. No poster → `surfaceHigh` box with a film icon.
- Heart: empty `textSecondary` / filled `accent`.

**Grid:** `GridView`, 3 columns, `gap` 8, poster ratio 2:3 + room for two text lines.

**Search field:** filled `surfaceHigh`, `radiusPill`, search icon, hint "Search movies", no border.

**Bottom bar:** `background` color, two tabs (Home, Favorites). Selected = `accent`, unselected = `textSecondary`.

**States**
| State | Look |
|---|---|
| Loading | Centered spinner in `accent` |
| Error | `error` icon + short message + "Try again" button |
| No results | "No movies found for "batman"" in `textSecondary` |
| No favorites | "Tap the heart on a movie to save it here." |

## 6. In Flutter

- All tokens in `lib/theme/app_theme.dart`: `AppColors` + one `ThemeData` (`useMaterial3: true`, `ColorScheme.dark(...)` from the table above).
- `MaterialApp(theme: appTheme)`. Widgets read colors from the theme or `AppColors`, never write hex.

## 7. Not now

Light mode, animations, custom fonts, a hero banner.
