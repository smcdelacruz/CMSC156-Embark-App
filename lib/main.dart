import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'widgets/navbar.dart';
import 'screens/home.dart';
import 'screens/feature_page/feature_page.dart';
import 'screens/feature_page/edit_entry.dart';
import 'screens/archive_entry.dart';
import 'screens/add_entry_stepone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Embark!',

      // === NAMED ROUTES FOR ALL SCREENS ===
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/navbar': (context) => const NavBar(),
        '/home': (context) => const HomeScreen(),
        '/feature': (context) => const FeaturePage(),
        '/add': (context) => AddEntryStep1(),
        '/archive': (context) => const ArchiveEntryScreen(),
        '/edit': (context) => const EditEntryPage(),
      },
    );
  }
}
