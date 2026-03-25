import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'widgets/navbar.dart';
import 'screens/home.dart';
import 'screens/feature_page/feature_page.dart';
import 'screens/feature_page/edit_entry.dart';
import 'screens/archive_entry.dart';
import 'screens/add_entry/add_entry_stepone.dart';
import 'models/stray.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required before async platform calls
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Embark!',

      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent, // 🔥 removes dark overlay
          elevation: 0,
          scrolledUnderElevation: 0, // 🔥 disables darkening on scroll
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/navbar': (context) => const NavBar(),
        '/home': (context) => const HomeScreen(),
        '/feature': (context) {
          final stray = ModalRoute.of(context)!.settings.arguments as Stray;
          return FeaturePage(stray: stray);
        },
        '/add': (context) => AddEntryStep1(),
        '/archive': (context) => const ArchiveEntryScreen(),
        '/edit': (context) => const EditEntryPage(),
      },
    );
  }
}
