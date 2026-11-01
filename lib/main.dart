import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'widgets/movie_card.dart';
import 'services/movie_api.dart';

void main() {
   runApp(const MainApp());
}

class MainApp extends StatefulWidget {
	const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
	Future<List<Movie>> moviesFuture = getPopularMovies();
	List<Movie> favorites = [];
	
	bool isFavorite(Movie movie) {
		for (final mo in favorites) {       // עובר על כל סרט ברשימה
			if (mo.id == movie.id) {        // זה אותו סרט?
				return true;                 // כן: מצאתי, הוא במועדפים
			}
		}
		return false;                      // עברתי על כולם ולא מצאתי
	}

	void toggleFavorite(Movie movie) {            // toggle = "להפוך": יש→אין, אין→יש
		setState(() {
		if (isFavorite(movie)) {
			favorites.removeWhere((m) => m.id == movie.id);
		} else {
			favorites.add(movie);
		}
		});
		print('favorites: ${favorites.length}');
 	}

	@override
	Widget build(BuildContext context) {
	return MaterialApp(
		home: Scaffold(
			body: Column(
				children: [
					TextField(
					decoration: const InputDecoration(hintText: 'Search movies...'),
					onSubmitted: (String userSearchInput) {
						setState(() {
							moviesFuture = (userSearchInput.trim().isNotEmpty) ? searchMovies(userSearchInput) : getPopularMovies();
						});
					},
					),
					Expanded(
						child: FutureBuilder<List<Movie>>(
						future: moviesFuture,
							builder: (context, snapshot) {
							if (snapshot.connectionState == ConnectionState.waiting) {
								return const Center(child: CircularProgressIndicator());
							}
							if (snapshot.hasError) {
								return Center(child: Text('Error: ${snapshot.error}'));
							}
							final movies = snapshot.data!;
							return ListView(
								children: movies.map((movie) => 
								MovieCard(
								movie: movie,
								isFavorite: isFavorite(movie),
								onFavoriteTap: () {
									toggleFavorite(movie);
								},
								)).toList(),
											);	
							},
						),
					),
				]
			),
		),
    );
  }
}