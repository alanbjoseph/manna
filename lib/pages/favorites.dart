import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Box favoritesBox = Hive.box('favoritesBox');

    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        } else {
          Navigator.pushReplacementNamed(context, '/');
        }
      }),
      child: Scaffold(
        floatingActionButton: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog.adaptive(
                  title: const Text('Clear Favorites?'),
                  content: const Text(
                    'Are you sure you want to clear all your favorite verses? This action cannot be undone.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await favoritesBox.clear();
                        print('Favorites cleared!');

                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.delete_forever_rounded),
          iconSize: 40,
          color: Theme.of(context).colorScheme.error,
        ),
        body: ValueListenableBuilder(
          valueListenable: favoritesBox.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return Center(child: Text('No favorites yet.'));
            }

            return ListView.separated(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final key = box.keyAt(index);
                final verse = box.getAt(index);

                if (verse == null || verse is! Map) {
                  return SizedBox.shrink();
                }

                return ListTile(
                  title: Text(
                    verse["reference"] ?? 'No reference',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    verse["text"] ?? 'No text',
                    style: TextStyle(fontFamily: 'Lora', fontSize: 17),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_rounded),
                    onPressed: () {
                      final deletedVerse = favoritesBox.get(key);

                      favoritesBox.delete(key);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Removed from favorites"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              favoritesBox.put(key, deletedVerse);
                            },
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          },
        ),
      ),
    );
  }
}
