import 'package:flutter/material.dart';
import 'package:movie_app/providers/storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'screens/movie_list_screen.dart';
import 'providers/movie_lists_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



Future<void> main() async {                         // main שמותר לו לחכות
  WidgetsFlutterBinding.ensureInitialized();        // "Flutter, תתעורר", חובה לפני חבילה שנוגעת במכשיר
  final prefs = await SharedPreferences.getInstance();   // פותח מחברת ומחכה
  runApp(ProviderScope(
    overrides: [prefsProvider.overrideWithValue(prefs)],  // מניח אותה במשבצת
    child: const MainApp(),
  ));
}
class MainApp extends StatefulWidget {
	const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

	int currentTab = 0;   // 0 = Home, 1 = Favorites
	
	@override
	Widget build(BuildContext context) {
		final screens = [
			const HomeScreen(),   // 0
			MovieListScreen(provider: favoritesProvider, emptyMessage: 'No favorites yet.'),
			MovieListScreen(provider: watchlistProvider, emptyMessage: 'Nothing to watch yet.'),
			MovieListScreen(provider: watchedProvider , emptyMessage: 'Nothing watched yet.'),

		];
		return MaterialApp(
      debugShowCheckedModeBanner: false,   // בלי הסרט האדום DEBUG
			theme: appTheme,
			home: Scaffold(
					body: IndexedStack(index: currentTab, children: screens),
					bottomNavigationBar: BottomNavigationBar(
						currentIndex: currentTab,
            type: BottomNavigationBarType.fixed,
						onTap: (index) {
							setState(() {
								currentTab = index;
							});
						},
						items: const [
							BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
							BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Watched'),
						],
				),
			),
		);
  }
}