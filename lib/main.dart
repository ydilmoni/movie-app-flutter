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
	@override
	Widget build(BuildContext context) {
	return MaterialApp(
		home: Scaffold(
			body: Column(
				children: [
					TextField(
					decoration: const InputDecoration(hintText: 'Search movies...'),
					onSubmitted: (String value) {
						setState(() {
							moviesFuture = searchMovies(value);
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
								children: movies.map((movie) => MovieCard(movie: movie)).toList(),
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