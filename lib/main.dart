import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'widgets/movie_card.dart';
import 'services/movie_api.dart';

void main() {
  final moviesFuture  = getPopularMovies();
   runApp(MainApp(moviesFuture: moviesFuture));
}

class MainApp extends StatelessWidget {
	final Future<List<Movie>> moviesFuture;
	const MainApp({super.key, required this.moviesFuture});

	@override
	Widget build(BuildContext context) {
	return MaterialApp(
		home: Scaffold(
			body: FutureBuilder<List<Movie>>(
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
						children: movies.map((movie) => MovieCard(movie: movie)).toList(),
									);	
					},
			),
		),
    );
  }
}