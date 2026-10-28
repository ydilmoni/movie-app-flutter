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

Future<void> main() async {
  final movies = await getPopularMovies();
  runApp(MainApp(movies: movies));
}

class MainApp extends StatelessWidget {
  final List<Movie> movies;
  const MainApp({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: movies.map((movie)=>MovieCard(movie: movie)).toList(),
        ),
      ),
    );
  }
}
