import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'widgets/movie_card.dart';
import 'services/movie_api.dart';

// final List<Movie> movies = [                   // 👈 2. הרשימה, מחוץ לכל מחלקה
//   Movie(id: 1, title: "John Wick 1", releaseDate: "2010"),
//   Movie(id: 2, title: "Forrest Gump", releaseDate: "1994"),
//   Movie(id: 3, title: "The Matrix", releaseDate: "1999"),
//   Movie(id: 4, title: "Gladiator", releaseDate: "2000"),
//   Movie(id: 5, title: "The Lion King", releaseDate: "1994"),
// ];

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