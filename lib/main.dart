import 'package:flutter/material.dart';
import 'package:manna/pages/favorites.dart';
//import 'package:manna/pages/home.dart';
import 'package:manna/pages/reminders.dart';
import 'package:manna/pages/settings.dart';
import 'homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'util/seed_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) init Hive
  await Hive.initFlutter();

  // 2) open boxes
  await Hive.openBox('versesBox'); // stores all verses as plain Maps
  await Hive.openBox(
    'favoritesBox',
  ); // stores user's favorites (e.g., keyed by a unique verse key)
  await Hive.openBox('settingsBox'); // stores simple flags/settings

  const currentDatasetVersion = 1;

  final settingsBox = Hive.box('settingsBox');
  final storedVersion = settingsBox.get('datasetVersion', defaultValue: 0);

  bool versesUpdated = false;
  
  if (storedVersion < currentDatasetVersion) {
    final versesBox = Hive.box('versesBox');

    // Wipe old data
    await versesBox.clear();

    // Seed from JSON
    await seedVerses(Hive.box('versesBox'));

    // Update version
    await settingsBox.put('datasetVersion', currentDatasetVersion);

    versesUpdated = true;
  }

  runApp(MyApp(versesUpdated: versesUpdated));
}

class MyApp extends StatelessWidget {
  final bool versesUpdated;
  MyApp({Key? key, required this.versesUpdated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manna',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(versesUpdated: versesUpdated,),
        '/favorites': (context) => Favorites(),
        '/reminders': (context) => Reminders(),
        '/settings': (context) => Settings(),
      },
      debugShowCheckedModeBanner: false,
      //home: HomePage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
