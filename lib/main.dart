import 'package:flutter/material.dart';
import 'models/movie.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'theme/app_theme.dart';

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
	int currentTab = 0;   // 0 = Home, 1 = Favorites
	
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
		final screens = [
			HomeScreen(isFavorite: isFavorite, onToggleFavorite: toggleFavorite),   // 0
			FavoritesScreen(favorites: favorites, onToggleFavorite: toggleFavorite),   // 1
		];
		return MaterialApp(
			theme: appTheme,
			home: Scaffold(
					body: IndexedStack(index: currentTab, children: screens),
					bottomNavigationBar: BottomNavigationBar(
						currentIndex: currentTab,
						onTap: (index) {
							setState(() {
								currentTab = index;
							});
						},
						items: const [
							BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
							BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
						],
				),
			),
		);
  }
}