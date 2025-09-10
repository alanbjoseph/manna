import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manna/theme/theme.dart';
import 'util/seed_data.dart';

import 'package:manna/pages/favorites.dart';
import 'package:manna/pages/reminders.dart';
import 'package:manna/pages/settings.dart';
import 'package:manna/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('versesBox');
  await Hive.openBox('favoritesBox');
  await Hive.openBox('settingsBox');

  const currentDatasetVersion = 2;

  final settingsBox = Hive.box('settingsBox');
  final storedVersion = settingsBox.get('datasetVersion', defaultValue: 0);
  bool versesUpdated = false;

  if (storedVersion < currentDatasetVersion) {
    final versesBox = Hive.box('versesBox');
    await versesBox.clear();
    await seedVerses(Hive.box('versesBox'));
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
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Manna',
          initialRoute: '/',
          routes: {
            '/': (context) => HomePage(versesUpdated: versesUpdated),
            '/favorites': (context) => Favorites(),
            '/reminders': (context) => Reminders(),
            '/settings': (context) => Settings(),
          },
          debugShowCheckedModeBanner: false,
          theme: getLightTheme(lightDynamic),
          darkTheme: getDarkTheme(darkDynamic),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
