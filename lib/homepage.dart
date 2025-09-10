import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:manna/pages/favorites.dart';
import 'package:manna/pages/verses.dart';
import 'package:manna/pages/reminders.dart';
import 'package:manna/pages/settings.dart';

class HomePage extends StatefulWidget {
  final bool versesUpdated;
  const HomePage({Key? key, required this.versesUpdated}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final settingsBox = Hive.box('settingsBox');

    if (widget.versesUpdated &&
        settingsBox.get("hasShownUpdateDialog") != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verses have been updated."),
            duration: Duration(seconds: 3),
          ),
        );
      });
      settingsBox.put("hasShownUpdateDialog", true);
    }
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [VersesPage(), FavoritesPage(), RemindersPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manna'),
        elevation: 4.0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: Scaffold.of(context).openDrawer,
            icon: Icon(Icons.menu_rounded),
          ),
        ),
      ),

      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
            Navigator.pop(context);
          });
        },
        children: const [
          DrawerHeader(child: Center(child: Text('Manna App'))),
          NavigationDrawerDestination(
            icon: Icon(Icons.book),
            label: Text('Verses'),
          ),
          SizedBox(height: 10),
          NavigationDrawerDestination(
            icon: Icon(Icons.favorite),
            label: Text('Favorites'),
          ),
          SizedBox(height: 10),
          NavigationDrawerDestination(
            icon: Icon(Icons.notifications),
            label: Text('Reminders'),
          ),
          SizedBox(height: 10),
          NavigationDrawerDestination(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('v2.0')),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
