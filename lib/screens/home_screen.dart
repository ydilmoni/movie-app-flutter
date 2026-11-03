import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../widgets/movie_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Movie>> moviesFuture = getPopularMovies();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                return MovieGrid(movies: movies);

							},
						),
					),
				]
			);
  }
}