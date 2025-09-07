import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:manna/pages/favorites.dart';
import 'package:manna/pages/home.dart';
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

    if (widget.versesUpdated && settingsBox.get("hasShownUpdateDialog") != true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Update"),
            content: Text("Verses have been updated."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      });
      settingsBox.put("hasShownUpdateDialog", true);
    }
  }

  int _selectedIndex = 0;

  void _switchPage(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pop();
    });
  }

  final List<Widget> _pages = [Home(), Favorites(), Reminders(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          'Manna',
          style: TextStyle(
            fontFamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(child: Text('Manna App')),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  _switchPage(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  _switchPage(1);
                },
              ),
              Spacer(), //remove after coding the two below
              /*
              ListTile(
                leading: Icon(Icons.alarm),
                title: Text('Reminders'),
                onTap: () {
                  _switchPage(2);
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  _switchPage(3);
                },
              ),
              */
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Exit'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      //title: Text('Remove Favorite'),
                      content: Text('Do you really want to exit?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(
                            'Exit',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            SystemNavigator.pop(); // Remove from Hive
                            //Navigator.pop(context); // Close dialog
                          },
                        ),
                      ],
                    ),
                  );
                  //SystemNavigator.pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('v1.0.0'),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
