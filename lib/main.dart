import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
   runApp(const ProviderScope(child: MainApp()));
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
			const FavoritesScreen(),   // 1
		];
		return MaterialApp(
      debugShowCheckedModeBanner: false,   // בלי הסרט האדום DEBUG
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