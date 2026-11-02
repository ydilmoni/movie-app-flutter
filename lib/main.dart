import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'screens/home_screen.dart';

void main() {
   runApp(const MainApp());
}

class MainApp extends StatefulWidget {
	const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
 	}

	@override
	Widget build(BuildContext context) {
	return MaterialApp(
		home: Scaffold(
				body: HomeScreen(
					isFavorite: isFavorite,
					onToggleFavorite: toggleFavorite,
			),
		),
    );
  }
}