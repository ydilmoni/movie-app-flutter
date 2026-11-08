# Design System — Movie App

> Status: v0.2 · 2026-11-05 · Dark only · Look: Spotify-style dark + green, a poster grid that adapts to screen width

## 1. Principles

1. **Posters first.** The poster is the content. Text is small and quiet under it.
2. **One accent color.** Green means "yours / active": favorites, selected tab, spinner. Nothing else is green.
3. **Dark and calm.** Near-black background, gray surfaces, no gradients or shadows.

## 2. Colors

Use the token name in code (`AppColors.accent`), never a raw hex.

| Token | Hex | Use |
|---|---|---|
| `background` | `#121212` | App background |
| `surface` | `#181818` | Bottom bar |
| `surfaceHigh` | `#282828` | Search field, poster placeholder, card border |
| `textPrimary` | `#FFFFFF` | Titles |
| `textSecondary` | `#B3B3B3` | Year, hints, empty heart, unselected tab |
| `accent` | `#1DB954` | Filled heart, favorite card border, selected tab, spinner |
| `error` | `#E24B4A` | `colorScheme.error` (not used directly yet) |

## 3. Typography

Default Material font and sizes (Roboto). No custom text styles yet.
- Movie title: default size, 1 line, ellipsis.
- Year: default size, `textSecondary`.

## 4. Spacing and shape

| Name | Value | Use |
|---|---|---|
| gap | 8 | Between grid items |
| page padding | 12 | Grid edges |
| poster radius | 6 | Posters |
| card radius | 8 | Card border |
| pill radius | 24 | Search field |

These values are written directly in the widgets. Only colors are tokens in code (`AppColors`).

## 5. Components

**Movie tile** (`widgets/movie_card.dart`)
```
┌───────────┐  1px border: surfaceHigh, accent when favorite
│  poster   │  fills the height left above the text row
│           │
├───────────┤
│ ♥ Title…  │  heart 32px left of title, top-aligned; title 1 line, ellipsis
│   2026    │  textSecondary
└───────────┘
```
- Poster: `https://image.tmdb.org/t/p/w342{poster_path}`, `BoxFit.cover`, poster radius. It is `Expanded`, not a fixed 2:3 box, so the card never overflows its grid cell at any screen width. No poster → `surfaceHigh` box with a film icon.
- Heart: empty `textSecondary` / filled `accent`. The border turns `accent` too, so a favorite reads at a glance.

**Grid** (`widgets/movie_grid.dart`, shared by Home and Favorites): `GridView.extent`, max tile width 200 (2 columns on a phone, 5+ in landscape or on desktop), gap 8, page padding 12, `childAspectRatio` 0.58.

**Search field:** filled `surfaceHigh`, pill radius, hint "Search movies...", no border. Search runs on Enter.

**Poster buttons:** bookmark (Want to watch) top-left, check circle (Watched) top-right, opposite corners so they are not confused. Icon 22 on a `black54` circle. Not selected: outline, `white70`. Selected: filled, `accent`. Each has a tooltip.

**Bottom bar:** `surface` color, four fixed tabs (Home, Favorites, Watchlist, Watched). Selected = `accent`, unselected = `textSecondary`.

**States**
| State | Look |
|---|---|
| Loading | Centered spinner in `accent` |
| Error | Centered text `Error: …` |
| No results | Empty grid |
| Empty list | Centered text: "No favorites yet." / "Nothing to watch yet." / "Nothing watched yet." |

## 6. In Flutter

- Colors in `lib/theme/app_theme.dart`: `AppColors` + one `ThemeData` (`useMaterial3: true`, `ColorScheme.dark(...)`, bottom bar theme, input theme).
- `MaterialApp(theme: appTheme, debugShowCheckedModeBanner: false)`. Widgets read colors from the theme or `AppColors`, never write hex.

## 7. Not now

Light mode, animations, custom fonts (e.g. `google_fonts` with Figtree), text style and spacing tokens in code, an error icon + "Try again" button, a "No movies found" message, a search icon in the field, a hero banner.
